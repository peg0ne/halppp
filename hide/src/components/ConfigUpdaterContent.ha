class ConfigUpdaterContent => IContent
    IContainer _header = IContainer(Fill::Static, Vector(0, 1))
    ConfigUpdaterContent string header =>
        _header.SetLabel(header)
        _origin = new MainContainer(Vector(9,3))
        _origin->SetColor(-1)
        _origin->add(&_header)
    ;
pub
    fn add IContainer* container => do _origin->add(container)
    fn draw => do ((MainContainer*)_origin)->draw()
    fn destruct => do delete _origin
;
