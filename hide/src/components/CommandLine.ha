class CommandLine => IContent
    string _line = ""
    CommandLine Ncurses *n =>
        _origin = new IContainer(Fill::Static, Vector(0,1))
        _origin->SetColor(3)
        _origin->SetLabel(_line)
        this->n = n
    ;
pub 
    fn update string line =>
        _line = line
        _origin->SetLabel(_line)
    ;
    fn exit => Command
        update("")
        return Command::ModeNormal
    ;
    fn try_parse => Command
        if _line == ":q" 
            update("")
            return Command::CloseEditor
        ;
        elif _line == ":w"
            update("")
            return Command::WriteEditor
        ;
        elif _line == ":wq"
            update("")
            return Command::WriteCloseEditor
        ;
        update(":")
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
        string ch(1, key)
        _line += ch
        update(_line)
        return Command::Nop
    ;
    fn run => Command
        if _line.size() == 0 do update(":")
        let key = n->key()
        switch key
        case 27     doremi exit()
        case '\n'   doremi try_parse()
        case '\b'
        case KEY_BACKSPACE doremi remove_ch()
        default     doremi add_ch(key)
        ;
        return Command::Nop
    ;
;
