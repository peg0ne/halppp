get => ../IContainer
class FilledRect => IContainer
    char _fill = ' '
    FilledRect char fill =>
        this->_fill = fill
    ;
pub
    fn draw NCurses *n =>
        n->col(_color)
        for i until _size.y
        for j until _size.x
            n->add(_offset.y + i, _offset.x + j, _fill)
        ;;
        n->col(_color, false)
    ;
; 
