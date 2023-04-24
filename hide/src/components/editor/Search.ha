pub fn run_s => Command
    let search = ""
    loop
        n->clearLn(LINES - 1)
        n->add_col(LINES - 1, 0, "search:", 3)
        n->add(LINES - 1, 8, search)
        n->add_col(LINES - 1, 8 + search.size(), '|', 1)
        let key = n->key()
        switch key
        case '\n' 
            if !find(search) do find(search, true)
            center_on_cursor()
            n->clearLn(LINES - 1)
            return Command::Nop
        case 27
            n->clearLn(LINES - 1)
            return Command::Nop
        case '\b'
        case 127
        case KEY_BACKSPACE 
            if search.size() == 0
                n->clearLn(LINES - 1)
                return Command::Nop
            ;
            search.pop_back()
            break
        default
            if isgraph(key) do search += key
            break
        ;
    ;
    return Command::Nop
;