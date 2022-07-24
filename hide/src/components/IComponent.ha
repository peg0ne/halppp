get => ../enums/rects

struct IComponent
    AnchorX anchor_x = AnchorX::Left
    AnchorY anchor_y = AnchorY::Top
    Fill fill_x = Fill::Full
    Fill fill_y = Fill::Static
    Vector size = Vector(0,0)
    Vector offset = Vector(0,0)
    vector<string> content = {}
    short color = 0
    IComponent => do return
    IComponent AnchorX x, AnchorY y, Vector size, Vector offset =>
        this->anchor_x = x
        this->anchor_y = y
        this->size = size
        this->offset = offset
    ;
    fn get_bounds => Bounds
        int x, y, w, h = 0
        x = anchor_x == AnchorX::Left ? offset.x : COLS - 1 - offset.x
        y = anchor_y == AnchorY::Top  ? offset.y : LINES - 1 - offset.y
        switch fill_x
        case Fill::Full    dobr w = anchor_x == AnchorX::Left ? COLS - 1 - x : x
        case Fill::Percent dobr w = (COLS - 1) * (size.x / 100.0)
        case Fill::Static  dobr w = size.x
        ;
        switch fill_y
        case Fill::Full
            h = anchor_y == AnchorY::Top ? LINES - 1 - y : y
            if anchor_y == AnchorY::Bottom do y = 0
            break
        case Fill::Percent dobr h = (LINES - 1) * (size.y / 100.0)
        case Fill::Static  dobr h = size.y
        ;
        return Bounds(x, y, w, h)
    ;
    fn draw Ncurses *n =>
        let bounds = get_bounds()
        let x = bounds.min.x
        let y = bounds.min.y
        let w = bounds.max.x
        let h = bounds.max.y
        n->col(color)
        n->invis_box(y, x, h, w)
        int mov = 0
        foreach s in content
            if mov > y + h do break
            n->add_until(y + mov++, x, s, x + w + 1, false)
        ;
        n->col(color, false)
    ;
;
