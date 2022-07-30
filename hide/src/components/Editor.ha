class Editor => IContent
    string _path = ""
    List<Vector> _selections = List<Vector>()
    Vector _selector = Vector(0,0)
    IContainer *_header
    IContainer *_lines
    IContainer *_content
    HorizontalLayout *_base
    Mode _current_mode = Mode::Normal
    Editor Ncurses *n, string path =>
        _header = new IContainer(Fill::Static, Vector(0,1))
        _lines = new IContainer(Fill::Static, Vector(5,0))
        _content = new IContainer()
        _base = new HorizontalLayout()
        _origin = new VerticalLayout()

        _lines->SetColor(3)
        _header->SetColor(5)
        _content->SetColor(0)

        _base->add(_lines)
        _base->add(_content)
        _origin->add(_header)
        _origin->add(_base)
        open(path)
        this->n = n
    ;
    fn json_path => string doremi _path + ".json"
pub 
    fn content_change TextEdit edit => 
        let j = load_json(json_path())
        Json *entry = new Json()
        entry->try_add("text", _text.at(_selector.y))
        entry->try_add("type", to_string((int)edit))
        entry->try_add("posy", to_string(_selector.y))
        entry->try_add("posx", to_string(_selector.x))
        j.try_add("undo", "[]")
        j.try_add("redo", "[]")
        select undo from j.try_get("undo") do undo->add(entry)
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
        switch type
        case TextEdit::Untab
        case TextEdit::Insert
        case TextEdit::RemoveChar
        case TextEdit::DeleteChar
        case TextEdit::DeleteWord
        case TextEdit::Upper
        case TextEdit::Lower
        case TextEdit::DeleteWordExlusive
        case TextEdit::Tab dobr _text.set(pos.y, text)
        case TextEdit::DeleteLine
            if is_undo dobr _text.insert(pos.y, text)
            else dobr _text.remove(pos.y)
        case TextEdit::InsertNl
            if is_undo
                _text.set(pos.y, text)
                _text.remove(pos.y + 1)
            ;
            else do insert_nl(&pos, 0)
            break
        default do break
        ;
    ;
    fn path => string doremi _path
    fn is_active => bool doremi _origin->Active()
    fn set_active bool active => do _origin->SetActive(active)
    fn open string path =>
        remove(json_path())
        _path = path
        _header->SetLabel("| " + _path)
        _text = readlines(_path)
        _content->SetContent(_text)
    ;
    fn close =>
        set_active(false)
        remove(json_path())
    ;
    fn draw => do draw(5)
    fn draw short color =>
        if !is_active() do return
        //Header
        _header->SetColor(color)
        _header->SetLabel("| " + _path)
        _header->draw(n)

        //Lines
        List<string> vec = List<string>()
        for i until _text.size() do vec.add(to_string(i+1))
        _lines->SetContent(vec)
        _lines->draw(n)

        //Content
        _content->SetContent(_text)
        _content->draw(n)

        //Selections
        if color != 6 do return
        let offset = _content->Offset()
        let y = offset.y + _selector.y
        let x = offset.x + _selector.x
        foreach s in _selections
            n->mark(offset.y + s.y, offset.x + s.x, 5)
        ;
        if _current_mode == Mode::Insert do n->move_curs(y, x)
        else do n->mark(y, x, 4)
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
    fn text_editing TextEdit te => Command doremi text_editing(te, None<string>())
    fn text_editing TextEdit te, string text => Command doremi text_editing(te, Some(text))
    fn text_editing TextEdit te, Option<string> text_opt => Command
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
            foreach s in selections do delete_line(s)
            move(Dir::Down)
            move(Dir::Up)
            move(Dir::Left, 1000)
            move(Dir::Right)
            break
        case TextEdit::DeleteWord
            foreach s in selections do delete_word(s, true)
            break
        case TextEdit::DeleteWordExlusive
            foreach s in selections do delete_word(s)
            break
        case TextEdit::Upper
        case TextEdit::Lower
            foreach s in selections do change_case(s, te)
            break
        default do break
        ;
        return Command::Nop
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
    fn delete_line Vector *pos =>
        if _text.len() <= 1 do return
        _text.remove(pos->y)
    ;
    fn delete_word Vector *pos => do delete_word(pos, false)
    fn delete_word Vector *pos, bool spacebreak =>
        let s = String(_text.at(pos->y))
        s.remove_word(pos->x, spacebreak)
        _text.set(pos->y, s.to_string())
    ;
    fn change_case Vector *pos, TextEdit edit =>
        if _text.size() == 0 do return
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
    fn move Dir dir => Command doremi move(dir, 1, true)
    fn move Dir dir, int multiply => Command doremi move(dir, multiply, true)
    fn move Dir dir, int multiply, bool can_line_swap => Command
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
        return Command::Nop
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
    fn run Mode mode => Command
        _current_mode = mode
        let key = n->key()
        switch key
        case '\t'      doremi text_editing(TextEdit::Tab)
        case KEY_BTAB  doremi text_editing(TextEdit::Untab)
        case KEY_LEFT  doremi move(Dir::Left)
        case KEY_RIGHT doremi move(Dir::Right)
        case KEY_DOWN  doremi move(Dir::Down)
        case KEY_UP    doremi move(Dir::Up)
        case KEY_NPAGE doremi move(Dir::Down, _content->Size().y)
        case KEY_PPAGE doremi move(Dir::Up, _content->Size().y)
        case KEY_HOME  doremi move(Dir::Left, _content->Size().x, false)
        case KEY_END   doremi move(Dir::Right, _content->Size().x, false)
        ;
        switch mode
        case Mode::Normal doremi run_nor(key)
        case Mode::Insert doremi run_ins(key)
        case Mode::Visual doremi run_vis(key)
        default do break
        ;
        return Command::Nop
    ;
    fn run_base int key => Command
        switch key
        case ':' doremi Command::ModeCmdHan
        case ' ' doremi run_space()
        case 'j' dobr move(Dir::Up)
        case 'k' dobr move(Dir::Down)
        case 'l' dobr move(Dir::Right)
        case 'h' dobr move(Dir::Left)
        case 'a' dobr text_editing(TextEdit::Lower)
        case 'A' dobr text_editing(TextEdit::Upper)
        case 'e' dobr move_word(Dir::Right, true)
        case 'w' dobr move_word(Dir::Right)
        case 'b' dobr move_word(Dir::Left)
        case 'u' dobr undo()
        case 'r' dobr redo()
        case ';' dobr _selections.clear()
        default do break
        ;
        return Command::Nop
    ;
    fn run_nor int key => Command
        let cmd = run_base(key)
        if cmd != Command::Nop doremi cmd
        switch key
        case 'v' doremi Command::ModeVisual
        case 'a'
            _current_mode = Mode::Insert
            move(Dir::Right)
            draw(6)
            return Command::ModeInsert
        case 'i' 
            _current_mode = Mode::Insert
            draw(6)
            return Command::ModeInsert
        case 'x' dobr text_editing(TextEdit::DeleteChar)
        case 'm' dobr add_selector()
        case 'd' dobr run_d()
        ;
        return Command::Nop
    ;
    fn run_ins int key => Command
        switch key
        case 27
            move(Dir::Left)
            _current_mode = Mode::Normal 
            draw(6)
            return Command::ModeNormal
        case '\n' dobr text_editing(TextEdit::InsertNl)
        case '\b'
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
        ;
        return Command::Nop
    ;
    fn run_d => Command
        switch n->key()
        case 'd' doremi text_editing(TextEdit::DeleteLine)
        case 'w' doremi text_editing(TextEdit::DeleteWord)
        case 'e' doremi text_editing(TextEdit::DeleteWordExlusive)
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