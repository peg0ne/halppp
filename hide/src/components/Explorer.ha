class Explorer => IContent
    string _path = "."
    int _pos = 0
    Explorer Ncurses *n =>
        _text = list_files(_path)
        _origin = new IContainer(Fill::Static, Vector(25,0))
        _origin->SetColor(2)
        _origin->SetContent(_text)
        this->n = n
    ;
pub 
    fn draw => do n->mark_until(_pos, 0, 6, _origin->Size().x)
    fn set_visibility Mode mode => do _origin->SetActive(mode == Mode::FileEx)
    fn toggle => Command
        _origin->SetActive(!_origin->Active())
        return Command::ModeNormal
    ;
    fn update =>
        _text = list_files(_path)
        _origin->SetContent(_text)
    ;
    fn get_fp => string
        string fp = _path.substr(2)
        _path = "."
        update()
        return fp
    ;
    fn move_and_reset => Command doremi move_and_reset(Command::Nop)
    fn move_and_reset Command cmd => Command
        _text = list_files(_path)
        _pos = 0
        move(Dir::Up)
        return cmd
    ;
    fn move Dir dir =>  
        switch dir
        case Dir::Up dobr _pos = clamp(_pos - 1, 0, _text.size() - 1)
        case Dir::Down dobr _pos = clamp(_pos + 1, 0, _text.size() - 1)
        ;
    ;
    fn choose => Command
        let p = _text.at(_pos)
        if p == "." doremi Command::Nop
        if p == ".." && _path != "."
            while _path.back() != '/' do _path.pop_back()
            _path.pop_back()
            return move_and_reset(Command::Nop)
        ;
        _path += "/" + _text.at(_pos)
        update()
        return move_and_reset(_text.size() == 0 ? Command::SelectFile : Command::Nop)
    ;
    fn run => Command
        switch n->key()
        case 'f'  doremi toggle()
        case 'j'  dobr move(Dir::Up)
        case 'k'  dobr move(Dir::Down)
        case '\n' doremi choose()
        case 27   doremi toggle()
        default   do break
        ;
        return Command::Nop
    ;
;
