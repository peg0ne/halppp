get => IContainer
class Button => IContainer
    bool _selected = false
    Button =>
        this->_type = ContainerType::Base
        this->_fill_x = Fill::Flex
        this->_fill_y = Fill::Static
        this->_size = Vector(0,3)
        this->_label = "Button"
    ;
    Button int width =>
        this->_type = ContainerType::Base
        this->_fill_x = Fill::Static
        this->_fill_y = Fill::Static
        this->_size = Vector(width, 3)
        this->_label = "Button"
    ;
pub
    fn hover => do _selected = true
    fn unhover => do _selected = false
    fn draw Ncurses *n =>
        n->col(_selected)
        n->box(_offset.y, _offset.x, _size.y, _size.x)
        let pos_y = _size.y/2
        let pos_x = (_size.x/2) - (_label.size()/2)
        n->add(_offset.y + pos_y, _offset.x + pos_x, _label)
        n->col(_selected, false)
    ;
;