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
    ;
pub
    fn toggle_selection bool selected =>
        _selected = selected
        _field.SetColor(_selected ? -5 : 0)
    ; 
;
