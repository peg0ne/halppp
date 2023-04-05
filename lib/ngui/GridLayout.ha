get => VerticalLayout
class GridLayout => VerticalLayout
    vector<IContainer*> _grid_elements = {}
    vector<HorizontalLayout*> _rows = {}
    GridLayout =>
        _type = ContainerType::Grid
    ;
    GridLayout Fill f =>
        _type = ContainerType::Grid
        _fill_x = f
        _fill_y = f
    ;
    GridLayout Fill f, Vector s =>
        _type = ContainerType::Grid
        _fill_x = f
        _fill_y = f
        _size = s
    ;
    GridLayout Vector s, Vector o =>
        _type = ContainerType::Grid
        _size = s
        _offset = o
    ;
pub
    fn draw Ncurses *n =>
        if !is_active do return
        arrange_elements()
        ((VerticalLayout*)this)->draw(n)
    ;
    fn add_row => HorizontalLayout*
        let row = new HorizontalLayout(Fill::Flex)
        add(row)
        _rows.push_back(row)
        arrange_elements()
        return row
    ;
    fn add_element IContainer* element =>
        _grid_elements.push_back(element)
        arrange_elements()
    ;
    fn arrange_elements =>
        if _rows.size() == 0 do return
        foreach row in _rows do row->clear()
        foreach i, ele in _grid_elements
            _rows[i % _rows.size()]->add(ele)
        ;
    ;
    fn destruct =>
        foreach row in _rows do delete(row)
        foreach ele in _grid_elements do delete(ele)
        _grid_elements.clear()
        _rows.clear()
    ;
;