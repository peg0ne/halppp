get => ../../../lib/files

struct Editor => IComponent
    string path = ""
    bool is_active = true
    int index = 0
    int amount = 1
    Vector pos = Vector(0,0)
    StatusLine *status
    vector<Vector> selections = {}
    Vector selector = Vector(0,0)
    Ncurses *n
    Line top_bar
    Content line_numbers
    Editor Ncurses *n, StatusLine *s, string path, int amount =>
        this->n = n
        this->status = s
        this->anchor_y = AnchorY::Bottom
        this->fill_x = Fill::Percent
        this->fill_y = Fill::Full
        this->top_bar = Line(Fill::Percent, Fill::Static)
        this->line_numbers = Content(3, Fill::Static, Fill::Full, AnchorY::Bottom)
        this->path = path
        this->content = readlines(path)
    ;
    fn run Mode mode, int index, int amount => Command
        this->index = index
        this->amount = amount
        loop
            let key = n->key()
            switch key
            case ':' doremi Command::ModeCmdHan
            case ' ' doremi Command::ModeFileEx
            case 'j' dobr move(Dir::Up)
            case 'k' dobr move(Dir::Down)
            case 'l' dobr move(Dir::Right)
            case 'h' dobr move(Dir::Left)
            ;
            switch mode
            case Mode::Normal
                select c from run_nor(key) doremi c
                break
            case Mode::Insert
                select c from run_ins(key) doremi c
                break
            case Mode::Visual
                select c from run_vis(key) doremi c
                break
            default do break
            ;
        ;
    ;
    fn run_nor int key => Option<Command>
        switch key
        case 'v' doremi Some(Command::ModeVisual)
        case 'i' doremi Some(Command::ModeInsert)
        case 'x' dobr try_delete_ch()
        case 'm' dobr add_selector()
        ;
        return None<Command>()
    ;
    fn run_ins int key => Option<Command>
        switch key
        case 'v' doremi Some(Command::ModeVisual)
        case 27 doremi Some(Command::ModeNormal)
        ;
        return None<Command>()
    ;
    fn run_vis int key => Option<Command>
        switch key
        case 'i' doremi Some(Command::ModeInsert)
        case 27 doremi Some(Command::ModeNormal)
        ;
        return None<Command>()
    ;
    fn add_selector =>
        selections.push_back(selector)
        try_move(Vector(1,0), &selector)
        draw(amount, index, false)
    ;
    fn try_delete_ch =>
        delete_ch(&selector)
        sort(selections.begin(), selections.end(), &selection_comparer)
        foreach s in selections do delete_ch(&s)
    ;
    fn delete_ch Vector *pos =>
        let s = content.at(pos->y)
        let updated = ""
        if s.size() == 0 do return
        if pos->x >= s.size() && pos->x != 0 do return
        updated += s.substr(0, pos->x)
        updated += s.substr(pos->x + 1)
        content.at(pos->y) = updated
        draw(amount, index, false)
    ;
    fn try_move Vector dir, Vector* pos =>
        let y = pos->y
        let x = pos->x
        let h = max(1, (int)content.size()) - 1
        pos->y = clamp(y + dir.y, 0, h)
        pos->x = clamp(x + dir.x, 0, (int)content.at(pos->y).size() - 1)
        let w = max(1, content.at(pos->y).size()) - 1
        if dir.x < 0 && y > 0 && x == 0
            pos->y--
            pos->x = max(1, content.at(pos->y).size()) - 1
        ;
        elif dir.x > 0 && y < h && x == w
            pos->y++
            pos->x = 0
        ;
    ;
    fn move Dir dir =>
        Vector vec
        switch dir
        case Dir::Up dobr vec = Vector(0, -1)
        case Dir::Down dobr vec = Vector(0, 1)
        case Dir::Left dobr vec = Vector(-1, 0)
        case Dir::Right dobr vec = Vector(1, 0)
        ;
        try_move(vec, &selector)
        vector<Vector> buf = {}
        for i until selections.size()
            let s = &selections.at(i)
            try_move(vec, s)
            if s->x == selector.x && s->y == selector.y do continue
            buf.push_back(selections.at(i))
        ;
        selections = buf
        draw(amount, index, false)
        status->draw(path, selector)
    ;
    fn active bool is_active => do this->is_active = is_active
    fn draw int amount, int index, bool is_filex_open =>
        set_size(amount, index, is_filex_open)
        let origin = content
        let bounds = get_bounds()
        content = get_content()
        draw_origin()
        line_numbers.draw(n)
        top_bar.draw(n)
        n->mark(selector.y + 1, offset.x + selector.x, 4)
        foreach s in selections
            n->mark(s.y + 1, offset.x + s.x, 5)
        ;
        content = origin
    ;
    fn set_size int amount, int index, bool is_filex_open =>
        let off = is_filex_open ? 25 : 0
        let max = COLS - off
        this->size = Vector((max / amount), 0)
        this->offset = Vector(off + (size.x * index) + 5, 2)
        this->top_bar.size = Vector(size.x + 2, 1)
        this->top_bar.offset = Vector(offset.x - 5, 0)
        this->top_bar.content = {"| " + path}
        this->top_bar.color = is_active ? 5 : 6
        this->line_numbers.size = Vector(5, 0)
        this->line_numbers.offset = Vector(offset.x - 5, 2)
        this->line_numbers.content = {""}
        for i until content.size()
            this->line_numbers.content.push_back(to_string(i + 1))
        ;
    ;
    fn draw_origin => do ((IComponent*)this)->draw(n)
    fn get_content => vector<string>
        vector<string> buf = {""}
        foreach line in content do buf.push_back(line)
        return buf
    ;
;
 
fn selection_comparer Vector &lhs, Vector &rhs => bool
    if lhs.y < rhs.y doremi true
    if lhs.y > rhs.y doremi false
    return lhs.x > rhs.x
;
