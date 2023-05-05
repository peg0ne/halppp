private fn yank_line Vector *pos, bool is_multi = false =>
    if _text.len() == 0 do return
    if !is_multi do _shared_buffer->clear()
    _shared_buffer->push_back(_text.at(pos->y))
;

private fn yank_from =>
    let s = _text.at(_selector.y)
    _shared_buffer->clear()
    _shared_buffer->push_back(_text.at(_selector.y).substr(_selector.x))
;

private fn run_y => Command
    switch Ncurses::key()
    case 'y' do break
    default doremi Command::Nop
    ;
    select num from _modifier.to_num()
        if num == 0 do yank_line(&_selector)
        for i until num
            yank_line(&_selector, i != 0)
            move(Dir::Down)
        ;
        _modifier = String("")
        return Command::Nop
    ;
    yank_line(&_selector)
    return Command::Nop
;