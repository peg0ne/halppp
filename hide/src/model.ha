get => enums/[movement, commands, rects]
get => components/IContainer

class Model => MainContainer
    HorizontalLayout _top
    HorizontalLayout _status
    vector<HorizontalLayout> _editorspace
    vector<IContainer> _editors
    VerticalLayout _grid
    IContainer _fileex
    IContainer _mode
    IContainer _line
    IContainer _cmd
    Ncurses n = Ncurses()

    Model int argc, char **argv =>
        _top = HorizontalLayout(Fill::Flex)
        _top.SetColor(0)
        _status = HorizontalLayout(Fill::Static, Vector(0,1))
        _status.SetColor(1)
        _cmd = IContainer(Fill::Static, Vector(0,1))
        _cmd.SetColor(4)

        add(&_top)
        add(&_status)
        add(&_cmd)

        _fileex = IContainer(Fill::Static, Vector(25,0))
        _fileex.SetColor(5)
        _grid = VerticalLayout(Fill::Flex)
        _grid.SetColor(6)
        _editorspace = {HorizontalLayout(Fill::Flex)}
        _editors = {IContainer(Fill::Flex)}
        _editorspace.back().add(&_editors.back())
        _grid.add(&_editorspace.back())

        _top.add(&_fileex)
        _top.add(&_grid)

        _mode = IContainer(Fill::Static, Vector(15,0))
        _mode.SetColor(2)
        _line = IContainer(Fill::Flex)
        _line.SetColor(3)

        _status.add(&_mode)
        _status.add(&_line)

        update()

        draw(&n)
    ;
    pub fn add_space =>
        _editorspace.push_back(HorizontalLayout(Fill::Flex))
        add_editor()
    ;
    pub fn add_editor =>
        _editors.push_back(IContainer(Fill::Flex))
    ;
    pub fn render =>
        update()
        draw(&n)
    ;
    pub fn file_ex =>
        _fileex.SetActive(!_fileex.Active())
    ;
;
