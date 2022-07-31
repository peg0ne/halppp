enum ContainerType
    Base,
    Grouped,
    Vertical,
    Horizontal,
    Main,
;

class IContainer
protected
    string _label = " "
    List<string> _content = List<string>()
    List<IContainer*> _containers = List<IContainer*>()
    ContainerType _type = ContainerType::Base
    short _color = 0
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
pub
    fn Type => ContainerType doremi _type
    fn FillY => Fill doremi _fill_y
    fn FillX => Fill doremi _fill_x
    fn Size => Vector doremi _size
    fn Offset => Vector doremi _offset
    fn Color => short doremi _color
    fn Label => string doremi _label
    fn Active => bool doremi is_active
    fn SetActive bool active => do is_active = active
    fn SetSize double x, double y => do _size = Vector(x,y)
    fn SetOffset double x, double y => do _offset = Vector(x,y)
    fn SetColor short col => do _color = col
    fn SetLabel string label => do _label = label
    fn SetContent List<string> content => do _content = content
    fn GetContent => List<string> doremi _content
    fn add IContainer* c => do _containers.add(c)
    fn size => int doremi _containers.len()
    fn containers => List<IContainer*>* doremi &_containers
    fn clear => do _containers = {}
    fn draw Ncurses *n =>
        if !is_active do return
        n->col(_color)
        n->invis_box(_offset.y, _offset.x, _size.y, _size.x)
        n->add_until(_offset.y, _offset.x, _label, _size.x + _offset.x, true)
        let i = 0
        foreach s in _content
            if i >= _size.y do break
            n->add_until(_offset.y + i++, _offset.x, s, _size.x + _offset.x, false)
        ;
        n->col(_color, false)
    ;
;

class GroupedContainer => IContainer
protected
    GroupedContainer =>
        _type = ContainerType::Grouped
    ;
pub
    fn draw Ncurses *n =>
        if !is_active do return
        ((IContainer*)this)->draw(n)
        foreach c in _containers do draw_container_impl(c,n)
    ;
;

class VerticalLayout => GroupedContainer
    VerticalLayout =>
        _type = ContainerType::Vertical
    ;
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
                c->SetSize(_size.x, c->Size().y + extra)
            ;
            c->SetSize(_size.x, c->Size().y)
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
                c->SetSize(c->Size().x + extra, _size.y)
            ;
            c->SetSize(c->Size().x, _size.y)
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
        ((IContainer*)this)->draw(n)
        foreach c in _containers do draw_container_impl(c,n)
    ;
;

fn draw_container_impl IContainer* c, Ncurses *n =>
    if !c->Active() do return
    switch c->Type()
    case ContainerType::Base dobr c->draw(n)
    case ContainerType::Grouped dobr ((GroupedContainer*)c)->draw(n)
    case ContainerType::Vertical dobr ((VerticalLayout*)c)->draw(n)
    case ContainerType::Horizontal dobr ((HorizontalLayout*)c)->draw(n)
    case ContainerType::Main dobr ((MainContainer*)c)->draw(n)
    default 
        n->add(2,0,c->Label())
        n->add(1,0,(int)c->Type())
        n->add(0,0,"ERORR")
        n->key()
        break
    ;
;
