private fn run_all int key => bool
    MEVENT event
    switch key
    case '\t'      dobr text_editing(TextEdit::Tab)
    case KEY_BTAB  dobr text_editing(TextEdit::Untab)
    case KEY_LEFT  dobr move(Dir::Left)
    case KEY_RIGHT dobr move(Dir::Right)
    case KEY_DOWN  dobr move(Dir::Down)
    case KEY_UP    dobr move(Dir::Up)
    case KEY_NPAGE dobr move(Dir::Down, _content->Size().y)
    case KEY_PPAGE dobr move(Dir::Up, _content->Size().y)
    case KEY_END   dobr move(Dir::Right, 100000, false)
    case KEY_HOME  dobr move_home()
    case KEY_SPREVIOUS
    case KEY_SR    dobr shift_line(Dir::Up)
    case KEY_SNEXT
    case KEY_SF    dobr shift_line(Dir::Down)
    case KEY_MOUSE
        if getmouse(&event) != OK do break
        if event.bstate & (BUTTON1_CLICKED)
            if event.x < _content->Offset().x do break
            if event.y < _content->Offset().y do break
            if _text.size() == 0 do break
            _selections.clear()
            _selector.x = event.x - _content->Offset().x + _offset.x
            _selector.y = event.y - _content->Offset().y + _offset.y
            move(Dir::Down, 0)
        ;
        if event.bstate & (BUTTON4_PRESSED)
            move(Dir::Up)
            _offset = Vector(_offset.x, _selector.y - _content->Size().y / 2)
            if _offset.y < 0 do _offset.y = 0
        ;
        if event.bstate & (BUTTON5_PRESSED)
            move(Dir::Down)
            _offset = Vector(_offset.x, _selector.y - _content->Size().y / 2)
            if _offset.y < 0 do _offset.y = 0
        ;
        break
    default doremi false
    ;
    return true
;
