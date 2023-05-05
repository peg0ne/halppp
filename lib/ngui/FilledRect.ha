get => IContainer
class FilledRect => IContainer
    string _fill = " "
    FilledRect string fill =>
        _type = ContainerType::FilledRect
        this->_fill = fill
    ;
    FilledRect string fill, Vector size =>
        this->_fill_x = size.x != 0 ? Fill::Static : Fill::Flex
        this->_fill_y = size.y != 0 ? Fill::Static : Fill::Flex
        this->_fill = fill
        this->_size = size
    ;
pub
    fn draw =>
        Ncurses::col(_color)
        for i until _size.y
        for j until _size.x
            Ncurses::add(_offset.y + i, _offset.x + j, _fill)
        ;;
        Ncurses::col(_color, false)
    ;
;