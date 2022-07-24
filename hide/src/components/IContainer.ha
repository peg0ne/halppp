class IContainer
protected
    short _color = 0
    AnchorX _anchor_x = AnchorX::Left
    AnchorY _anchor_y = AnchorY::Top
    Fill _fill_x = Fill::Flex
    Fill _fill_y = Fill::Flex
    Vector _size = Vector(0,0)
    Vector _offset = Vector(0,0)
    bool is_active = true
    IContainer => do return
    IContainer Fill f =>
        _fill_x = f
        _fill_y = f
    ;
    IContainer Fill f, Vector s =>
        _fill_x = f
        _fill_y = f
        _size = s
    ;
    IContainer Vector s, Vector o =>
        _size = s
        _offset = o
    ;
    IContainer Fill f_x, Fill f_y, Vector s, Vector o =>
        _fill_x = f_x
        _fill_y = f_y
        _size = s
        _offset = o
    ;
    IContainer AnchorX a_x, AnchorY a_y, Fill f_x, Fill f_y, Vector s, Vector o =>
        _anchor_x = a_x
        _anchor_y = a_y
        _fill_x = f_x
        _fill_y = f_y
        _size = s
        _offset = o
    ;
pub
    fn FillY => Fill doremi _fill_y
    fn FillX => Fill doremi _fill_x
    fn Size => Vector doremi _size
    fn SetSize double x, double y => do _size = Vector(x,y)
    fn SetOffset double x, double y => do _offset = Vector(x,y)
    fn SetColor short col => do _color = col
    fn draw Ncurses *n =>
        n->col(_color)
        n->add(_offset.y, _offset.x, _size.x)
        n->box(_offset.y, _offset.x, _size.y, _size.x)
        n->col(_color, false)
    ;
;

class GroupedContainer => IContainer
protected
    vector<IContainer*> _containers = {}
    GroupedContainer => do return
pub
    fn add IContainer* c => do _containers.push_back(c)
    fn draw Ncurses *n =>
        n->box(0, 0, _size.x, _size.y)
        foreach c in _containers do c->draw(n)
    ;
;

class VerticalLayout => GroupedContainer
    VerticalLayout => do return
    VerticalLayout Fill f =>
        _fill_x = f
        _fill_y = f
    ;
    VerticalLayout Fill f, Vector s =>
        _fill_x = f
        _fill_y = f
        _size = s
    ;
    pub fn draw Ncurses *n => do ((GroupedContainer*)this)->draw(n)
    pub fn update =>
        double available_space = _size.y
        int offset = 0
        int sharers = 0
        foreach c in _containers
            if !is_active do continue
            switch c->FillY()
            case Fill::Static dobr available_space -= c->Size().y
            case Fill::Flex dobr sharers++
            ;
        ;
        foreach c in _containers
            if !is_active do continue
            c->SetOffset(0, offset)
            if c->FillY() == Fill::Flex
                c->SetSize(_size.x, (available_space / sharers))
            ;
            else do c->SetSize(_size.x, c->Size().y)
            offset += c->Size().y
        ;
    ;
;

class HorizontalLayout => GroupedContainer
    HorizontalLayout => do return
    HorizontalLayout Fill f =>
        _fill_x = f
        _fill_y = f
    ;
    HorizontalLayout Fill f, Vector s =>
        _fill_x = f
        _fill_y = f
        _size = s
    ;
    pub fn draw Ncurses *n => do ((GroupedContainer*)this)->draw(n)
    pub fn update =>
        double available_space = _size.x
        int offset = 0
        int sharers = 0
        foreach c in _containers
            if !is_active do continue
            switch c->FillX()
            case Fill::Static dobr available_space -= c->Size().x
            case Fill::Flex dobr sharers++
            ;
        ;
        foreach c in _containers
            if !is_active do continue        
            c->SetOffset(offset, 0)
            if c->FillX() == Fill::Flex
                c->SetSize((available_space / sharers), _size.y)
            ;
            else do c->SetSize(c->Size().x, _size.y)
            offset += c->Size().x
        ;
    ;
;

class MainContainer => VerticalLayout
    MainContainer =>
        _size = Vector(COLS, LINES)
    ;
    pub fn update =>
        _size = Vector(COLS, LINES)
        ((VerticalLayout*)this)->update()
    ;
    pub fn draw Ncurses *n =>
        update()
        ((VerticalLayout*)this)->draw(n)
    ;
;
