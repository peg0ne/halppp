class CommandLine => IContent
    string _line = ""
    vector<string> _buffer = {}
    int _buffer_pos = 0
    EditorManager *_editorManager
    CommandLine EditorManager *editorManager =>
        _origin = new IContainer(Fill::Static, Vector(0,1))
        _origin->SetColor(3)
        _origin->SetLabel(_line)
        _editorManager = editorManager
    ;
pub 
    fn update string line =>
        _line = line
        _origin->SetLabel(_line)
        _origin->draw()
    ;
    fn update_return Command cmd => Command
        update("")
        _buffer_pos = _buffer.size()
        return cmd
    ;
    fn exit => Command doremi update_return(Command::ModeNormal)
    fn try_parse EditorManager *manager => Command
        let s = String(_line)
        s.remove(0)
        _line = s.to_string()
        let m = linq::take(_buffer).where([this](string b){return _line == b;}).first()
        if m.is_none() do _buffer.push_back(_line)
        if _line == "q" doremi update_return(Command::CloseEditor)
        elif _line == "q!" doremi update_return(Command::CloseEditorForced)
        elif _line == "w" doremi update_return(Command::WriteEditor)
        elif _line == "wq" doremi update_return(Command::WriteCloseEditor)
        elif s.starts_with("touch ")
            write(" ", _line.substr(6))
            return update_return(Command::ModeNormal)
        ;
        elif s.starts_with("mkdir ")
            makedir(_line.substr(6))
            return update_return(Command::ModeNormal)
        ;
        elif s.starts_with("syntax ")
            _editorManager->set_syntax(_line.substr(7))
            return update_return(Command::ModeNormal)
        ;
        elif s.starts_with("!")
            Ncurses::stop()
            system($"{_line.substr(1)} && echo 'Press any key to return!'")
            Ncurses::key()
            Ncurses::start()
            return update_return(Command::ModeNormal)
        ;
        select num from s.to_num()
            manager->move_to(num)
            return update_return(Command::ModeNormal)
        ;
        _buffer.pop_back()
        Ncurses::col(1)
        Ncurses::add(LINES - 1, 0, $"no such command: {_line}")
        Ncurses::key()
        Ncurses::col(1, false)
        update(":")
        _buffer_pos = _buffer.size()
        return Command::Nop
    ;
    fn remove_ch => Command
        if _line.size() == 0 doremi Command::Nop
        _line.pop_back()
        update(_line)
        if _line.size() == 0 doremi exit()
        return Command::Nop
    ;
    fn add_ch int key => Command
        let ch = string(1, key)
        _line += ch
        update(_line)
        return Command::Nop
    ;
    fn get_from_buffer int key => Command
        if _buffer.size() == 0 doremi Command::Nop
        _buffer_pos += key == KEY_UP ? -1 : 1
        if _buffer_pos < 0 do _buffer_pos = _buffer.size() - 1
        if _buffer_pos >= _buffer.size() do _buffer_pos = 0
        _line = _buffer[_buffer_pos]
        update($":{_line}")
        return Command::Nop
    ;
    fn run EditorManager *manager => Command
        if _line.size() == 0 do update(":")
        let key = Ncurses::key()
        switch key
        case KEY_DOWN
        case KEY_UP doremi get_from_buffer(key)
        case 27     doremi exit()
        case '\n'   doremi try_parse(manager)
        case '\b'
        case 127
        case KEY_BACKSPACE doremi remove_ch()
        default     doremi add_ch(key)
        ;
        return Command::Nop
    ;
;