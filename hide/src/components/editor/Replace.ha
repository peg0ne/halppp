pub fn run_r => Command
    let search = ""
    let replace = ""
    let step = 0
    loop
        Ncurses::clearLn(LINES - 1)
        let extra = step ? 3 : 0
        string extra_str = step ? "" : " "
        Ncurses::add_col(LINES - 1, 0, "replace:", 3)
        Ncurses::add(LINES - 1, 9, $"{search}{extra_str} - {replace}")
        Ncurses::mark_until(LINES - 1, 9 + search.size() + extra_str.size() + 1, 2 + step, true)
        Ncurses::add_col(LINES - 1, 9 + search.size() + replace.size() + extra, '|', 1)
        let key = Ncurses::key()
        switch key
        case '\n'
            if step == 1
                while find(search, replace) do continue
                Ncurses::clearLn(LINES - 1)
                return Command::Nop
            ;
            step++
            break
        case 27
            Ncurses::clearLn(LINES - 1)
            return Command::Nop
        case '\b'
        case 127
        case KEY_BACKSPACE
            if search.size() == 0
                Ncurses::clearLn(LINES - 1)
                return Command::Nop
            ;
            if step == 1 && replace.size() == 0
                step--
                break
            ;
            switch step
            case 0 dobr search.pop_back()
            case 1 dobr replace.pop_back()
            ;
            break
        default
            switch step
            case 0
                if isgraph(key) do search += key
                break
            case 1
                if isgraph(key) do replace += key
                break
            ;
            break
        ;
    ;
;