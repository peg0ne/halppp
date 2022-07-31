class Explorer => IContent
    string _path = "."
    int _pos = 0
    int _offset = 0
    Vector _global_size = Vector(COLS,LINES)
    Explorer Ncurses *n =>
        _text = list_files(_path)
        _origin = new IContainer(Fill::Static, Vector(25,0))
        _origin->SetColor(2)
        _origin->SetContent(_text)
        this->n = n
    ;
    fn get_internal_offset => int
        let size = _origin->Size()
        let y = size.y - 1
        if _pos > y + _offset
            _offset = _pos - y
        ;
        if _pos < _offset
            _offset = _pos
        ;
        return _offset
    ;
pub 
    fn draw =>
        let offset = get_internal_offset()
        List<string> buf = List<string>()
        for i until _text.size()
            if i < offset do continue
            buf.add(_text.at(i))
        ;
        _origin->SetContent(buf)
        _origin->draw(n)
        n->mark_until(_pos - offset, 0, 5, _origin->Size().x)
    ;
    fn set_visibility Mode mode => do _origin->SetActive(mode == Mode::FileEx)
    fn toggle => Command
        _origin->SetActive(!_origin->Active())
        return Command::ModeNormal
    ;
    fn update =>
        _text = list_files(_path)
        _origin->SetContent(_text)
        draw()
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
    fn move Dir dir => do move(dir, 1)
    fn move Dir dir, int multiply =>  
        switch dir
        case Dir::Up dobr _pos = clamp(_pos - (1 * multiply), 0, _text.size() - 1)
        case Dir::Down dobr _pos = clamp(_pos + (1 * multiply), 0, _text.size() - 1)
        ;
    ;
    fn choose => Command
        let p = _text.at(_pos)
        if p == "." doremi Command::Nop
        //Lets remove this for now
        //if p == ".." && _path != "."
        //    while _path.back() != '/' do _path.pop_back()
        //    _path.pop_back()
        //    update()
        //    return move_and_reset(Command::Nop)
        //;
        _path += "/" + _text.at(_pos)
        update()
        return move_and_reset(_text.size() == 0 ? Command::SelectFile : Command::Nop)
    ;
    fn run => Command doremi run(false)
    fn run bool internal_run => Command
        if internal_run 
            draw()
            if _global_size.x != COLS || _global_size.y != LINES
                _global_size = Vector(COLS,LINES)
                return Command::Nop
            ;
        ;
        let cmd = Command::Nop
        switch n->key()
        case ' '  dobr cmd = search()
        case 'f'  dobr cmd = toggle()
        case KEY_UP
        case 'j'  dobr move(Dir::Up)
        case KEY_DOWN
        case 'k'  dobr move(Dir::Down)
        case KEY_PPAGE dobr move(Dir::Up, _origin->Size().y)
        case KEY_NPAGE dobr move(Dir::Down, _origin->Size().y)
        case '\n' dobr cmd = choose()
        case 27   dobr cmd = toggle()
        default   do break
        ;
        return cmd == Command::Nop ? run(true) : cmd
    ;
    fn search => Command doremi search(false, None<int>())
    fn search bool recurse, Option<int> key_opt => Command
        let key = key_opt.is_none() ? n->key() : 0
        select k from key_opt do key = k
        let i = -1
        foreach s in _text
            i++
            if s.size() == 0 do continue
            if i <= _pos && !recurse do continue
            if tolower(s[0]) == key
                _pos = i
                return Command::Nop
            ;
        ;
        return !recurse ? search(true, Some(key)) : Command::Nop
    ;
;


