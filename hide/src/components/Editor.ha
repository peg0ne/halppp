class Editor => IContent
    string _path = ""
    String _modifier = String("")
    List<Vector> _selections = List<Vector>()
    Vector _selector = Vector(0,0)
    Vector _offset = Vector(0,0)
    Vector _global_size = Vector(COLS,LINES)
    IContainer *_header
    IContainer *_lines
    IContainer *_content
    HorizontalLayout *_base
    vector<string> *_shared_buffer
    IContainer *_status_line
    Mode _current_mode = Mode::Normal
    Editor Ncurses *n, string path, vector<string> *shared_buffer, IContainer *status_line =>
        _header = new IContainer(Fill::Static, Vector(0,1))
        _lines = new IContainer(Fill::Static, Vector(5,0))
        _content = new IContainer()
        _base = new HorizontalLayout()
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
    fn json_path => string doremi _path + ".json"
    fn content_change TextEdit edit => 
        let j = load_json(json_path())
        Json *entry = new Json()
        entry->try_add_str("text", _text.at(_selector.y))
        entry->try_add("type", (int)edit)
        entry->try_add("posy", _selector.y)
        entry->try_add("posx", _selector.x)
        j.try_add("undo", "[]")
        j.try_add("redo", "[]")
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
                let text = u->try_get("text").value_unsafe()->value_or((string)"")
                let type = u->try_get("type").value_unsafe()->value_or(0.0)
                let posy = u->try_get("posy").value_unsafe()->value_or(0.0)
                let posx = u->try_get("posx").value_unsafe()->value_or(0.0)
                select store from j.try_get(setter)
                    obj->pop()
                    store->add(u)
                ;
                write_json(json_path(), j)
                undo_handler(text, (TextEdit)type, Vector(posx, posy), is_undo)
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
            _header->SetLabel("| " + _path)
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
        _header->SetLabel("| " + _path)
        _header->draw(n)

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
        write(content, _path)
    ;
    fn sort_selections => do sort(_selections.begin(), _selections.end(), &selection_comparer)
    fn sort_selections_rev => do sort(_selections.begin(), _selections.end(), &selection_comparer_rev)
    fn add_selector =>
        _selections.add(_selector)
        try_move(Vector(0,1), &_selector)
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
            move(Dir::Down)
            move(Dir::Up)
            move(Dir::Left, 1000)
            move(Dir::Right)
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
        default do break
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
    fn insert_text string text, Vector *pos =>
        if _text.size() == 0 do _text.add(" ")
        let s = String(_text.at(pos->y))
        s.insert(text, pos->x)
        _text.set(pos->y, s.to_string())
        try_move(Vector(1, 0), pos)
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
        _text.remove(pos->y)
    ;
    fn yank_line Vector *pos =>
        if _text.len() == 0 do return
        _shared_buffer->clear()
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
    fn change_case Vector *pos, TextEdit edit =>
        if _text.size() == 0 do return
        if _text.at(pos->y).size() == 0 do return
        let ch = _text.at(pos->y).at(pos->x)
        switch edit
        case TextEdit::Upper dobr _text.at_ptr(pos->y)->at(pos->x) = toupper(ch)
        case TextEdit::Lower dobr _text.at_ptr(pos->y)->at(pos->x) = tolower(ch)
        ;
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
        case 'm' dobr add_selector()
        case 'D' dobr text_editing(TextEdit::DeleteFrom)
        case 'd' dobr run_d()
        case 's' dobr run_s()
        case 'y' dobr run_y()
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
        case 'y' dobr yank_line(&_selector)
        ;
        return Command::Nop
    ;
    fn run_s => Command
        switch n->key()
        case 's' do break
        case 'w' do break
        case 'l' do break
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
 












