class Editor => IContent
    string _path = ""
    vector<Vector> _selections = {}
    Vector _selector = Vector(0,0)
    IContainer *_header
    IContainer *_lines
    IContainer *_content
    HorizontalLayout *_base
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
pub 
    fn is_active => bool doremi _origin->Active()
    fn set_active bool active => do _origin->SetActive(active)
    fn open string path =>
        _path = path
        _header->SetLabel("| " + _path)
        _text = readlines(_path)
        _content->SetContent(_text)
    ;
    fn draw => do draw(5)
    fn draw short color =>
        if !is_active() do return
        //Header
        _header->SetColor(color)
        _header->SetLabel("| " + _path)
        _header->draw(n)

        //Lines
        vector<string> vec = {}
        for i until _lines->Size().y do vec.push_back(to_string(i+1))
        _lines->SetContent(vec)
        _lines->draw(n)

        //Content
        _content->SetContent(_text)
        _content->draw(n)

        //Selections
        let offset = _content->Offset()
        n->mark(_selector.y + 1, offset.x + _selector.x, 4)
        foreach s in _selections
            n->mark(s.y + 1, offset.x + s.x, 5)
        ;
    ;
    fn sort_selections => do sort(_selections.begin(), _selections.end(), &selection_comparer)
    fn add_selector =>
        _selections.push_back(_selector)
        try_move(Vector(0,1), &_selector)
    ;
    fn text_editing TextEdit te => Command doremi text_editing(te, None<string>())
    fn text_editing TextEdit te, string text => Command doremi text_editing(te, Some(text))
    fn text_editing TextEdit te, Option<string> text_opt => Command
        if _text.size() == 0 do _text.push_back("")
        vector<Vector*> selections = {&_selector}
        let text = ""
        select t from text_opt do text = t

        for i until _selections.size()
            selections.push_back(&_selections.at(i))
        ;
        sort_selections()

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
        case TextEdit::RemoveChar
            foreach s in selections do remove_ch(s, true)
            break
        case TextEdit::DeleteChar
            foreach s in selections do remove_ch(s)
            break
        case TextEdit::DeleteLine
            foreach s in selections do delete_line(s)
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
        _text.at(pos->y) = s.to_string()
        try_move(Vector(4,0), pos)
    ;
    fn untab Vector *pos =>
        let s = String(_text.at(pos->y))
        _text.at(pos->y) = s.strip_front(4)
        if pos->x < 4 do try_move(Vector(-pos->x, 0), pos)
        else do try_move(Vector(-4,0), pos)
    ;
    fn insert_text string text, Vector *pos =>
        if _text.size() == 0 do _text.push_back(" ")
        let s = String(_text.at(pos->y))
        s.insert(text, pos->x)
        _text.at(pos->y) = s.to_string()
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
        _text.at(pos->y) = s.to_string()
    ;
    fn delete_line Vector *pos =>
        vector<string> buf = {}
        for i until _text.size()
            if i == pos->y do continue
            buf.push_back(_text.at(i))
        ;
        _text = buf
    ;
    fn delete_word Vector *pos => do delete_word(pos, false)
    fn delete_word Vector *pos, bool spacebreak =>
        let s = String(_text.at(pos->y))
        s.remove_word(pos->x, spacebreak)
        _text.at(pos->y) = s.to_string()
    ;
    fn change_case Vector *pos, TextEdit edit =>
        if _text.size() == 0 do return
        let ch = _text.at(pos->y).at(pos->x)
        switch edit
        case TextEdit::Upper dobr _text.at(pos->y).at(pos->x) = toupper(ch)
        case TextEdit::Lower dobr _text.at(pos->y).at(pos->x) = tolower(ch)
        ;
    ;
    fn try_move Vector dir, Vector* pos =>
        if _text.size() == 0 do return
        let y = pos->y
        let x = pos->x
        let h = max(1, (int)_text.size()) - 1
        pos->y = clamp(y + dir.y, 0, h)
        pos->x = clamp(x + dir.x, 0, (int)_text.at(pos->y).size() - 1)
        let w = max(1, _text.at(pos->y).size()) - 1
        if dir.x < 0 && y > 0 && x == 0
            pos->y--
            pos->x = max(1, _text.at(pos->y).size()) - 1
        ;
        elif dir.x > 0 && y < h && x == w
            pos->y++
            pos->x = 0
        ;
    ;
    fn move Dir dir => Command doremi move(dir, 1)
    fn move Dir dir, int multiply => Command
        Vector vec
        switch dir
        case Dir::Up dobr vec = Vector(0, -1)
        case Dir::Down dobr vec = Vector(0, 1)
        case Dir::Left dobr vec = Vector(-1, 0)
        case Dir::Right dobr vec = Vector(1, 0)
        ;
        vec.multiply(multiply)
        try_move(vec, &_selector)
        vector<Vector> buf = {}
        for i until _selections.size()
            let s = &_selections.at(i)
            try_move(vec, s)
            if s->x == _selector.x && s->y == _selector.y do continue
            buf.push_back(_selections.at(i))
        ;
        _selections = buf
        return Command::Nop
    ;
    fn move_word Dir dir => do move_word(dir, false)
    fn move_word Dir dir, bool spacebreak =>
        loop
            let s = String(_text.at(_selector.y))
            let opt = s.find_alpha(_selector.x, dir == Dir::Left)
            select f from opt
                if f != 0 do break
                elif dir == Dir::Right doco try_move(Vector(1, 0), &_selector)
                else doco try_move(Vector(-1, 0), &_selector)
            ;
            break
        ;
        if spacebreak dore try_move(Vector(-1, 0), &_selector)
        loop
            let s = String(_text.at(_selector.y))
            let opt = s.find_non_alpha(_selector.x, dir == Dir::Left)
            select c from opt
                if c != 0 do break
                elif dir == Dir::Right doco try_move(Vector(1, 0), &_selector)
                else doco try_move(Vector(-1, 0), &_selector)
            ;
            break
        ;
        if dir == Dir::Left do try_move(Vector(-1, 0), &_selector)
    ;
    fn run Mode mode => Command
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
        case KEY_HOME  doremi move(Dir::Left, _content->Size().x)
        case KEY_END   doremi move(Dir::Right, _content->Size().x)
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
        case ';' dobr _selections = {}
        default do break
        ;
        return Command::Nop
    ;
    fn run_nor int key => Command
        let cmd = run_base(key)
        if cmd != Command::Nop doremi cmd
        switch key
        case 'v' doremi Command::ModeVisual
        case 'i' doremi Command::ModeInsert
        case 'x' dobr text_editing(TextEdit::DeleteChar)
        case 'm' dobr add_selector()
        case 'd' dobr run_d()
        ;
        return Command::Nop
    ;
    fn run_ins int key => Command
        switch key
        case 27 doremi Command::ModeNormal
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