class SystemReader
pub
    vector<string> read_lines = {}
    bool started = false
    FILE *fp
    SystemReader => do return
    fn start string command =>
        fp = popen(command.c_str(), "r")
        started = true
    ;
    fn close =>
        if started do pclose(fp)
    ;
    fn pop int count =>
        for i until count
            if read_lines.size() > 0 do read_lines.pop_back()
        ;
    ;
    fn clear => do read_lines = {}
    fn add string line => do read_lines.push_back(line)
    fn update =>
        if !started do return
        char buffer[1064]
        if fgets(buffer, sizeof(buffer), fp)
            read_lines.push_back(buffer)
            if read_lines.size() > 300
                for i until 300 do read_lines[i] = read_lines[i+1]
            ;
        ;
        else
            pclose(fp)
            started = false
        ;
    ;
;

class Terminal => IContent
    string _line = ""
    int _curs_position = 0
    List<string> _buffer = List<string>()
    int _buffer_pos = 0
    Highlighter h = Highlighter("shell.sh")
    SystemReader sys_reader = SystemReader()
    bool update_line = true
    int scroll_pos = 0
    Terminal =>
        _origin = new MainContainer(Vector(9,3))
        _origin->SetColor(-3)
        clear_it()
    ;
    fn clear_it bool returner = true => bool
        _line = ""
        _text.clear()
        sys_reader.clear()
        if !returner do sys_reader.close()
        else do update_line = true
        return returner
    ;
    fn run_command => bool
        scroll_pos = 0
        if _buffer.len() > 20 do _buffer.remove(0)
        _buffer.add(_line)
        let cmd = String(_line).strip()
        if cmd =|= "exit" : ":q" doremi clear_it(false)
        elif cmd =|= "clear" : ":c" doremi clear_it(true)
        _text.set(_text.len() - 1, $"> {_line}")
        if cmd.size() > 0 && cmd[0] == '!'
            Ncurses::stop()
            system(_line.substr(1))
            Ncurses::start(true)
            update_line = true
        ;
        if String(_line).starts_with("cd") && _line.size() > 3
            changedir(_line.substr(3))
            sys_reader.pop(2)
            update_line = true
        ;
        else do sys_reader.start($"{_line} 2>&1")
        _line = ""
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
        ((MainContainer*)_origin)->update()
        ((IContent*)this)->draw()
    ;
    fn try_scroll Dir dir =>
        if sys_reader.started do return
        scroll_pos += dir == Dir::Down ? -1 : 1
        if scroll_pos < 0 do scroll_pos = 0
        if scroll_pos > sys_reader.read_lines.size() - _origin->Size().y do scroll_pos--
    ;
pub
    fn show =>
        MEVENT event
        Ncurses::start(true)
        let pwd = get_pwd()
        let has_started = false
        loop
            if sys_reader.started do sys_reader.update()
            _text = List<string>(sys_reader.read_lines)
            let line = String(_line)
            if sys_reader.started != has_started
                update_line = true
                has_started = sys_reader.started
            ;
            if !sys_reader.started
                line.insert("|", _curs_position)
                if update_line
                    sys_reader.add($"~{get_pwd()}")
                    move_internal_curs(0)
                    sys_reader.add($"> {line.to_string()}")
                    update_line = false
                ;
                elif sys_reader.read_lines.size() > 0
                    sys_reader.read_lines[sys_reader.read_lines.size() - 1] = $"> {line.to_string()}"
                ;
            ;
            while _text.len() - scroll_pos > _origin->Size().y do _text.remove(0)
            for i until _text.len() do _text.set(i, String(_text[i]).strip_end())
            let t = _text
            draw()
            h.highlight(_origin)
            _text = t
            let key = Ncurses::key()
            if key == KEY_MOUSE && getmouse(&event) == OK
                if event.bstate & (BUTTON4_PRESSED) doco try_scroll(Dir::Up)
                if event.bstate & (BUTTON5_PRESSED) doco try_scroll(Dir::Down)
            ;
            elif key == KEY_F(1) dobr scroll_pos = 0
            elif key == '\n' && !run_command() do break
            elif isgraph(key) || key == ' '
                line = String(_line)
                line.insert(string(1,key), _curs_position)
                _line = line.to_string()
                _curs_position++
                scroll_pos = 0
            ;
            elif key =|= KEY_BACKSPACE : 127 : '\b'
                if _line.size() == 0 do continue
                line = String(_line)
                line.remove(_curs_position - 1)
                _line = line.to_string()
                move_internal_curs(KEY_LEFT)
                scroll_pos = 0
            ;
            elif key == '\t'
                scroll_pos = 0
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
        Ncurses::start(false)
    ;
;
