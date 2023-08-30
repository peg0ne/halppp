class Selectable => IContent
    bool _selected = false
    IContainer _field = IContainer()
    IContainer _spacer_t = IContainer()
    IContainer _spacer_b = IContainer()
    Selectable string value =>
        _origin = new VerticalLayout(Fill::Static, Vector(0,3))
        _origin->add(&_spacer_t)
        _origin->add(&_field)
        _origin->add(&_spacer_b)
        _field.SetLabel(value)
        _field.ToggleOutline()
    ;
pub
    fn draw =>
        ((VerticalLayout*)_origin)->draw()
        _field.draw_outline()
    ;
    fn toggle_selection bool selected =>
        _selected = selected
        _field.SetColor(_selected ? -5 : 2)
    ;
    fn set_label string value => do _field.SetLabel(value)
    fn set_offset int x, int y => do _origin->SetOffset(x, y)
    fn set_width int width => do _origin->SetSize(width - 1, 3)
;
