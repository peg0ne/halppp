get => ../enums/modes

struct ModeView => IComponent
    Ncurses *n
    Mode mode = Mode::FileEx
    ModeView Ncurses *n =>
        this->n = n
        this->anchor_x = AnchorX::Left
        this->anchor_y = AnchorY::Bottom
        this->fill_x = Fill::Static
        this->fill_y = Fill::Static
        this->size = Vector(10, 1)
        this->offset = Vector(0, 1)
        this->color = 5
    ;
    fn set Mode mode => do this->mode = mode
    fn is_filex => bool doremi mode == Mode::FileEx
    fn draw =>
        string mode_str = "  " + to_string(mode) + "  "
        this->content = {mode_str}
        ((IComponent*)this)->draw(n)
    ;
;
 
