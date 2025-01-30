get => textediting/[Edits, Sorting]
get => Lgrep, CommandPallete, LSP

class Editor => IContent
    string _path = ""
    bool _num_diff = false
    bool _check_errors = false
    String _modifier = String("")
    List<Vector> _selections = List<Vector>()
    List<string> _previously_opened_files = List<string>()
    List<int> _position_in_documents = List<int>()
    int _position_in_history = 0
    Vector _selector = Vector(0,0)
    Vector _offset = Vector(0,0)
    Vector _global_size = Vector(COLS,LINES)
    IContainer *_header = new IContainer(Fill::Static, Vector(0,1))
    IContainer *_lines = new IContainer(Fill::Static, Vector(5,0))
    IContainer *_content = new IContainer()
    HorizontalLayout *_base = new HorizontalLayout()
    vector<string> *_shared_buffer
    IContainer *_status_line
    CommandPallete *_command_pallete
    Mode _current_mode = Mode::Normal
    Editor string path, vector<string> *shared_buffer, IContainer *status_line, CommandPallete *command_pallete =>
        _origin = new VerticalLayout()
        _highlighter = Some(new Highlighter(path))
        _status_line = status_line
        _command_pallete = command_pallete

        _lines->SetColor(3)
        _header->SetColor(5)
        _content->SetColor(0)

        _base->add(_lines)
        _base->add(_content)
        _origin->add(_header)
        _origin->add(_base)
        _shared_buffer = shared_buffer
        open(path)
    ;
    fn json_path => string doremi $"{_path}.json"
pub 
    fn path => string doremi _path
    fn Offset => Vector doremi _origin->Offset()
    fn is_active => bool doremi _origin->Active()
    fn set_active bool active => do _origin->SetActive(active)
    fn set_syntax string syntax =>
        select h from _highlighter do delete(h)
        _highlighter = Some(new Highlighter($"temp.{syntax}"))
    ;
    fn open string path, int found_at_line = 0, bool is_navigate = false =>
        remove(json_path())
        if _path != path
            if _position_in_documents.len() > 0 && !is_navigate
                let pos_vec = _position_in_documents.as_vec_ptr()
                pos_vec->at(_position_in_history) = _selector.y + 1
            ;
            _offset = Vector(0,0)
            _selector = Vector(0,0)
            _selections.clear()
            _path = path
            select h from _highlighter
                h->destruct()
                delete(h)
            ;
            _highlighter = Some(new Highlighter(path))
            _header->SetLabel($"| {_path}")
            remove(json_path())
        ;
        _text = readlines(_path)
        _content->SetContent(_text)
        move_to(found_at_line)
        center_on_cursor()
        if !is_navigate && _path != ""
            _previously_opened_files.add(_path)
            _position_in_documents.add(found_at_line)
            _position_in_history = _previously_opened_files.size() - 1
        ;
    ;
    fn navigate bool is_forward =>
        let forward_pos = min(_position_in_history + 1, _previously_opened_files.size() - 1)
        let backward_pos = max(_position_in_history - 1, 0)
        let position_in_history = is_forward ? forward_pos : backward_pos
        if _position_in_history == position_in_history do return
        let pos_vec = _position_in_documents.as_vec_ptr()
        pos_vec->at(_position_in_history) = _selector.y + 1
        _position_in_history = position_in_history
        open(_previously_opened_files[_position_in_history], _position_in_documents[_position_in_history], true)
    ;
    fn close => Editor*
        set_active(false)
        remove(json_path())
        delete(_header)
        delete(_lines)
        delete(_content)    
        delete(_base)
        select h from _highlighter do delete(h)
        return this
    ;
    fn get_internal_offset => Vector
        let size = _content->Size()
        let x = size.x - 1
        let y = size.y - 1
        if _selector.x < 0 do _selector.x = 0
        if _selector.y < 0 do _selector.y = 0
        if _selector.y > y + _offset.y
            _offset.y = _selector.y - y
        ;
        if _selector.x > x + _offset.x
            _offset.x = _selector.x - x
        ;
        if _selector.x < _offset.x
            _offset.x = _selector.x
        ;
        if _selector.y < _offset.y
            _offset.y = _selector.y
        ;
        return _offset
    ;
    fn draw short color = 5 =>
        if !is_active() do return
        let is_current = color == 6
        let internal_offset = get_internal_offset()

        //Header
        _header->SetColor(color)
        _header->SetLabel($"| {_path}")
        _header->draw()

        //Status
        vector<string> progress = {"▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"}
        let percent = _text.size() - 1 == 0 ? 1 : (double)_selector.y / (double)(_text.size() - 1)
        int current = 7*percent
        let cp = progress[min(current,7)]
        _status_line->SetLabel($" ◁ {_path} $ [{_selector.x},{_selector.y + 1}] {cp}{cp}")
        _status_line->draw()

        //Lines
        let vec = List<string>()
        for i until _text.size()
            let num = i + 1 + internal_offset.y
            if _num_diff && num != _selector.y + 1 do num = abs(_selector.y - num + 1)
            if num > _text.size() do continue
            vec.add(to_string(num))
        ;
        _lines->SetContent(vec)
        _lines->draw()

        //Content
        > is_within internal_offset (string text, int i) doremi i >= internal_offset.y
        > catch_text internal_offset (string text) doremi internal_offset.x >= text.size() ? "" : text.substr(internal_offset.x)
        let buf = linq::take(_text).where_with_iterator(is_within).operate_async(catch_text).as_list()

        _content->SetContent(buf)
        _content->draw()
        select highlighter from _highlighter
            highlighter->highlight(_content)
            highlighter->highlight(_status_line, true, -2)
            if _check_errors do highlighter->error_check(_content, _path, _text, internal_offset)
        ;

        mark_selections(is_current, internal_offset)
    ;
    fn mark_selections bool is_current, Vector internal_offset =>
        if !is_current do return
        let offset = _content->Offset()
        let vec = offset + _selector - internal_offset
        foreach s in _selections
            let s_vec = offset + s - internal_offset
            Ncurses::mark(s_vec, 5)
        ;
        Ncurses::mark_until(vec.y, offset.x - 5, 2, 5, true)
        if _current_mode == Mode::Insert do Ncurses::move_curs(vec)
        else do Ncurses::mark(vec, 4)
    ;
    fn to_complete_str => string
        let content = ""
        foreach i, line in _text
            content += line
            if i < _text.len() - 1 do content += "\n"
        ;
        return String(content).strip_end()
    ;
    fn has_changes => bool
        if _path == "" doremi false
        if _text.len() == 0 doremi false
        select content from read(_path)
            return String(content).strip_end() != to_complete_str()
        ;
        return true
    ;
    fn write_content => do write(to_complete_str() + "\n", _path)
    fn sort_selections => do sort(_selections.begin(), _selections.end(), &selection_comparer)
    fn sort_selections_rev => do sort(_selections.begin(), _selections.end(), &selection_comparer_rev)
    fn add_selector bool is_word = false =>
        _selections.add(_selector)
        if !is_word do try_move(Vector(0,1), &_selector)
        else do find()
    ;
    fn select_line =>
        let line = _text.at(_selector.y)
        if line.size() == 0 do return
        if _selector.x == line.size() - 1 && _selector.y < _text.size() - 1
            _selector.y++
            line = _text.at(_selector.y)
            if line.size() == 0 do return
        ;
        for i until _selections.size()
            if _selections.at(_selections.size() - 1 - i).y == _selector.y
                _selections.remove(_selections.size() - 1 - i)
            ;
        ;
        for i until line.size()
            _selections.add(Vector(i, _selector.y))
        ;
        _selector.x = line.size() - 1
    ;
    fn select_word =>
        _selections.clear()
        let x = _selector.x
        move_word_impl(Dir::Right, &_selector, true)
        for i until _selector.x - x
            _selections.add(Vector(_selector.x - i, _selector.y))
        ;
        _selector.x = x
    ;
    fn text_editing TextEdit te => do text_editing(te, None<string>(), false)
    fn text_editing TextEdit te, bool is_multi => do text_editing(te, None<string>(), is_multi)
    fn text_editing TextEdit te, string text => do text_editing(te, Some(text), false)
    fn text_editing TextEdit te, Option<string> text_opt, bool is_multi =>
        if _text.size() == 0 do _text.add("")
        content_change(te)
        List<Vector*> selections = List<Vector*>({&_selector})
        let text = ""
        select t from text_opt do text = t
        for i until _selections.size()
            selections.add(_selections.at_ptr(i))
        ;
        sort(selections.begin(), selections.end(), &selection_comparer_ptr)
        let index = 0
        switch te
        case TextEdit::Tab
            foreach s in selections do tab(s)
            break
        case TextEdit::Untab
            foreach s in selections do untab(s)
            break
        case TextEdit::Insert
            foreach s in selections do insert_text(text, s)
            get_suggestions(text, &_selector)
            break
        case TextEdit::InsertNl
            sort(selections.begin(), selections.end(), &selection_comparer_rev_ptr)
            foreach s in selections do insert_nl(s, index++)
            break
        case TextEdit::RemoveChar
            foreach s in selections do remove_ch(s, true)
            break
        case TextEdit::DeleteChar
            foreach s in selections do remove_ch(s)
            break
        case TextEdit::DeleteLine
            foreach s in selections do delete_line(s, is_multi)
            move(Dir::Right, 0)
            break
        case TextEdit::DeleteFrom
            foreach s in selections do delete_from(s)
            break
        case TextEdit::DeleteWord
            foreach s in selections do delete_word(s, true)
            break
        case TextEdit::DeleteWordExlusive
            foreach s in selections do delete_word(s)
            break
        case TextEdit::PasteLine
            sort(selections.begin(), selections.end(), &selection_comparer_rev_ptr)
            foreach s in selections do paste_line(s)
            break
        case TextEdit::PasteWord
            foreach s in selections do paste_word(s)
            break
        case TextEdit::Upper
        case TextEdit::Lower
            foreach s in selections do change_case(s, te)
            break
        case TextEdit::CommentToggle
            foreach s in selections do comment_toggle(s)
            break
        default do break
        ;
    ;
    fn find bool is_reverse = false, bool should_move = true => string
        if _text.size() == 0 do return ""
        let s = _text.at(_selector.y)
        if s.size() == 0 do return ""
        let matches = re(s, R"(([A-z_]*))", 1)
        let matching = ""
        foreach m in matches
            if m.position > _selector.x do continue
            if m.reg_match.size() + m.position < _selector.x do continue
            matching = m.reg_match
            break
        ;
        if should_move do find(matching, is_reverse)
        return matching
    ;
    fn find string matching => bool doremi find(matching, "", false, false)
    fn find string matching, string replace => bool doremi find(matching, replace, false, true)
    fn find string matching, bool is_reverse => bool doremi find(matching, "", is_reverse, false)
    fn find string matching, string replace, bool is_reverse, bool is_replace => bool
        if _text.size() == 0 do return false
        if matching == "" do return false
        regex reg = regex(".*")
        vector<RegexMatch> matches = {}
        let y = 0
        let s = _text.at(_selector.y)
        let reg_str = $"(^|\\W)({matching}.*)($|\\W)"
        try {reg = regex(reg_str);} catch (...) {return false;}
        try {matches = re(s, reg, 2);} catch (...) {return false;}
        foreach m in matches
            if m.position <= _selector.x && !is_reverse do continue
            elif m.position == _selector.x do continue
            _selector.x = m.position
            if is_replace
                for i until matching.size()
                    remove_ch(&_selector)
                ;
                insert_text(replace, &_selector, false)
                return true
            ;
            return false
        ;
        if !is_reverse
            foreach line in _text
                if y <= _selector.y doco y++
                matches = re(line, reg, 2)
                if matches.size() > 0
                    _selector.x = matches[0].position
                    _selector.y = y
                    if is_replace
                        for i until matching.size()
                            remove_ch(&_selector)
                        ;
                        insert_text(replace, &_selector, false)
                        return true
                    ;
                    return false
                ;
                y++
            ;
        ;
        else
            y = _text.size() - 1
            for i until _text.size()
                if y >= _selector.y doco y--
                matches = re(_text.at(y), reg, 2)
                if matches.size() > 0
                    _selector.x = matches[matches.size()-1].position
                    _selector.y = y
                    if is_replace
                        for i until matching.size()
                            remove_ch(&_selector)
                        ;
                        insert_text(replace, &_selector, false)
                        return true
                    ;
                    return false
                ;
                y--
            ;
        ;
        return false
    ;
    fn tab Vector *pos =>
        let v = new Vector(0, pos->y)
        if pos->y > 0 && pos->y < _text.len()
            let previous_line = _text.at(pos->y - 1)
            let current_line = _text.at(pos->y)
            let previous_tab_text = 0
            let current_tab_text = 0
            let new_tab_text = ""
            foreach c in previous_line
                if c != ' ' do break
                previous_tab_text++ 
            ;
            foreach c in current_line
                if c != ' ' do break
                current_tab_text++
            ;
            let diff = max(previous_tab_text - current_tab_text, 0)
            if diff >= 1
                for i until diff do new_tab_text += " "
                insert_snippet(&_text, v, new_tab_text)
                delete(v)
                try_move(Vector(diff,0), pos)
                return
            ;
        ;
        insert_snippet(&_text, v, "    ")
        delete(v)
        try_move(Vector(4,0), pos)
    ;
    fn untab Vector *pos =>
        strip_front(&_text, pos, 4)
        if pos->x < 4 do try_move(Vector(-pos->x, 0), pos)
        else do try_move(Vector(-4,0), pos)
    ;
    fn insert_nl Vector *pos, int amount =>
        pos->y += amount
        insert_newline(&_text, pos)
        pos->y++
        pos->x = 0
    ;
    fn get_suggestions string text, Vector *pos, bool suggestions = true =>
        if !suggestions || text == " " || pos != &_selector || text.size() > 1 do return
        let suggestion = find(false, false)
        if suggestion.size() == 0 do return
        foreach ch in suggestion
            if !isalpha(ch) && ch != '_' do return
        ;
        let reg = regex($"(^|\\W)({suggestion}[\\w_]*)")
        let offset = _content->Offset()
        let internal_offset = get_internal_offset()
        let y = _selector.y - internal_offset.y
        let x = offset.x + _selector.x - internal_offset.x
        let width = 0
        vector<string> unique_matches = {}
        select highlighter from _highlighter
            let wordlist = highlighter->wordlist()
            foreach word in wordlist
                let stringified = String(word)
                if !stringified.starts_with(suggestion) do continue
                if word == suggestion do continue
                unique_matches.push_back(stringified.to_string())
                if stringified.len() > width do width = stringified.len()
            ;
        ;
        foreach line in _text
            let matches = re(line, reg, 2)
            foreach m in matches
                if m.reg_match == suggestion do continue
                let found_already = false
                foreach um in unique_matches
                    if um == m.reg_match do found_already = true
                ;
                if found_already do continue
                unique_matches.push_back(m.reg_match)
                if m.reg_match.size() > width do width = m.reg_match.size()
            ;
        ;
        if unique_matches.size() == 0 do return
        draw()
        let selected = 0
        let reverse = false
        let space_below = _content->Size().y - 1 - y
        if space_below <= y
            space_below = y - 1
            reverse = true
        ;
        let max_size = min(unique_matches.size(), space_below)
        if x + width >= _content->Size().x + offset.x
            width = _content->Size().x + offset.x - x - 1
        ;
        loop
            let matching_index = 0
            let positioned_y = reverse ? y - max_size : y
            foreach um in unique_matches
                if matching_index + 1 + positioned_y >= _content->Size().y do break
                let y = offset.y + positioned_y + matching_index - reverse + 1
                Ncurses::add_col(y, x - 1, "│", 1)
                Ncurses::add_col(y, x + width, "│", 1)
                Ncurses::col(selected == matching_index ? 4 : 0)
                Ncurses::add_until(
                    y, x, um,
                    _content->Size().x + offset.x - 1,
                    false)
                for i until width - um.size()
                    if x + um.size() + i >= _content->Size().x + offset.x do break
                    Ncurses::add(y, x + um.size() + i, " ")
                ;
                Ncurses::col(selected == matching_index ? 4 : 0, false)
                matching_index++
            ;
            let box_str = ""
            for i until width
                box_str += "─"
            ;
            Ncurses::add_col(offset.y + positioned_y - reverse, x - 1, $"┌{box_str}┐", 1)
            Ncurses::add_col(offset.y + positioned_y - reverse + matching_index + 1, x - 1, $"└{box_str}┘", 1)
            let key = Ncurses::key()
            switch key
            case KEY_BTAB
            case 27 do return
            case '\t'
            case '\n' dore text_editing(TextEdit::Insert, String(unique_matches[selected]).replace(suggestion, "", 1))
            case KEY_UP dobr selected = max(selected - 1, 0)
            case KEY_DOWN dobr selected = min(selected + 1, max_size - 1)
            case KEY_LEFT dore move(Dir::Left)
            case KEY_RIGHT dore move(Dir::Right)
            case KEY_HOME dore move_home()
            case KEY_END dore move(Dir::Right, 100000, false)
            case KEY_PPAGE dobr selected = 0
            case KEY_NPAGE dobr selected = max_size - 1
            case '\b'
            case 127
            case KEY_BACKSPACE dore text_editing(TextEdit::RemoveChar)
            default dore text_editing(TextEdit::Insert, string(1, key))
            ;
        ;
    ;
    fn insert_text string text, Vector *pos, bool suggestions = true =>
        if _text.size() == 0 do _text.add(" ")
        let output = match text[0]
            '(' => do "()"
            '<' => do "<>"
            '{' => do "{}"
            '[' => do "[]"
            _ => do text
        ;
        insert_snippet(&_text, pos, output)
        try_move(Vector(text.size(), 0), pos)
    ;
    fn remove_ch Vector *pos, bool should_move = false =>
        if should_move
            if pos->x == 0
                if pos->y == 0 || _selections.len() != 0 do return
                text_editing(TextEdit::DeleteLine)
                move(Dir::Up, 1)
                move(Dir::Right, 100000, false)
                if _shared_buffer->size() != 0 && _shared_buffer->at(0).size() > 0
                    text_editing(TextEdit::PasteWord)
                ;
                return
            ;
            try_move(Vector(-1, 0), pos)
        ;
        if _current_mode == Mode::Visual && pos->x == 0 && _text.at(pos->y).size() == 0
            text_editing(TextEdit::DeleteLine)
        ;
        else do remove_char(&_text, pos)
    ;
    fn shift_line Dir dir =>
        if _selections.size() > 0 do return
        text_editing(TextEdit::DeleteLine)
        if dir == Dir::Up do move(Dir::Up, 2)
        text_editing(TextEdit::PasteLine)
    ;
    fn change_case Vector *pos, TextEdit edit =>
        switch edit
        case TextEdit::Upper dobr to_case(&_text, pos, true)
        case TextEdit::Lower dobr to_case(&_text, pos, false)
        ;
    ;
    fn comment_toggle Vector *pos => do commenting(&_text, pos)
    fn run Mode mode, bool internal_run = false => Command
        _current_mode = mode
        if internal_run 
            draw(6)
            if _global_size.x != COLS || _global_size.y != LINES
                _global_size = Vector(COLS,LINES)
                return Command::Nop
            ;
        ;
        let cmd = Command::Nop
        let key = Ncurses::key()
        if key == KEY_F(1) doremi cmd = Command::Terminal
        if !run_all(key)
            switch _current_mode
            case Mode::Normal dobr cmd = run_nor(key)
            case Mode::Insert dobr cmd = run_ins(key)
            case Mode::Visual dobr cmd = run_vis(key)
            default do break
            ;
        ;
        return cmd == Command::Nop ? run(_current_mode, true) : cmd
    ;
    extend => editor/[Replace, Search, ViewPort, Yank, Delete, Paste]
    extend => editor/[Space, Visual, Insert, Normal, Base, All, Templates]
    extend => editor/[Move, Undo]
;
