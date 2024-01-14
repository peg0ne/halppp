private fn run_base int key => Command
    switch key
    case ':' doremi Command::ModeCmdHan
    case ' ' doremi run_space()
    case 'j' dobr move(Dir::Up)
    case 'k' dobr move(Dir::Down)
    case 'l' dobr move(Dir::Right)
    case 'h' dobr move(Dir::Left)
    case 'n' dobr text_editing(TextEdit::Lower)
    case 'N' dobr text_editing(TextEdit::Upper)
    case 'e' dobr move_word(Dir::Right, true)
    case 'w' dobr move_word(Dir::Right)
    case 'b' dobr move_word(Dir::Left)
    case 'u' dobr undo()
    case 'r' dobr redo()
    case 'p' dobr text_editing(TextEdit::PasteLine)
    case 'P' dobr text_editing(TextEdit::PasteWord)
    case ';' dobr _selections.clear()
    case '.'
        select f from LSP::show_definition(find(false, false), "ha")
            open(f)
        ;
        break
    case 'f'
        find()
        center_on_cursor()
        break
    case 'F'
        find(true)
        center_on_cursor()
        break
    default do break
    ;
    return Command::Nop
;
