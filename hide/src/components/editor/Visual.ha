private fn run_vis int key => Command
    let cmd = run_base(key)
    if cmd != Command::Nop doremi cmd
    switch key
    case 'i' doremi Command::ModeInsert
    case 27  doremi Command::ModeNormal
    case 'd'
        text_editing(TextEdit::DeleteChar)
        _selections.clear()
        move(Dir::Left, 0)
        break
    case 'x' dobr select_line()
    case 'W' dobr select_word()
    ;
    return Command::Nop
;