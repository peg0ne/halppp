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
    fn add_selector =>
        _selections.push_back(_selector)
        try_move(Vector(1,0), &_selector)
    ;
    fn try_delete_ch =>
        delete_ch(&_selector)
        sort(_selections.begin(), _selections.end(), &selection_comparer)
        foreach s in _selections do delete_ch(&s)
    ;
    fn delete_ch Vector *pos =>
        let s = _text.at(pos->y)
        let updated = ""
        if s.size() == 0 do return
        if pos->x >= s.size() && pos->x != 0 do return
        updated += s.substr(0, pos->x)
        updated += s.substr(pos->x + 1)
        _text.at(pos->y) = updated
    ;
    fn try_move Vector dir, Vector* pos =>
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
    fn move Dir dir =>
        Vector vec
        switch dir
        case Dir::Up dobr vec = Vector(0, -1)
        case Dir::Down dobr vec = Vector(0, 1)
        case Dir::Left dobr vec = Vector(-1, 0)
        case Dir::Right dobr vec = Vector(1, 0)
        ;
        try_move(vec, &_selector)
        vector<Vector> buf = {}
        for i until _selections.size()
            let s = &_selections.at(i)
            try_move(vec, s)
            if s->x == _selector.x && s->y == _selector.y do continue
            buf.push_back(_selections.at(i))
        ;
        _selections = buf
    ;
    fn run Mode mode => Command
        let key = n->key()
        switch key
        case ':' doremi Command::ModeCmdHan
        case ' ' doremi run_space()
        case 'j' dobr move(Dir::Up)
        case 'k' dobr move(Dir::Down)
        case 'l' dobr move(Dir::Right)
        case 'h' dobr move(Dir::Left)
        default do break
        ;
        switch mode
        case Mode::Normal doremi run_nor(key)
        case Mode::Insert doremi run_ins(key)
        case Mode::Visual doremi run_vis(key)
        default do break
        ;
        return Command::Nop
    ;
    fn run_nor int key => Command
        switch key
        case 'v' doremi Command::ModeVisual
        case 'i' doremi Command::ModeInsert
        case 'x' dobr try_delete_ch()
        case 'm' dobr add_selector()
        ;
        return Command::Nop
    ;
    fn run_ins int key => Command
        switch key
        case 'v' doremi Command::ModeVisual
        case 27 doremi Command::ModeNormal
        ;
        return Command::Nop
    ;
    fn run_vis int key => Command
        switch key
        case 'i' doremi Command::ModeInsert
        case 27 doremi Command::ModeNormal
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
;

fn selection_comparer Vector &lhs, Vector &rhs => bool
    if lhs.y < rhs.y doremi true
    if lhs.y > rhs.y doremi false
    return lhs.x > rhs.x
;