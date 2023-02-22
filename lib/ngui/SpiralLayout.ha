get => VerticalLayout
class SpiralLayout => VerticalLayout
    vector<IContainer*> _elements = {}
    vector<IContainer*> _dividers = {}
    SpiralLayout =>
        _type = ContainerType::Vertical
    ;
    SpiralLayout Fill f =>
        _type = ContainerType::Vertical
        _fill_x = f
        _fill_y = f
    ;
    SpiralLayout Fill f, Vector s =>
        _type = ContainerType::Vertical
        _fill_x = f
        _fill_y = f
        _size = s
    ;
    SpiralLayout Vector s, Vector o =>
        _type = ContainerType::Vertical
        _size = s
        _offset = o
    ;
    fn get_row => IContainer*
        let div = (
            _dividers.size() % 2 == 0
                ? (IContainer*)new HorizontalLayout(Fill::Flex)
                : (IContainer*)new VerticalLayout(Fill::Flex)
        )
        _dividers.push_back(div)
        return div
    ;
pub
    fn add_element IContainer* element =>
        let row = get_row()
        row->add(element)
        if _dividers.size() == 1 do add(row)
        elif _dividers.size() > 3
            _dividers[_dividers.size() - 2]->containers()->insert(0, row)
        ;
        else do _dividers[_dividers.size() - 2]->add(row)
    ;
    fn destruct =>
        foreach div in _dividers do delete(div)
        _dividers.clear()
    ;
;