pub fn center_on_cursor => Command
    let vec = Vector(_offset.x, _selector.y - _content->Size().y / 2)
    _offset = vec.y < 0 ? Vector(vec.x, 0) : vec
    return Command::ModeNormal
;

pub fn top_on_cursor => Command
    let vec = Vector(_offset.x, _selector.y)
    _offset = vec.y < 0 ? Vector(vec.x, 0) : vec
    return Command::ModeNormal
;

pub fn bot_on_cursor => Command
    let vec = Vector(_offset.x, _selector.y - _content->Size().y)
    _offset = vec.y < 0 ? Vector(vec.x, 0) : vec
    return Command::ModeNormal
;

private fn run_z => Command
    switch Ncurses::key()
    case 'z'
    case '.' doremi center_on_cursor()
    case 'b' doremi bot_on_cursor()
    case 't' doremi top_on_cursor()
    default doremi Command::ModeNormal
    ;
;