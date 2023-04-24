get => textediting/[Edits, Sorting]
get => Lgrep, CommandPallete

class Editor => IContent
    string _path = ""
    bool _num_diff = false
    bool _check_errors = false
    String _modifier = String("")
    List<Vector> _selections = List<Vector>()
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
    Editor Ncurses *n, string path, vector<string> *shared_buffer, IContainer *status_line, CommandPallete *command_pallete =>
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
        this->n = n
    ;
    fn json_path => string doremi $"{_path}.json"
    fn content_change TextEdit edit => 
        let j = load_json(json_path())
        Json *entry = new Json()
        entry->try_add("text", _text.at(_selector.y))
        entry->try_add("type", (int)edit)
        entry->try_add("posy", _selector.y)
        entry->try_add("posx", _selector.x)
        j.try_add("undo", JsonType::Array)
        j.try_add("redo", JsonType::Array)
        select undo from j["undo"]
            undo->add(entry)
            sort_selections()
            foreach selection in _selections
                Json *sel_entry = new Json()
                sel_entry->try_add("text", _text.at(selection.y))
                sel_entry->try_add("type", (int)edit)
                sel_entry->try_add("posy", selection.y)
                sel_entry->try_add("posx", selection.x)
                undo->add(sel_entry)
            ;
        ;
        write_json(json_path(), j)
        j.destruct()
    ;
    fn redo => do undo(false)
    fn undo bool is_undo = true =>
        let getter = is_undo ? "undo" : "redo"
        let setter = is_undo ? "redo" : "undo"
        let j = load_json(json_path())
        let entry = new Json()
        select obj from j[getter]
            let last = obj->size() - 1
            select u from obj->try_get(last)
                let text = u->try_get_value_of("text", (string)"")
                let type = u->try_get_value_of("type", 0.0)
                let posy = u->try_get_value_of("posy", 0.0)
                let posx = u->try_get_value_of("posx", 0.0)
                select store from j[setter]
                    entry->add(new Json("text", text))
                    entry->add(new Json("type", type))
                    entry->add(new Json("posy", posy))
                    entry->add(new Json("posx", posx))
                    store->add(entry)
                    undo_handler(text, (TextEdit)type, Vector(posx, posy), is_undo)
                ;
                obj->pop()
                write_json(json_path(), j)
                entry->destruct()
                delete(entry)
            ;
        ;
    ;
    fn undo_handler string text, TextEdit type, Vector pos, bool is_undo =>
        _selector = pos
        switch type
        case TextEdit::PasteLine
            if !is_undo dobr _text.insert(pos.y+1, text)
            _text.remove(pos.y+1)
            break
        case TextEdit::DeleteLine
            if is_undo dobr _text.insert(pos.y, text)
            _text.remove(pos.y)
            break
        case TextEdit::InsertNl
            if is_undo
                _text.set(pos.y, text)
                _text.remove(pos.y + 1)
            ;
            else do insert_nl(&_selector, 0)
            break
        default dobr _text.set(pos.y, text)
        ;
    ;
pub 
    fn path => string doremi _path
    fn Offset => Vector doremi _origin->Offset()
    fn is_active => bool doremi _origin->Active()
    fn set_active bool active => do _origin->SetActive(active)
    fn set_syntax string syntax =>
        select h from _highlighter do delete(h)
        _highlighter = Some(new Highlighter($"temp.{syntax}"))
    ;
    fn open string path =>
        remove(json_path())
        if _path != path
            _offset = Vector(0,0)
            _selector = Vector(0,0)
            _selections.clear()
            _path = path
            select h from _highlighter do delete(h)
            _highlighter = Some(new Highlighter(path))
            _header->SetLabel($"| {_path}")
            remove(json_path())
        ;
        _text = readlines(_path)
        _content->SetContent(_text)
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
    fn move_to int pos =>
        let diff = pos - 1 - _selector.y
        let dir = diff > 0 ? Dir::Down : Dir::Up
        if dir == Dir::Up do diff *= -1
        move(dir, diff, false)
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
        _header->draw(n)

        //Status
        vector<string> progress = {"▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"}
        let percent = _text.size() - 1 == 0 ? 1 : (double)_selector.y / (double)(_text.size() - 1)
        int current = 7*percent
        let cp = progress[min(current,7)]
        _status_line->SetLabel($" ◁ {_path} $ [{_selector.x},{_selector.y + 1}] {cp}{cp}")
        _status_line->draw(n)

        //Lines
        let vec = List<string>()
        for i until _text.size()
            let num = i + 1 + internal_offset.y
            if _num_diff && num != _selector.y + 1 do num = abs(_selector.y - num + 1)
            if num > _text.size() do continue
            vec.add(to_string(num))
        ;
        _lines->SetContent(vec)
        _lines->draw(n)

        //Content
        > is_within internal_offset (string text, int i) doremi i >= internal_offset.y
        > catch_text internal_offset (string text) doremi internal_offset.x >= text.size() ? "" : text.substr(internal_offset.x)
        let buf = linq::take(_text).where_with_iterator(is_within).operate_async(catch_text).as_list()

        _content->SetContent(buf)
        _content->draw(n)
        select highlighter from _highlighter
            highlighter->highlight(_content, n)
            highlighter->highlight(_status_line, n, true, -2)
            if _check_errors do highlighter->error_check(_content, n, _path, _text, internal_offset)
        ;

        mark_selections(is_current, internal_offset)
    ;
    fn mark_selections bool is_current, Vector internal_offset =>
        if !is_current do return
        let offset = _content->Offset()
        let vec = offset + _selector - internal_offset
        foreach s in _selections
            let s_vec = offset + s - internal_offset
            n->mark(s_vec, 5)
        ;
        n->mark_until(vec.y, offset.x - 5, 2, 5, true)
        if _current_mode == Mode::Insert do n->move_curs(vec)
        else do n->mark(vec, 4)
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
    fn write_content => do write(to_complete_str(), _path)
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
        foreach match in matches
            if match.position > _selector.x do continue
            if match.match.size() + match.position < _selector.x do continue
            matching = match.match
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
        let y = 0
        let reg = regex($"(^|\\W)({matching})($|\\W)")
        let s = _text.at(_selector.y)
        let matches = re(s, reg, 2)
        foreach match in matches
            if match.position <= _selector.x && !is_reverse do continue
            elif match.position == _selector.x do continue
            _selector.x = match.position
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
    fn insert_text string text, Vector *pos, bool suggestions = true =>
        if _text.size() == 0 do _text.add(" ")
        switch text[0]
        case '(' dobr text += ')'
        case '<' dobr text += '>'
        case '{' dobr text += '}'
        case '[' dobr text += ']'
        ;
        insert_snippet(&_text, pos, text)
        try_move(Vector(1, 0), pos)
        if !suggestions || text == " " || _selections.size() > 0 do return
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

                unique_matches.push_back(stringified.to_string())
                if stringified.len() > width do width = stringified.len()
            ;
        ;
        foreach line in _text
            let matches = re(line, reg, 2)
            foreach match in matches
                if match.match == suggestion do continue
                let found_already = false
                foreach um in unique_matches
                    if um == match.match do found_already = true
                ;
                if found_already do continue
                unique_matches.push_back(match.match)
                if match.match.size() > width do width = match.match.size()
            ;
        ;
        if unique_matches.size() == 0 do return
        draw()
        let selected = 0
        let reverse = false
        let space_below = _content->Size().y - 1 - y
        if space_below < 5
            space_below = _content->Size().y / 2
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
                if matching_index + 1 + positioned_y >= _content->Size().y - 1 do break
                let y = offset.y + positioned_y + matching_index - reverse + 1
                n->add_col(y, x - 1, "│", 1)
                n->add_col(y, x + width, "│", 1)
                n->col(selected == matching_index ? 4 : 0)
                n->add_until(
                    y, x, um,
                    _content->Size().x + offset.x - 1,
                    false)
                for i until width - um.size()
                    if x + um.size() + i >= _content->Size().x + offset.x do break
                    n->add(y, x + um.size() + i, " ")
                ;
                n->col(selected == matching_index ? 4 : 0, false)
                matching_index++
            ;
            let box_str = ""
            for i until width do box_str += "─"
            n->add_col(offset.y + positioned_y - reverse, x - 1, $"┌{box_str}┐", 1)
            n->add_col(offset.y + positioned_y - reverse + matching_index + 1, x - 1, $"└{box_str}┘", 1)
            let key = n->key()
            switch key
            case KEY_BTAB
            case 27 do return
            case '\t'
            case '\n'
                insert_text(String(unique_matches[selected]).replace(suggestion, "", 1), &_selector, false)
                move(Dir::Right, unique_matches[selected].size() - suggestion.size() - 1, true)
                return
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
    fn delete_line Vector *pos, bool is_multi = false =>
        if !is_multi do _shared_buffer->clear()
        _shared_buffer->push_back(_text.at(pos->y))
        remove_line(&_text, pos)
    ;
    fn yank_line Vector *pos, bool is_multi = false =>
        if _text.len() == 0 do return
        if !is_multi do _shared_buffer->clear()
        _shared_buffer->push_back(_text.at(pos->y))
    ;
    fn paste_line Vector *pos =>
        if _shared_buffer->size() == 0
            let clipboard = system_output("xclip -o -selection clipboard 2> /dev/null")
            for i until clipboard.size()
                if i != 0 do content_change(TextEdit::PasteLine)
                insert_line(&_text, ++pos->y, String(clipboard.at(i)).strip_end())
            ;
            return
        ;
        for i until _shared_buffer->size()
            if i != 0 do content_change(TextEdit::PasteLine)
            insert_line(&_text, ++pos->y, _shared_buffer->at(i))
        ;
    ;
    fn paste_word Vector *pos =>
        if _shared_buffer->size() == 0
            let clipboard = system_output("xclip -o -selection clipboard 2> /dev/null")
            if clipboard.size() == 0 do return
            if pos->x != 0 do pos->x++
            insert_snippet(&_text, pos, String(clipboard.at(0)).strip_end())
            return
        ;
        if pos->x != 0 do pos->x++
        insert_snippet(&_text, pos, _shared_buffer->at(0))
    ;
    fn shift_line Dir dir =>
        if _selections.size() > 0 do return
        text_editing(TextEdit::DeleteLine)
        if dir == Dir::Up do move(Dir::Up, 2)
        text_editing(TextEdit::PasteLine)
    ;
    fn delete_word Vector *pos, bool spacebreak = false => do remove_word(&_text, pos, spacebreak)
    fn delete_from Vector *pos =>
        let s = _text.at(pos->y)
        _shared_buffer->clear()
        _shared_buffer->push_back(_text.at(pos->y).substr(pos->x))
        remove_until(&_text, pos)
    ;
    fn yank_from =>
        let s = _text.at(_selector.y)
        _shared_buffer->clear()
        _shared_buffer->push_back(_text.at(_selector.y).substr(_selector.x))
    ;
    fn change_case Vector *pos, TextEdit edit =>
        switch edit
        case TextEdit::Upper dobr to_case(&_text, pos, true)
        case TextEdit::Lower dobr to_case(&_text, pos, false)
        ;
    ;
    fn comment_toggle Vector *pos => do commenting(&_text, pos)
    fn try_move Vector dir, Vector* pos, bool can_line_swap = true =>
        if _text.size() == 0 do return
        let y = pos->y
        let x = pos->x
        let is_insert = _current_mode == Mode::Insert
        let h = max(1, (int)_text.size()) - 1
        pos->y = clamp(y + dir.y, 0, h)
        pos->x = clamp(x + dir.x, 0, (int)_text.at(pos->y).size() - 1 + is_insert)
        let w = max(1, _text.at(pos->y).size()) - 1 + is_insert
        if dir.x < 0 && y > 0 && x == 0 && can_line_swap
            pos->y--
            pos->x = max(1, _text.at(pos->y).size()) - 1 + is_insert
        ;
        elif dir.x > 0 && y < h && x == w && can_line_swap
            pos->y++
            pos->x = 0
        ;
    ;
    fn move Dir dir, int multiply = 1, bool can_line_swap = true =>
        Vector vec = Vector()
        switch dir
        case Dir::Up dobr vec = Vector(0, -1)
        case Dir::Down dobr vec = Vector(0, 1)
        case Dir::Left dobr vec = Vector(-1, 0)
        case Dir::Right dobr vec = Vector(1, 0)
        ;
        vec.multiply(multiply)
        try_move(vec, &_selector, can_line_swap)
        vector<Vector> buf = {}
        for i until _selections.size()
            let s = _selections.at_ptr(i)
            try_move(vec, s, can_line_swap)
            if s->x == _selector.x && s->y == _selector.y do continue
            buf.push_back(_selections.at(i))
        ;
        _selections = buf
    ;
    fn move_home =>
        let vec = _selector
        _selector.x = 0
        move_word_impl(Dir::Right, &_selector, false)
        if _selector.x >= vec.x || _selector.y != vec.y
            _selector.x = 0
            _selector.y = vec.y
        ;
        for i until _selections.size()
            let s = _selections.at_ptr(i)
            vec = Vector(s->x, s->y)
            s->x = 0
            move_word_impl(Dir::Right, s, false)
            if s->x >= vec.x || s->y != vec.y
                s->x = 0
                s->y = vec.y
            ;
        ;
    ;
    fn move_word Dir dir, bool spacebreak = false =>
        move_word_impl(dir, &_selector, spacebreak)
        vector<Vector> buf = {}
        for i until _selections.size()
            let s = _selections.at_ptr(i)
            move_word_impl(dir, s, spacebreak)
            if s->x == _selector.x && s->y == _selector.y do continue
            buf.push_back(_selections.at(i))
        ;
        _selections = buf
    ;
    fn move_word_impl Dir dir, Vector *pos, bool spacebreak =>
        loop
            let last_line = pos->y == _text.len() - 1
            let last_char = pos->x == _text.at(pos->y).size() - 1
            if last_line && last_char do return
            let s = String(_text.at(pos->y))
            let opt = s.find_alpha(pos->x, dir == Dir::Left)
            select f from opt
                if f != 0 && s.at(pos->x) != '_' do break
                elif dir == Dir::Right doco try_move(Vector(1, 0), pos)
                else doco try_move(Vector(-1, 0), pos)
            ;
            break
        ;
        if spacebreak dore try_move(Vector(-1, 0), pos)
        loop
            let last_line = pos->y == _text.len() - 1
            let last_char = pos->x == _text.at(pos->y).size() - 1
            if last_line && last_char do return
            let s = String(_text.at(pos->y))
            let opt = s.find_non_alpha(pos->x, dir == Dir::Left)
            select c from opt
                if c != 0 || s.at(pos->x) == '_' do break
                elif dir == Dir::Right doco try_move(Vector(1, 0), pos)
                else doco try_move(Vector(-1, 0), pos)
            ;
            break
        ;
        if dir == Dir::Left do try_move(Vector(-1, 0), pos)
    ;
    fn templates =>
    select h from _highlighter
        _selections.clear()
        let templates = h->syntax().templates()
        let container = HorizontalLayout(Vector(COLS/6*4, LINES/2), Vector(COLS/6, LINES/4))
        let content = List<string>()
        foreach t in templates do content.add(t.template_name)
        container.SetColor(-2)
        container.SetContent(content)
        if templates.size() == 0 do return
        let template_index = 0
        loop
            container.draw(n)
            n->mark_until(
                container.Offset() + Vector(0, template_index),
                4, container.Size().x, true)
            let key = n->key()
            if key == '\n' do break
            if key == 27 do return
            switch key
            case KEY_UP dobr template_index--
            case KEY_DOWN dobr template_index++
            ;
            if template_index < 0 do template_index = 0
            if template_index >= templates.size() do template_index = templates.size() - 1
        ;
        let temp = templates[template_index]
        _modifier = String("")
        _current_mode = Mode::Insert
        draw(6)
        foreach t in temp.templates
            let s = String(t)
            if s.starts_with("%")
                text_editing(TextEdit::InsertNl)
                draw(6)
                continue
            ;
            while s.starts_with("$")
                loop
                    let key = n->key()
                    if key == 127 do break
                    elif key =|= '\n' : ' ' dobr draw(6)
                    elif key == KEY_BACKSPACE
                        text_editing(TextEdit::RemoveChar)
                        draw(6)
                    ;
                    elif isgraph(key)
                        text_editing(TextEdit::Insert, string(1, key))
                        draw(6)
                    ;
                ;
                s.remove(0)
                if s.len() == 0 do break
                while !s.starts_with("$")
                    content_change(TextEdit::Insert)
                    insert_text(string(1, s.at(0)), &_selector, false)
                    draw(6)
                    s.remove(0)
                    if s.len() == 0 do break
                ;
                if s.len() == 0 do break
            ;
            content_change(TextEdit::Insert)
            foreach ch in s.to_string() do insert_text(string(1, ch), &_selector, false)
            draw(6)
        ;
        _current_mode = Mode::Normal
    ;
    ;
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
        let key = n->key()
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
    fn run_all int key => bool
        MEVENT event
        switch key
        case '\t'      dobr text_editing(TextEdit::Tab)
        case KEY_BTAB  dobr text_editing(TextEdit::Untab)
        case KEY_LEFT  dobr move(Dir::Left)
        case KEY_RIGHT dobr move(Dir::Right)
        case KEY_DOWN  dobr move(Dir::Down)
        case KEY_UP    dobr move(Dir::Up)
        case KEY_NPAGE dobr move(Dir::Down, _content->Size().y)
        case KEY_PPAGE dobr move(Dir::Up, _content->Size().y)
        case KEY_END   dobr move(Dir::Right, 100000, false)
        case KEY_HOME  dobr move_home()
        case KEY_SPREVIOUS
        case KEY_SR   dobr shift_line(Dir::Up)
        case KEY_SNEXT
        case KEY_SF dobr shift_line(Dir::Down)
        case KEY_MOUSE
            if getmouse(&event) != OK do break
            if event.bstate & (BUTTON1_CLICKED)
                if event.x < _content->Offset().x do break
                if event.y < _content->Offset().y do break
                if _text.size() == 0 do break
                _selections.clear()
                _selector.x = event.x - _content->Offset().x + _offset.x
                _selector.y = event.y - _content->Offset().y + _offset.y
                move(Dir::Down, 0)
            ;
            if event.bstate & (BUTTON4_PRESSED)
                move(Dir::Up)
                _offset = Vector(_offset.x, _selector.y - _content->Size().y / 2)
                if _offset.y < 0 do _offset.y = 0
            ;
            if event.bstate & (BUTTON5_PRESSED)
                move(Dir::Down)
                _offset = Vector(_offset.x, _selector.y - _content->Size().y / 2)
                if _offset.y < 0 do _offset.y = 0
            ;
            break
        default doremi false
        ;
        return true
    ;
    fn run_base int key => Command
        switch key
        case ':' doremi Command::ModeCmdHan
        case ' ' doremi run_space()
        case 'j' dobr move(Dir::Up)
        case 'k' dobr move(Dir::Down)
        case 'l' dobr move(Dir::Right)
        case 'h' dobr move(Dir::Left)
        case 'n' dobr text_editing(TextEdit::Lower)
        case 'N' dobr text_editing(TextEdit::Upper)
        case 'e' dobr move_word(Dir::Right, true)
        case 'w' dobr move_word(Dir::Right)
        case 'b' dobr move_word(Dir::Left)
        case 'u' dobr undo()
        case 'r' dobr redo()
        case 'p' dobr text_editing(TextEdit::PasteLine)
        case 'P' dobr text_editing(TextEdit::PasteWord)
        case ';' dobr _selections.clear()
        case 'f'
            find()
            center_on_cursor()
            break
        case 'F'
            find(true)
            center_on_cursor()
            break
        default do break
        ;
        return Command::Nop
    ;
    fn run_nor int key => Command
        let cmd = run_base(key)
        if cmd != Command::Nop doremi cmd
        > set_cursor_mode this (int value, bool is_mod = false)
            if (is_mod) do _modifier = String("")
            system($"printf '\e[{value} q'")
            _current_mode = Mode::Insert
            draw(6)
            return Command::ModeInsert
        ;
        switch key
        case 27 dobr _modifier = String("")
        case 'v' 
            _modifier = String("")
            return Command::ModeVisual
        case 'a'
            move(Dir::Right)
            return set_cursor_mode(5, true)
        case 'C'
            text_editing(TextEdit::DeleteFrom)
            return set_cursor_mode(5)
        case 'c'
            run_d()
            return set_cursor_mode(5)
        case 'i' doremi set_cursor_mode(5, true)
        case 'x' dobr text_editing(TextEdit::DeleteChar)
        case 'M' dobr add_selector(true)
        case 'm' dobr add_selector()
        case 'D' dobr text_editing(TextEdit::DeleteFrom)
        case 'd' dobr run_d()
        case 's' dobr run_s()
        case 'R' dobr run_r()
        case 'Y' dobr yank_from()
        case 'y' dobr run_y()
        case 'z' dobr run_z()
        case 'o' dobr _num_diff = !_num_diff
        case 't' dobr _check_errors = !_check_errors
        case 'T' dobr templates()
        default
            if !isdigit(key) do break
            _modifier.append(string(1,key))
            break
        ;
        return Command::Nop
    ;
    fn run_ins int key => Command
        int _ = 0
        switch key
        case 27
            _ = system("printf '\e[2 q'")
            _current_mode = Mode::Normal 
            draw(6)
            return Command::ModeNormal
        case '\n' dobr text_editing(TextEdit::InsertNl)
        case '\b'
        case 127
        case KEY_BACKSPACE dobr text_editing(TextEdit::RemoveChar)
        default dobr text_editing(TextEdit::Insert, string(1, key))
        ;
        return Command::Nop
    ;
    fn run_vis int key => Command
        let cmd = run_base(key)
        if cmd != Command::Nop doremi cmd
        switch key
        case 'i' doremi Command::ModeInsert
        case 27  doremi Command::ModeNormal
        case 'd'
            text_editing(TextEdit::DeleteChar)
            _selections.clear()
            move(Dir::Left, 0)
            break
        case 'x' dobr select_line()
        case 'W' dobr select_word()
        ;
        return Command::Nop
    ;
    fn run_space => Command
        let show = GridLayout(Vector(COLS, 4), Vector(0, LINES - 7))
        show.SetColor(-1)
        vector<string> commands = {
            "f - open file explorer",
            "t - split editor horizontally",
            "v - split editor vertically",
            "h - move to editor left",
            "l - move to editor right",
            "j - move to editor up",
            "k - move to editor down",
            "c - toggle comment",
            "P - paste word from clipboard",
            "p - open command pallete",
            "s - open file searcher",
            ""
        }
        foreach c in commands
            let ele = new IContainer(Fill::Flex)
            ele->SetContent(List<string>({c}))
            show.add_element(ele)
        ;
        for i until 4 do show.add_row()
        show.draw(n)
        show.destruct()
        let result = TextEditOrCommand(Command::Nop)
        switch n->key()
        case 'f' doremi Command::ModeFileEx
        case 't' doremi Command::SplitHorizontal
        case 'v' doremi Command::SplitVertical
        case 'h' doremi Command::EditorLeft
        case 'l' doremi Command::EditorRight
        case 'j' doremi Command::EditorUp
        case 'k' doremi Command::EditorDown
        case 'c' dobr text_editing(TextEdit::CommentToggle)
        case 'P'
            _shared_buffer->clear()
            text_editing(TextEdit::PasteLine)
            break
        case 'p'
            result = _command_pallete->show(n)
            select edit from result.textedit do text_editing(edit)
            select command from result.command doremi command
            break
        case 's' 
            select fp from Lgrep(n) do open(fp)
            break
        ;
        return Command::ModeNormal
    ;
    fn run_d => Command
        let edit_cmd = Option<TextEdit>()
        switch n->key()
        case 'd' dobr edit_cmd = Some(TextEdit::DeleteLine)
        case 'w' dobr edit_cmd = Some(TextEdit::DeleteWord)
        case 'e' dobr edit_cmd = Some(TextEdit::DeleteWordExlusive)
        ;
        select edit from edit_cmd
            select num from _modifier.to_num()
                if num == 0 do text_editing(edit)
                for i until num
                    text_editing(edit, i != 0)
                ;
                _modifier = String("")
                return Command::Nop
            ;
            text_editing(edit)
        ;
        return Command::Nop
    ;
    fn run_y => Command
        switch n->key()
        case 'y' do break
        default doremi Command::Nop
        ;
        select num from _modifier.to_num()
            if num == 0 do yank_line(&_selector)
            for i until num
                yank_line(&_selector, i != 0)
                move(Dir::Down)
            ;
            _modifier = String("")
            return Command::Nop
        ;
        yank_line(&_selector)
        return Command::Nop
    ;
    fn center_on_cursor =>
        let vec = Vector(_offset.x, _selector.y - _content->Size().y / 2)
        _offset = vec.y < 0 ? Vector(vec.x, 0) : vec
    ;
    fn run_z => Command
        let vec = Vector(_offset.x, _selector.y)
        switch n->key()
        case 'z'
        case '.' dobr vec.y -= _content->Size().y / 2
        case 'b' dobr vec.y -= _content->Size().y
        case 't' do break
        default doremi Command::ModeNormal
        ;
        _offset = vec.y < 0 ? Vector(vec.x, 0) : vec
        return Command::ModeNormal
    ;
    fn run_s => Command
        let search = ""
        loop
            n->clearLn(LINES - 1)
            n->add_col(LINES - 1, 0, "search:", 3)
            n->add(LINES - 1, 8, search)
            n->add_col(LINES - 1, 8 + search.size(), '|', 1)
            let key = n->key()
            switch key
            case '\n' 
                if !find(search) do find(search, true)
                center_on_cursor()
                n->clearLn(LINES - 1)
                return Command::Nop
            case 27
                n->clearLn(LINES - 1)
                return Command::Nop
            case '\b'
            case 127
            case KEY_BACKSPACE 
                if search.size() == 0
                    n->clearLn(LINES - 1)
                    return Command::Nop
                ;
                search.pop_back()
                break
            default
                if isgraph(key) do search += key
                break
            ;
        ;
        return Command::Nop
    ;
    extend => editor/[R]
;