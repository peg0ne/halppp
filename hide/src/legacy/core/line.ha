struct Line => IComponent
    Line => do return
    Line Fill fill_x, Fill fill_y =>
        this->fill_x = fill_x
        this->fill_y = fill_y
    ;
;
