class Editor => IContent
    string _path = ""
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
        _path = "| " + path
        _text = readlines(_path)
    ;
    fn draw => do draw(5)
    fn draw short color =>
        if !is_active() do return
        _header->SetColor(color)
        //Header
        _header->SetLabel(_path)
        _header->draw(n)

        //Lines
        vector<string> vec = {}
        for i until _lines->Size().y do vec.push_back(to_string(i+1))
        _lines->SetContent(vec)
        _lines->draw(n)

        //Content
        _content->SetContent(_text)
        _content->draw(n)
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
