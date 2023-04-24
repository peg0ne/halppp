private fn run_ins int key => Command
    int _ = 0
    switch key
    case 27
        _ = system("printf '\e[2 q'")
        _current_mode = Mode::Normal 
        draw(6)
        return Command::ModeNormal
    case '\n' dobr text_editing(TextEdit::InsertNl)
    case '\b'
    case 127
    case KEY_BACKSPACE dobr text_editing(TextEdit::RemoveChar)
    default dobr text_editing(TextEdit::Insert, string(1, key))
    ;
    return Command::Nop
;