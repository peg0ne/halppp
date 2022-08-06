class ModeView => IContent
    string _line = ""
    Mode _mode = Mode::FileEx
    ModeView Ncurses *n =>
        _origin = new IContainer(Fill::Static, Vector(10,0))
        _origin->SetColor(5)
        this->n = n
        set(_mode)
    ;
pub 
    fn set Mode mode =>
        _mode = mode
        _line = $"  {mode}  "
        _origin->SetLabel(_line)
    ;
    fn mode => Mode doremi _mode
;
