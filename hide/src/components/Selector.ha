class Selector<T> => IContent
    int _pos = 0
    int _offset = 0
    vector<T> _options = {}
    vector<string> _names = {}
    Selector vector<T> options, vector<string> names, Vector offset, Vector size =>
        _origin = new VerticalLayout(size, offset)
        _origin->SetColor(-2)
        this->_options = options
        this->_names = names
        let max_width = 0
        foreach name in _names
            if max_width >= name.size() do continue
            max_width = name.size()
        ;
        _origin->SetOffset(offset.x, offset.y)
        _origin->SetSize(max_width, _origin->Size().y)
    ;
    fn get_internal_offset => int
        let size = _origin->Size()
        let y = size.y - 1
        if _pos > y + _offset do _offset = _pos - y
        if _pos < _offset do _offset = _pos
        return _offset
    ;
    fn search bool recurse, Option<int> key_opt =>
        let key = key_opt.is_none() ? Ncurses::key() : 0
        select k from key_opt do key = k
        let i = -1
        foreach s in _names
            i++
            if s.size() == 0 do continue
            if i <= _pos && !recurse do continue
            if tolower(s[0]) == key
                _pos = i
                return
            ;
        ;
        if !recurse dore search(true, Some(key))
    ;
    fn move Dir dir => do move(dir, 1)
    fn move Dir dir, int multiply =>  
        switch dir
        case Dir::Up dobr _pos = clamp(_pos - (1 * multiply), 0, _names.size() - 1)
        case Dir::Down dobr _pos = clamp(_pos + (1 * multiply), 0, _names.size() - 1)
        ;
    ;
    fn draw =>
        let offset = get_internal_offset()
        let buf = linq::take(_names)
            .where_with_iterator([offset](string name, int i){return i >= offset;})
            .as_vec()
        _origin->SetContent(buf)
        _origin->draw()
        Ncurses::mark_until(_pos - offset, 0, 5, _origin->Size().x)
    ;
pub
    fn run => Option<T>
        loop
            draw()
            switch Ncurses::key()
            case ' '  dobr search(false, None<int>())
            case KEY_UP
            case 'j'  dobr move(Dir::Up)
            case KEY_DOWN
            case 'k'  dobr move(Dir::Down)
            case KEY_PPAGE dobr move(Dir::Up, _origin->Size().y)
            case KEY_NPAGE dobr move(Dir::Down, _origin->Size().y)
            case '\n' doremi Some(_options[_pos])
            case 27   doremi None<T>()
            default   do break
            ;
        ;
    ;
    fn destroy => do delete _origin
;
