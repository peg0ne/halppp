get => IContainer
class FilledRect => IContainer
    string _fill = " "
    FilledRect string fill =>
        this->_fill = fill
    ;
    FilledRect string fill, Vector size =>
        this->_fill_x = size.x != 0 ? Fill::Static : Fill::Flex
        this->_fill_y = size.y != 0 ? Fill::Static : Fill::Flex
        this->_fill = fill
        this->_size = size
    ;
pub
    fn draw Ncurses *n =>
        n->col(_color)
        for i until _size.y
        for j until _size.x
            n->add(_offset.y + i, _offset.x + j, _fill)
        ;;
        n->col(_color, false)
    ;
;