private fn run_nor int key => Command
    let cmd = run_base(key)
    if cmd != Command::Nop doremi cmd
    > set_cursor_mode this (int value, bool is_mod = false)
        if (is_mod) do _modifier = String("")
        system($"printf '\e[{value} q'")
        _current_mode = Mode::Insert
        draw(6)
        return Command::ModeInsert
    ;
    switch key
    case 27 dobr _modifier = String("")
    case 'v' 
        _modifier = String("")
        return Command::ModeVisual
    case 'a'
        move(Dir::Right)
        return set_cursor_mode(5, true)
    case 'C'
        text_editing(TextEdit::DeleteFrom)
        return set_cursor_mode(5)
    case 'c'
        run_d()
        return set_cursor_mode(5)
    case 'i' doremi set_cursor_mode(5, true)
    case 'x' dobr text_editing(TextEdit::DeleteChar)
    case 'M' dobr add_selector(true)
    case 'm' dobr add_selector()
    case 'D' dobr text_editing(TextEdit::DeleteFrom)
    case 'd' dobr run_d()
    case 's' dobr run_s()
    case 'R' dobr run_r()
    case 'Y' dobr yank_from()
    case 'y' dobr run_y()
    case 'z' dobr run_z()
    case 'o' dobr _num_diff = !_num_diff
    case 't' dobr _check_errors = !_check_errors
    case 'T' dobr templates()
    default
        if !isdigit(key) do break
        _modifier.append(string(1,key))
        break
    ;
    return Command::Nop
;