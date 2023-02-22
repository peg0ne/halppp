get => HorizontalLayout
class StepLayout => HorizontalLayout
    vector<IContainer*> _elements = {}
    vector<IContainer*> _dividers = {}
    StepLayout =>
        _type = ContainerType::Horizontal
    ;
    StepLayout Fill f =>
        _type = ContainerType::Horizontal
        _fill_x = f
        _fill_y = f
    ;
    StepLayout Fill f, Vector s =>
        _type = ContainerType::Horizontal
        _fill_x = f
        _fill_y = f
        _size = s
    ;
    StepLayout Vector s, Vector o =>
        _type = ContainerType::Horizontal
        _size = s
        _offset = o
    ;
    fn get_row => IContainer*
        let div = new HorizontalLayout(Fill::Flex)
        _dividers.push_back(div)
        return div
    ;
pub
    fn add_element IContainer* element =>
        let row = get_row()
        row->add(element)
        if _dividers.size() == 1 do add(row)
        else do _dividers[_dividers.size() - 2]->add(row)
    ;
    fn destruct =>
        foreach div in _dividers do delete(div)
        _dividers.clear()
    ;
;