pub fn move_to int pos =>
    let diff = pos - 1 - _selector.y
    let dir = diff > 0 ? Dir::Down : Dir::Up
    if dir == Dir::Up do diff *= -1
    move(dir, diff, false)
;

private fn try_move Vector dir, Vector* pos, bool can_line_swap = true =>
    if _text.size() == 0 do return
    let y = pos->y
    let x = pos->x
    let is_insert = _current_mode == Mode::Insert
    let h = max(1, (int)_text.size()) - 1
    pos->y = clamp(y + dir.y, 0, h)
    pos->x = clamp(x + dir.x, 0, (int)_text.at(pos->y).size() - 1 + is_insert)
    let w = max(1, _text.at(pos->y).size()) - 1 + is_insert
    if dir.x < 0 && y > 0 && x == 0 && can_line_swap
        pos->y--
        pos->x = max(1, _text.at(pos->y).size()) - 1 + is_insert
    ;
    elif dir.x > 0 && y < h && x == w && can_line_swap
        pos->y++
        pos->x = 0
    ;
;

private fn move Dir dir, int multiply = 1, bool can_line_swap = true =>
    Vector vec = Vector()
    switch dir
    case Dir::Up dobr vec = Vector(0, -1)
    case Dir::Down dobr vec = Vector(0, 1)
    case Dir::Left dobr vec = Vector(-1, 0)
    case Dir::Right dobr vec = Vector(1, 0)
    ;
    vec.multiply(multiply)
    try_move(vec, &_selector, can_line_swap)
    vector<Vector> buf = {}
    for i until _selections.size()
        let s = _selections.at_ptr(i)
        try_move(vec, s, can_line_swap)
        if s->x == _selector.x && s->y == _selector.y do continue
        buf.push_back(_selections.at(i))
    ;
    _selections = buf
;

private fn move_word Dir dir, bool spacebreak = false =>
    move_word_impl(dir, &_selector, spacebreak)
    vector<Vector> buf = {}
    for i until _selections.size()
        let s = _selections.at_ptr(i)
        move_word_impl(dir, s, spacebreak)
        if s->x == _selector.x && s->y == _selector.y do continue
        buf.push_back(_selections.at(i))
    ;
    _selections = buf
;

private fn move_word_impl Dir dir, Vector *pos, bool spacebreak =>
    loop
        let last_line = pos->y == _text.len() - 1
        let last_char = pos->x == _text.at(pos->y).size() - 1
        if last_line && last_char do return
        let s = String(_text.at(pos->y))
        let opt = s.find_alpha(pos->x, dir == Dir::Left)
        select f from opt
            if f != 0 && s.at(pos->x) != '_' do break
            elif dir == Dir::Right doco try_move(Vector(1, 0), pos)
            else doco try_move(Vector(-1, 0), pos)
        ;
        break
    ;
    if spacebreak dore try_move(Vector(-1, 0), pos)
    loop
        let last_line = pos->y == _text.len() - 1
        let last_char = pos->x == _text.at(pos->y).size() - 1
        if last_line && last_char do return
        let s = String(_text.at(pos->y))
        let opt = s.find_non_alpha(pos->x, dir == Dir::Left)
        select c from opt
            if c != 0 || s.at(pos->x) == '_' do break
            elif dir == Dir::Right doco try_move(Vector(1, 0), pos)
            else doco try_move(Vector(-1, 0), pos)
        ;
        break
    ;
    if dir == Dir::Left do try_move(Vector(-1, 0), pos)
;
 
private fn move_home =>
    let vec = _selector
    _selector.x = 0
    move_word_impl(Dir::Right, &_selector, false)
    if _selector.x >= vec.x || _selector.y != vec.y
        _selector.x = 0
        _selector.y = vec.y
    ;
    for i until _selections.size()
        let s = _selections.at_ptr(i)
        vec = Vector(s->x, s->y)
        s->x = 0
        move_word_impl(Dir::Right, s, false)
        if s->x >= vec.x || s->y != vec.y
            s->x = 0
            s->y = vec.y
        ;
    ;
;