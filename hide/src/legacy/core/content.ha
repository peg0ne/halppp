struct Content => IComponent
    Content => do return
    Content short color, Fill fill_x, Fill fill_y, AnchorY anchor_y =>
        this->color = color
        this->fill_x = fill_x
        this->fill_y = fill_y
        this->anchor_y = anchor_y
    ;
;
