get => Lgrep
class Editor => IContent
    string _path = ""
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
    Mode _current_mode = Mode::Normal
    Editor Ncurses *n, string path, vector<string> *shared_buffer, IContainer *status_line =>
        _origin = new VerticalLayout()
        _highlighter = Some(new Highlighter(path))
        _status_line = status_line

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
        entry->try_add_str("text", _text.at(_selector.y))
        entry->try_add("type", (int)edit)
        entry->try_add("posy", _selector.y)
        entry->try_add("posx", _selector.x)
        j.try_add("undo", JsonType::Array)
        j.try_add("redo", JsonType::Array)
        select undo from j.try_get("undo")
            undo->add(entry)
            sort_selections()
            foreach selection in _selections
                Json *sel_entry = new Json()
                sel_entry->try_add_str("text", _text.at(selection.y))
                sel_entry->try_add("type", (int)edit)
                sel_entry->try_add("posy", selection.y)
                sel_entry->try_add("posx", selection.x)
                undo->add(sel_entry)
            ;
        ;
        write_json(json_path(), j)
    ;
    fn redo => do undo(false)
    fn undo => do undo(true)
    fn undo bool is_undo =>
        let getter = is_undo ? "undo" : "redo"
        let setter = is_undo ? "redo" : "undo"
        let j = load_json(json_path())
        select obj from j.try_get(getter)
            let last = obj->size() - 1
            select u from obj->try_get(last)
                select text_obj from u->try_get("text")
                select type_obj from u->try_get("type")
                select posy_obj from u->try_get("posy")
                select posx_obj from u->try_get("posx")
                select store from j.try_get(setter)
                    Json *entry = new Json()
                    let text = text_obj->value_or((string)"")
                    let type = type_obj->value_or(0.0)
                    let posy = posy_obj->value_or(0.0)
                    let posx = posx_obj->value_or(0.0)
                    entry->add(new Json("text", text))
                    entry->add(new Json("type", type))
                    entry->add(new Json("posy", posy))
                    entry->add(new Json("posx", posx))
                    store->add(entry)
                    undo_handler(text, (TextEdit)type, Vector(posx, posy), is_undo)
                ;;;;;
                obj->pop()
                write_json(json_path(), j)
            ;
        ;
    ;
    fn undo_handler string text, TextEdit type, Vector pos, bool is_undo =>
        _selector = pos
        switch type
        case TextEdit::PasteLine
            if !is_undo dobr _text.insert(pos.y+1, text)
            else dobr _text.remove(pos.y+1)
        case TextEdit::DeleteLine
            if is_undo dobr _text.insert(pos.y, text)
            else dobr _text.remove(pos.y)
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
    fn open string path =>
        remove(json_path())
        if _path != path
            _offset = Vector(0,0)
            _selector = Vector(0,0)
            _selections.clear()
            _path = path
            _highlighter = Some(new Highlighter(path))
            _header->SetLabel($"| {_path}")
            remove(json_path())
        ;
        _text = readlines(_path)
        _content->SetContent(_text)
    ;
    fn close =>
        set_active(false)
        remove(json_path())
    ;
    fn move_to int pos =>
        let diff = (pos - 1) - _selector.y
        let dir = diff > 0 ? Dir::Down : Dir::Up
        if dir == Dir::Up do diff *= -1
        move(dir, diff, false)
    ;
    fn get_internal_offset => Vector
        let size = _content->Size()
        let x = size.x - 1
        let y = size.y - 1
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
    fn draw => do draw(5)
    fn draw short color =>
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
        List<string> vec = List<string>()
        for i until _text.size() 
            let num = i + 1 + internal_offset.y
            if num > _text.size() do break
            vec.add(to_string(num))
        ;
        _lines->SetContent(vec)
        _lines->draw(n)

        //Content
        List<string> buf = List<string>()
        for i until _text.size()
            if i < internal_offset.y do continue
            let text = _text.at(i)
            if internal_offset.x >= text.size() doco buf.add("")
            text = text.substr(internal_offset.x)
            buf.add(text)
        ;

        _content->SetContent(buf)
        _content->draw(n)
        select highlighter from _highlighter
            highlighter->highlight(_content, n)
            highlighter->highlight(_status_line, n, true, -2)
        ;

        mark_selections(is_current, internal_offset)
    ;
    fn mark_selections bool is_current, Vector internal_offset =>
        //Selections
        if is_current
            let offset = _content->Offset()
            let y = offset.y + _selector.y - internal_offset.y
            let x = offset.x + _selector.x - internal_offset.x
            foreach s in _selections
                n->mark(
                    offset.y + s.y - internal_offset.y,
                    offset.x + s.x - internal_offset.x, 5)
            ;
            n->mark_until(y, offset.x - 5, 2, 5, true)
            if _current_mode == Mode::Insert do n->move_curs(y, x)
            else do n->mark(y, x, 4)
        ;
    ;
    fn write_content =>
        let content = ""
        for i until _text.len()
            content += _text.at(i)
            if i < _text.len() - 1 do content += "\n"
        ;
        write(String(content).strip(), _path)
    ;
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
    fn find => string doremi find(false, true)
    fn find bool is_reverse => string doremi find(is_reverse, true)
    fn find bool is_reverse, bool should_move => string
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
    fn find string matching => do find(matching, false)
    fn find string matching, bool is_reverse =>
        if _text.size() == 0 do return
        if matching == "" do return
        let y = 0
        let reg = regex($"(^|\\W)({matching})($|\\W)")
        let s = _text.at(_selector.y)
        let matches = re(s, reg, 2)
        foreach match in matches
            if match.position <= _selector.x && !is_reverse do continue
            elif match.position == _selector.x do continue
            _selector.x = match.position
            return
        ;
        if !is_reverse
            foreach line in _text
                if y <= _selector.y doco y++
                matches = re(line, reg, 2)
                if matches.size() > 0
                    _selector.x = matches[0].position
                    _selector.y = y
                    return
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
                    return
                ;
                y--
            ;
        ;
    ;
    fn tab Vector *pos =>
        let s = String(_text.at(pos->y))
        s.insert("    ", 0)
        _text.set(pos->y, s.to_string())
        try_move(Vector(4,0), pos)
    ;
    fn untab Vector *pos =>
        let s = String(_text.at(pos->y))
        _text.set(pos->y, s.strip_front(4))
        if pos->x < 4 do try_move(Vector(-pos->x, 0), pos)
        else do try_move(Vector(-4,0), pos)
    ;
    fn insert_nl Vector *pos, int amount =>
        pos->y += amount
        let s = String(_text.at(pos->y))
        _text.set(pos->y, s.substr(0, pos->x))
        _text.insert(pos->y + 1, s.substr(pos->x))
        pos->y++
        pos->x = 0
    ;
    fn insert_text string text, Vector *pos, bool suggestions = true =>
        if _text.size() == 0 do _text.add(" ")
        let s = String(_text.at(pos->y))
        s.insert(text, pos->x)
        _text.set(pos->y, s.to_string())
        try_move(Vector(1, 0), pos)
        if !suggestions || text == " " || _selections.size() > 0 do return
        let suggestion = find(false, false)
        if suggestion.size() == 0 do return
        foreach ch in suggestion
            if !isalpha(ch) && ch != '_' do return
        ;
        let reg = regex($"(^|\\W)({suggestion}[\\w_]*)")
        let offset = _content->Offset()
        let y = offset.y + _selector.y - _offset.y
        let x = offset.x + _selector.x - _offset.x
        let width = 0
        vector<string> unique_matches = {}
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
        let max_size = min(unique_matches.size(), _content->Size().y - 1 - y)
        loop
            let matching_index = 0
            foreach um in unique_matches
                if matching_index + 1 + y >= _content->Size().y do break
                n->col(selected == matching_index ? 4 : 5)
                n->add_until(
                    y + matching_index + 1,
                    x, um,
                    _content->Size().x + offset.x,
                    false)
                for i until width - um.size()
                    if x + um.size() + i >= _content->Size().x + offset.x do break
                    n->add(
                        y + matching_index + 1,
                        x + um.size() + i,
                        " ")
                ;
                n->col(selected == matching_index ? 4 : 5, false)
                matching_index++
            ;
            let key = n->key()
            switch key
            case 27 do return
            case '\n'
                insert_text(String(unique_matches[selected]).replace(suggestion, ""), &_selector, false)
                move_word(Dir::Right, true)
                _selector.x++
                return
            case KEY_UP dobr selected = max(selected - 1, 0)
            case KEY_DOWN dobr selected = min(selected + 1, max_size - 1)
            case KEY_LEFT dore move(Dir::Left)
            case KEY_RIGHT dore move(Dir::Right) 
            case '\b'
            case 127
            case KEY_BACKSPACE dore text_editing(TextEdit::RemoveChar)
            default dore text_editing(TextEdit::Insert, string(1, key))
            ;
        ;
    ;
    fn remove_ch Vector *pos => do remove_ch(pos, false)
    fn remove_ch Vector *pos, bool should_move =>
        if should_move
            if pos->x == 0 do return
            try_move(Vector(-1, 0), pos)
        ;
        let s = String(_text.at(pos->y))
        s.remove(pos->x)
        _text.set(pos->y, s.to_string())
    ;
    fn delete_line Vector *pos => do delete_line(pos, false)
    fn delete_line Vector *pos, bool is_multi =>
        if _text.len() <= 1 do return
        if !is_multi do _shared_buffer->clear()
        _shared_buffer->push_back(_text.at(pos->y))
        if pos->y == _text.len() - 1 dore _text.set(pos->y, " ")
        _text.remove(pos->y)
    ;
    fn yank_line Vector *pos => do yank_line(pos, false)
    fn yank_line Vector *pos, bool is_multi =>
        if _text.len() == 0 do return
        if !is_multi do _shared_buffer->clear()
        _shared_buffer->push_back(_text.at(pos->y))
    ;
    fn paste_line Vector *pos =>
        for i until _shared_buffer->size()
            if i != 0 do content_change(TextEdit::PasteLine)
            let buf = _shared_buffer->at(i)
            _text.insert(++pos->y, buf)
        ;
    ;
    fn paste_word Vector *pos =>
        if _shared_buffer->size() == 0 do return
        let buf = _shared_buffer->at(0)
        let s = String(_text.at(pos->y))
        if pos->x == 0 do s.insert(buf, pos->x) 
        else do s.insert(buf, ++pos->x)
        _text.set(pos->y, s.to_string())
    ;
    fn delete_word Vector *pos => do delete_word(pos, false)
    fn delete_word Vector *pos, bool spacebreak =>
        let s = String(_text.at(pos->y))
        s.remove_word(pos->x, spacebreak)
        _text.set(pos->y, s.to_string())
    ;
    fn delete_from Vector *pos =>
        let s = _text.at(pos->y)
        _shared_buffer->clear()
        _shared_buffer->push_back(_text.at(pos->y).substr(pos->x))
        _text.set(pos->y, _text.at(pos->y).substr(0, pos->x))
    ;
    fn yank_from =>
        let s = _text.at(_selector.y)
        _shared_buffer->clear()
        _shared_buffer->push_back(_text.at(_selector.y).substr(_selector.x))
    ;
    fn change_case Vector *pos, TextEdit edit =>
        if _text.size() == 0 do return
        if _text.at(pos->y).size() == 0 do return
        let ch = _text.at(pos->y).at(pos->x)
        switch edit
        case TextEdit::Upper dobr _text.at_ptr(pos->y)->at(pos->x) = toupper(ch)
        case TextEdit::Lower dobr _text.at_ptr(pos->y)->at(pos->x) = tolower(ch)
        ;
    ;
    fn comment_toggle Vector *pos =>
        if _text.size() == 0 do return
        if _text.at(pos->y).size() == 0 dore _text.set(pos->y, "//")
        let stringified = String(_text.at(pos->y))
        if stringified.starts_with("//")
            _text.set(pos->y, stringified.replace("//", "", 1))
        ;
        else do _text.set(pos->y, "//" + stringified.to_string())
    ;
    fn try_move Vector dir, Vector* pos => do try_move(dir, pos, true)
    fn try_move Vector dir, Vector* pos, bool can_line_swap =>
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
    fn move Dir dir => do move(dir, 1, true)
    fn move Dir dir, int multiply => do move(dir, multiply, true)
    fn move Dir dir, int multiply, bool can_line_swap =>
        Vector vec
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
    fn move_word Dir dir, => do move_word(dir, false)
    fn move_word Dir dir, bool spacebreak =>
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
                if f != 0 do break
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
                if c != 0 do break
                elif dir == Dir::Right doco try_move(Vector(1, 0), pos)
                else doco try_move(Vector(-1, 0), pos)
            ;
            break
        ;
        if dir == Dir::Left do try_move(Vector(-1, 0), pos)
    ;
    fn run Mode mode => Command doremi run(mode, false)
    fn run Mode mode, bool internal_run => Command
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
        switch key
        case '\t'      dobr text_editing(TextEdit::Tab)
        case KEY_BTAB  dobr text_editing(TextEdit::Untab)
        case KEY_LEFT  dobr move(Dir::Left)
        case KEY_RIGHT dobr move(Dir::Right)
        case KEY_DOWN  dobr move(Dir::Down)
        case KEY_UP    dobr move(Dir::Up)
        case KEY_NPAGE dobr move(Dir::Down, _content->Size().y)
        case KEY_PPAGE dobr move(Dir::Up, _content->Size().y)
        case KEY_HOME  dobr move(Dir::Left, 100000, false)
        case KEY_END   dobr move(Dir::Right, 100000, false)
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
        case 'f' dobr find()
        case 'F' dobr find(true)
        case 'p' dobr text_editing(TextEdit::PasteLine)
        case 'P' dobr text_editing(TextEdit::PasteWord)
        case ';' dobr _selections.clear()
        default do break
        ;
        return Command::Nop
    ;
    fn run_nor int key => Command
        let cmd = run_base(key)
        if cmd != Command::Nop doremi cmd
        switch key
        case 27 dobr _modifier = String("")
        case 'v' 
            _modifier = String("")
            return Command::ModeVisual
        case 'a'
            _modifier = String("")
            system("printf '\e[5 q'")
            _current_mode = Mode::Insert
            move(Dir::Right)
            draw(6)
            return Command::ModeInsert
        case 'i'
            _modifier = String("")
            system("printf '\e[5 q'")
            _current_mode = Mode::Insert
            draw(6)
            return Command::ModeInsert
        case 'C'
            text_editing(TextEdit::DeleteFrom)
            system("printf '\e[5 q'")
            _current_mode = Mode::Insert
            draw(6)
            return Command::ModeInsert
        case 'c'
            run_d()
            system("printf '\e[5 q'")
            _current_mode = Mode::Insert
            draw(6)
            return Command::ModeInsert
        case 'x' dobr text_editing(TextEdit::DeleteChar)
        case 'M' dobr add_selector(true)
        case 'm' dobr add_selector()
        case 'D' dobr text_editing(TextEdit::DeleteFrom)
        case 'd' dobr run_d()
        case 's' dobr run_s()
        case 'Y' dobr yank_from()
        case 'y' dobr run_y()
        case 'z' dobr run_z()
        default
            if !isdigit(key) do break
            _modifier.append(string(1,key))
            break
        ;
        return Command::Nop
    ;
    fn run_ins int key => Command
        switch key
        case 27
            system("printf '\e[2 q'")
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
            break
        case 'x' dobr select_line()
        ;
        return Command::Nop
    ;
    fn run_space => Command
        switch n->key()
        case 'f' doremi Command::ModeFileEx
        case 't' doremi Command::SplitHorizontal
        case 'v' doremi Command::SplitVertical
        case 'h' doremi Command::EditorLeft
        case 'l' doremi Command::EditorRight
        case 'j' doremi Command::EditorUp
        case 'k' doremi Command::EditorDown
        case 'c' dobr text_editing(TextEdit::CommentToggle)
        case 'p' doremi command_pallete()
        case 's' 
            select fp from Lgrep(n) do open(fp)
            doremi Command::ModeNormal
        ;
        return Command::Nop
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
        default return Command::Nop
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
    fn run_z => Command
        switch n->key()
        case '.'
            _offset = Vector(_offset.x, _selector.y - _content->Size().y / 2)
            break
        case 't'
            _offset = Vector(_offset.x, _selector.y)
            break
        case 'b'
            _offset = Vector(_offset.x, _selector.y - _content->Size().y)
            break
        ;
        if _offset.y < 0 do _offset.y = 0
        return Command::ModeNormal
    ;
    fn run_s => Command
        let search = ""
        loop
            n->clearLn(LINES - 1)
            n->add(LINES - 1, 0, "search: " + search)
            let key = n->key()
            switch key
            case '\n' 
                find(search)
                n->clearLn(LINES - 1)
                doremi Command::Nop
            case 27
                n->clearLn(LINES - 1)
                doremi Command::Nop
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
                if any(key, {',', ' ', '/', ':', '.', '_', '-', '<', '>'}) do search += key
                elif isalpha(key) do search += key
                break
            ;
        ;
        return Command::Nop
    ;
    fn command_pallete => Command
        let pos = 0
        let search = ""
        let commands = Dictionary<string, Command>()
        let textedits = Dictionary<string, TextEdit>()
        let buf = List<string>()
        let pallete_found = IContainer()
        let pallete_search = IContainer(Fill::Static, Vector(0, 1))
        let pallete_window = VerticalLayout(
            Vector(COLS/2, 10),
            Vector(COLS/4, LINES/4))
        
        commands.add(" exit", Command::Exit)
        commands.add(" mode normal", Command::ModeNormal)
        commands.add(" mode insert", Command::ModeInsert)
        commands.add(" mode visual", Command::ModeVisual)
        commands.add(" mode file explorer", Command::ModeFileEx)
        commands.add(" mode file explorer", Command::ModeCmdHan)
        commands.add(" editor write", Command::WriteEditor)
        commands.add(" editor close", Command::CloseEditor)
        commands.add(" editor write and close", Command::WriteCloseEditor)
        commands.add(" editor split horizontal", Command::SplitHorizontal)
        commands.add(" editor split vertical", Command::SplitVertical)
        commands.add(" editor move left", Command::EditorLeft)
        commands.add(" editor move right", Command::EditorRight)
        commands.add(" editor move up", Command::EditorUp)
        commands.add(" editor move down", Command::EditorDown)
        
        textedits.add(" tab", TextEdit::Tab)
        textedits.add(" untab", TextEdit::Untab)
        textedits.add(" insert new line", TextEdit::InsertNl)
        textedits.add(" remove char behind cursor", TextEdit::RemoveChar)
        textedits.add(" remove char under cursor", TextEdit::DeleteChar)
        textedits.add(" remove word", TextEdit::DeleteWord)
        textedits.add(" remove word without removing extra space", TextEdit::DeleteWordExlusive)
        textedits.add(" remove line", TextEdit::DeleteLine)
        textedits.add(" remove from cursor to end", TextEdit::DeleteFrom)
        textedits.add(" paste line/lines from buffer below", TextEdit::PasteLine)
        textedits.add(" paste line/lines from buffer on to current lien", TextEdit::PasteWord)
        textedits.add(" lower case", TextEdit::Lower)
        textedits.add(" upper case", TextEdit::Upper)
        textedits.add(" toggle comment", TextEdit::CommentToggle)

        pallete_window.SetColor(-3)
        pallete_search.SetColor(2)
        pallete_window.add(&pallete_search)
        pallete_window.add(&pallete_found)

        let match = ""
        loop
            pallete_search.SetLabel(" " + search)
            buf.clear()
            foreach command in commands.keys()
                if command.find(search) == -1 do continue
                buf.add(command)
            ;
            foreach edit in textedits.keys()
                if edit.find(search) == -1 do continue
                buf.add(edit)
            ;
            pallete_found.SetContent(buf)
            pallete_window.draw(n)
            n->mark_until((LINES/4) + 1 + pos, COLS/4, 4, COLS/2)
            let key = n->key()
            switch key
            case KEY_DOWN dobr pos++
            case KEY_UP dobr pos--
            case KEY_PPAGE dobr pos-=1000
            case KEY_NPAGE dobr pos+=1000
            case 27 doremi Command::Nop
            case '\n'
                if pos >= buf.size() do break
                match = buf.at(pos)
                select value from commands.try_get_value(match) doremi value
                select value from textedits.try_get_value(match)
                    text_editing(value)
                    return Command::Nop
                ;
                break
            case '\b'
            case 127
            case KEY_BACKSPACE
                if search.size() == 0 do break
                search.pop_back()
                break
            default
                if any(key, {',', ' ', '/', ':', '.', '_', '-', '<', '>'}) do search += key
                elif isalpha(key) do search += key
                break
            ;
            if pos > buf.size() - 1 do pos = buf.size() - 1
            if pos > 8 do pos = 8
            if pos < 0 do pos = 0
        ;
        return Command::Nop
    ;
;

fn selection_comparer Vector &lhs, Vector &rhs => bool
    if lhs.y < rhs.y doremi false
    if lhs.y > rhs.y doremi true
    return lhs.x > rhs.x
;

fn selection_comparer_rev Vector &lhs, Vector &rhs => bool
    if lhs.y > rhs.y doremi false
    if lhs.y < rhs.y doremi true
    return lhs.x > rhs.x
;

fn selection_comparer_ptr Vector* &lhs, Vector* &rhs => bool
    if lhs->y < rhs->y doremi false
    if lhs->y > rhs->y doremi true
    return lhs->x > rhs->x
;

fn selection_comparer_rev_ptr Vector* &lhs, Vector* &rhs => bool
    if lhs->y > rhs->y doremi false
    if lhs->y < rhs->y doremi true
    return lhs->x > rhs->x
;