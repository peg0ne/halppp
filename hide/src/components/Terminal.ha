class Terminal => IContent
    string _line = ""
    List<string> _buffer = List<string>()
    int _buffer_pos = 0
    Terminal Ncurses *n =>
        _origin = new MainContainer(Vector(9,3))
        _origin->SetColor(-3)
        clear_it()
        this->n = n
    ;
    fn clear_it bool returner = true => bool
        _line = ""
        _text.clear()
        _text.add($"~{get_pwd()}")
        _text.add("> ")
        return returner
    ;
    fn run_command => bool
        if _buffer.len() > 20 do _buffer.remove(0)
        _buffer.add(_line)
        let cmd = String(_line).strip()
        if cmd =|= "exit" : ":q" doremi clear_it(false)
        elif cmd =|= "clear" : ":c" doremi clear_it(true)
        _text.set(_text.len() - 1, $"> {_line}")
        let output = linq::take(system_output($"{_line} 2>&1"))
            .operate_async([](string o){return String(o).strip_end();}).as_vec()
        _text = linq::take(_text).join(output).as_list()
        _line = ""
        _text.add($"~{get_pwd()}")
        _text.add("> ")
        return true
    ;
    fn get_from_buffer int key =>
        if _buffer.len() == 0 do return
        _buffer_pos += key == KEY_UP ? -1 : 1
        if _buffer_pos < 0 do _buffer_pos = _buffer.len() - 1
        if _buffer_pos >= _buffer.len() do _buffer_pos = 0
        _line = _buffer[_buffer_pos]
    ;
    fn get_pwd => string
        let pwd = linq::take(system_output("pwd 2>&1")).first_or("/")
        return String(pwd).strip()
    ;
pub
    fn show =>
        loop
            let t = _text
            _text.set(_text.len() - 1, $"> {_line}")
            draw()
            _text = t
            let key = n->key()
            if key == KEY_F(1) do break
            elif key == '\n'
                if !run_command() do break
            ;
            elif isgraph(key) || key == ' ' do _line += key
            switch key
            case KEY_BACKSPACE dobr _line = _line.substr(0, max(_line.size() - 1, 0))
            case KEY_UP
            case KEY_DOWN dobr get_from_buffer(key)
            ;
        ;
    ;
;