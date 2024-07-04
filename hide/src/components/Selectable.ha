class Selectable => IContent
    function<void()> _func
    bool _has_func = false
    bool _selected = false
    bool _outline = true
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
    fn add_func function<void()> func =>
        _func = func
        _has_func = true
    ;
    fn clear_func => do _has_func = false
    fn execute func =>
        if _has_func do _func()
        else do Ncurses::add(0,0,"No Func")
    ;
    fn draw =>
        ((VerticalLayout*)_origin)->draw()
        if (_outline) do _field.draw_outline()
    ;
    fn toggle_selection bool selected =>
        let selected_color = _outline ? -5 : 5
        _selected = selected
        _field.SetColor(_selected ? selected_color : 2)
    ;
    fn set_outline bool enabled =>
        _outline = enabled
        _spacer_t.SetActive(enabled)
        _spacer_b.SetActive(enabled)
        _origin->SetSize(0, enabled ? 3 : 1)
    ;
    fn set_label string value => do _field.SetLabel(value)
    fn set_offset int x, int y => do _origin->SetOffset(x, y)
    fn set_width int width => do _origin->SetSize(width - 1, _outline ? 3 : 1)
    fn has_outline => bool doremi _outline
;
