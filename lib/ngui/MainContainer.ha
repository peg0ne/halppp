get => VerticalLayout
class MainContainer => VerticalLayout
    MainContainer =>
        _type = ContainerType::Main
        _size = Vector(COLS, LINES)
        _offset = Vector(0,0)
    ;
    MainContainer Vector padding =>
        _type = ContainerType::Main
        _size = Vector(COLS - (padding.x * 2), LINES - (padding.y * 2))
        _offset = padding
    ;
    pub fn update =>
        _size = Vector(COLS - (_offset.x * 2), LINES - (_offset.y * 2))
        ((VerticalLayout*)this)->update()
    ;
    pub fn draw =>
        if !is_active do return
        update()
        ((IContainer*)this)->draw()
        foreach c in _containers do draw_container_impl(c)
    ;
;