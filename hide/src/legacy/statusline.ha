struct StatusLine => IComponent
    Ncurses *n
    StatusLine Ncurses *n =>
        this->anchor_x = AnchorX::Left
        this->anchor_y = AnchorY::Bottom
        this->fill_x = Fill::Full
        this->fill_y = Fill::Static
        this->size = Vector(90, 1)
        this->offset = Vector(12, 1)
        this->color = 5
    ;
    fn position Vector pos => string doremi "[" + to_string(pos.x) + "," + to_string(pos.y) + "]"
    fn draw => do draw("", Vector(0,0))
    fn draw string path, Vector pos =>
        string status = " > " + path + " $ " + position(pos)
        this->content = {status}
        ((IComponent*)this)->draw(n)
    ;
;
 
