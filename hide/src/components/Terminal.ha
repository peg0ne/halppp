class Terminal => IContent
    string _line = ""
    int _curs_position = 0
    List<string> _buffer = List<string>()
    int _buffer_pos = 0
    Highlighter h = Highlighter("shell.sh")
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
        if cmd.size() > 0 && cmd[0] == '!'
            n->stop()
            system(_line.substr(1))
            n->start()
        ;
        if String(_line).starts_with("cd") && _line.size() > 3
            changedir(_line.substr(3))
        ;
        else
            let output = linq::take(system_output($"{_line} 2>&1"))
                .operate_async([](string o){return String(o).strip_end();}).as_vec()
            _text = linq::take(_text).join(output).as_list()
        ;
        _line = ""
        _text.add($"~{get_pwd()}")
        _text.add("> ")
        return true
    ;
    fn get_from_buffer int key =>
        if _buffer.len() == 0 do return
        if key =!= KEY_UP : KEY_DOWN do return
        _buffer_pos += key == KEY_UP ? -1 : 1
        if _buffer_pos < 0 do _buffer_pos = _buffer.len() - 1
        if _buffer_pos >= _buffer.len() do _buffer_pos = 0
        _line = _buffer[_buffer_pos]
        move_internal_curs(KEY_END)
    ;
    fn move_internal_curs int key =>
        switch key
        case KEY_LEFT dobr _curs_position -= 1
        case KEY_RIGHT dobr _curs_position += 1
        case KEY_HOME dobr _curs_position -= 100000
        case KEY_END dobr _curs_position += 100000
        default do break
        ;
        if _curs_position < 0 do _curs_position = 0
        if _curs_position >= _line.size() do _curs_position = _line.size()
    ;
    fn get_pwd => string
        let pwd = linq::take(system_output("pwd 2>&1")).first_or("/")
        return String(pwd).strip()
    ;
    fn draw =>
        ((MainContainer*)this)->update()
        ((IContent*)this)->draw()
    ;
pub
    fn show =>
        let pwd = get_pwd()
        loop
            while _text.len() > _origin->Size().y do _text.remove(0)
            let t = _text
            let line = String(_line)
            move_internal_curs(0)
            line.insert("|", _curs_position)
            _text.set(_text.len() - 1, $"> {line.to_string()}")
            draw()
            h.highlight(_origin, n)
            _text = t
            let key = n->key()
            if key == KEY_F(1) do break
            elif key == '\n' && !run_command() do break
            elif isgraph(key) || key == ' '
                _line += key
                _curs_position++
            ;
            elif key =|= KEY_BACKSPACE : 127 : '\b'
                if _line.size() == 0 do continue
                line = String(_line)
                line.remove(_curs_position - 1)
                _line = line.to_string()
                move_internal_curs(KEY_LEFT)
            ;
            elif key == '\t'
                if _line.size() == 0 do continue
                line = String(_line)
                let words = line.split(' ')
                let word = words[words.size() - 1]
                let word_str = String(word)
                let path = "."
                if word_str.contains("/")
                    let new_word = ""
                    while !word_str.ends_with("/")
                        new_word = word_str[word_str.len() - 1] + new_word
                        word_str.remove_back(1)
                    ;
                    word = new_word
                    path = word_str.to_string()
                ;
                let files = list_reg_files(path)
                let dirs = list_dirs(path)
                > f_start_with word (string f) doremi String(f).starts_with(word)
                let f_matches = linq::take(files).where(f_start_with).as_vec()
                let d_matches = linq::take(dirs).where(f_start_with).as_vec()
                let suffix = d_matches.size() != 0 ? "/" : " "
                let matches = linq::take(f_matches).join(d_matches).as_vec()
                
                switch f_matches.size() + d_matches.size()
                case 0 do break
                case 1
                    line.remove_back(word.size())
                    _line = (line + matches[0]).to_string() + suffix
                    move_internal_curs(KEY_END)
                    break
                default
                    _text = linq::take(_text).join(matches).as_list()
                    _text.add($"> {_line}")
                    break
                ;
            ;
            get_from_buffer(key)
            move_internal_curs(key)
        ;
        changedir(pwd)
    ;
;