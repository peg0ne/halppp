get => ../[rects, option, list, vector, ncurses]
get => ContainerEnums, NGuiOutline
class IContainer
protected
    string _label = ""
    Option<string> _fill_str = None<string>()
    List<string> _content = List<string>()
    List<IContainer*> _containers = List<IContainer*>()
    ContainerType _type = ContainerType::Base
    short _color = 0
    Fill _fill_x = Fill::Flex
    Fill _fill_y = Fill::Flex
    Vector _size = Vector(0,0)
    Vector _offset = Vector(0,0)
    bool is_active = true
    bool is_outline = false
    NGuiOutline outline = NGuiOutline()
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
    IContainer Fill f, Vector s, string fill_str =>
        _fill_x = f
        _fill_y = f
        _size = s
        _fill_str = fill_str
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
    fn SetSize int x, int y => do _size = Vector(x,y)
    fn SetOffset int x, int y => do _offset = Vector(x,y)
    fn SetColor short col => do _color = col
    fn SetLabel string label => do _label = label
    fn SetContent List<string> content =>
        _content.clear()
        _content = content
    ;
    fn ToggleOutline => do is_outline = !is_outline
    fn GetContent => List<string> doremi _content
    fn add IContainer* c => do _containers.add(c)
    fn size => int doremi _containers.len()
    fn containers => List<IContainer*>* doremi &_containers
    fn clear => do _containers = {}
    fn draw_outline Ncurses *n =>
        if is_outline
            n->add(_offset.y-1, _offset.x-1, outline.lu_corner)
            for i until _size.x do n->add(_offset.y-1, _offset.x+i, outline.horizontal)
            n->add(_offset.y-1, _offset.x-1 + _size.x + 1, outline.ru_corner)
            for i until _size.y
                n->add(_offset.y+i, _offset.x-1, outline.vertical)
                n->add(_offset.y+i, _offset.x-1 + _size.x + 1, outline.vertical)
            ;
            n->add(_offset.y-1 + _size.y + 1, _offset.x-1, outline.ld_corner)
            for i until _size.x do n->add(_offset.y-1 + _size.y + 1, _offset.x+i, outline.horizontal)
            n->add(_offset.y-1 + _size.y + 1, _offset.x-1 + _size.x + 1, outline.rd_corner)
        ;
    ;
    fn draw Ncurses *n =>
        if !is_active do return
        n->col(_color < 0 ? -_color : _color)
        if _color >= 0 do n->invis_box(_offset, _size)
        else do n->box(_offset - Vector(1,1), _size + Vector(2,2))
        select filling from _fill_str
            for i until _size.y do n->add(_offset.y + i, _offset.x, filling)
        ;
        n->add_until(_offset, _label, _size.x + _offset.x, true)
        let i = 0
        foreach s in _content
            if i >= _size.y do break
            n->add_until(_offset.y + i++, _offset.x, s, _size.x + _offset.x, false)
        ;
        n->col(_color < 0 ? -_color : _color, false)
    ;
;