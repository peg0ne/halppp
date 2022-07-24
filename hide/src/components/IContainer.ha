enum ContainerType
    Base,
    Grouped,
    Vertical,
    Horizontal,
    Main,
;

class IContainer
protected
    ContainerType _type
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
        _type = ContainerType::Base
        _fill_x = f
        _fill_y = f
    ;
    IContainer Fill f, Vector s =>
        _type = ContainerType::Base
        _fill_x = f
        _fill_y = f
        _size = s
    ;
    IContainer Vector s, Vector o =>
        _type = ContainerType::Base
        _size = s
        _offset = o
    ;
    IContainer Fill f_x, Fill f_y, Vector s, Vector o =>
        _type = ContainerType::Base
        _fill_x = f_x
        _fill_y = f_y
        _size = s
        _offset = o
    ;
    IContainer AnchorX a_x, AnchorY a_y, Fill f_x, Fill f_y, Vector s, Vector o =>
        _type = ContainerType::Base
        _anchor_x = a_x
        _anchor_y = a_y
        _fill_x = f_x
        _fill_y = f_y
        _size = s
        _offset = o
    ;
pub
    fn Type => ContainerType doremi _type
    fn FillY => Fill doremi _fill_y
    fn FillX => Fill doremi _fill_x
    fn Size => Vector doremi _size
    fn Active => bool doremi is_active
    fn SetActive bool active => do is_active = active
    fn SetSize double x, double y => do _size = Vector(x,y)
    fn SetOffset double x, double y => do _offset = Vector(x,y)
    fn SetColor short col => do _color = col
    fn draw Ncurses *n =>
        if !is_active do return
        n->col(_color)
        n->box(_offset.y, _offset.x, _size.y, _size.x)
        n->col(_color, false)
    ;
;

class GroupedContainer => IContainer
protected
    vector<IContainer*> _containers = {}
    GroupedContainer =>
        _type = ContainerType::Grouped
    ;
pub
    fn add IContainer* c => do _containers.push_back(c)
    fn draw Ncurses *n =>
        if !is_active do return
        ((IContainer*)this)->draw(n)
        foreach c in _containers do draw_container_impl(c,n)
    ;
;

class VerticalLayout => GroupedContainer
    VerticalLayout => do return
    VerticalLayout Fill f =>
        _type = ContainerType::Vertical
        _fill_x = f
        _fill_y = f
    ;
    VerticalLayout Fill f, Vector s =>
        _type = ContainerType::Vertical
        _fill_x = f
        _fill_y = f
        _size = s
    ;
    pub fn draw Ncurses *n =>
        if !is_active do return
        update()
        ((GroupedContainer*)this)->draw(n)
    ;
    pub fn update =>
        double available_space = _size.y
        int offset = 0
        int sharers = 0
        int extra = 0
        foreach c in _containers
            if !c->Active() do continue        
            switch c->FillY()
            case Fill::Static dobr available_space -= c->Size().y
            case Fill::Flex dobr sharers++
            ;
        ;
        if sharers != 0
            int space = available_space/sharers
            int diff = available_space - (space * sharers)
            extra = diff
        ;
        for i until _containers.size()
            let c = _containers.at(i)
            if !c->Active() do continue        
            c->SetOffset(_offset.x, offset + _offset.y)
            if c->FillY() == Fill::Flex
                c->SetSize(_size.x, (available_space / sharers))
            ;
            if i + 1 == _containers.size()
                c->SetSize(c->Size().x, c->Size().y + extra)
            ;
            else do c->SetSize(_size.x, c->Size().y)
            offset += c->Size().y
        ;
    ;
;

class HorizontalLayout => GroupedContainer
    HorizontalLayout => 
        _type = ContainerType::Horizontal
    ;
    HorizontalLayout Fill f =>
        _type = ContainerType::Horizontal
        _fill_x = f
        _fill_y = f
    ;
    HorizontalLayout Fill f, Vector s =>
        _type = ContainerType::Horizontal
        _fill_x = f
        _fill_y = f
        _size = s
    ;
    pub fn draw Ncurses *n =>
        if !is_active do return
        update()
        ((GroupedContainer*)this)->draw(n)
    ;
    pub fn update =>
        double available_space = _size.x
        int offset = 0
        int sharers = 0
        int extra = 0
        foreach c in _containers
            if !c->Active() do continue
            switch c->FillX()
            case Fill::Static dobr available_space -= c->Size().x
            case Fill::Flex dobr sharers++
            ;
        ;
        if sharers != 0
            int space = available_space/sharers
            int diff = available_space - (space * sharers)
            extra = diff
        ;
        for i until _containers.size()
            let c = _containers.at(i)
            if !c->Active() do continue        
            c->SetOffset(offset + _offset.x, _offset.y)
            if c->FillX() == Fill::Flex
                c->SetSize((available_space / sharers), _size.y)
            ;
            if i + 1 == _containers.size()
                c->SetSize(c->Size().x + extra, c->Size().y)
            ;
            else do c->SetSize(c->Size().x, _size.y)
            offset += c->Size().x
        ;
    ;
;

class MainContainer => VerticalLayout
    MainContainer =>
        _type = ContainerType::Main
        _size = Vector(COLS, LINES)
    ;
    pub fn update =>
        _size = Vector(COLS, LINES)
        ((VerticalLayout*)this)->update()
    ;
    pub fn draw Ncurses *n =>
        if !is_active do return
        update()
        ((VerticalLayout*)this)->draw(n)
    ;
;

fn draw_container_impl IContainer* c, Ncurses *n =>
    if !c->Active() do return
    switch c->Type()
    case ContainerType::Base dobr c->draw(n)
    case ContainerType::Grouped
        ((GroupedContainer*)c)->draw(n)
        break
    case ContainerType::Vertical
        ((VerticalLayout*)c)->update()
        ((VerticalLayout*)c)->draw(n)
        break
    case ContainerType::Horizontal
        ((HorizontalLayout*)c)->update()
        ((HorizontalLayout*)c)->draw(n)
        break
    case ContainerType::Main
        ((MainContainer*)c)->update()
        ((MainContainer*)c)->draw(n)
        break
    default do break
    ;
;
