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
        _top.SetLabel("TOP")
        _status = HorizontalLayout(Fill::Static, Vector(0,1))
        _status.SetColor(1)
        _status.SetLabel("STATUS")
        _cmd = IContainer(Fill::Static, Vector(0,1))
        _cmd.SetColor(4)
        _cmd.SetLabel("CMD")

        add(&_top)
        add(&_status)
        add(&_cmd)

        _fileex = IContainer(Fill::Static, Vector(25,0))
        _fileex.SetColor(5)
        _fileex.SetLabel("FILEEX")
        _grid = VerticalLayout(Fill::Flex)
        _grid.SetColor(6)
        _grid.SetLabel("EDITORS")

        _top.add(&_fileex)
        _top.add(&_grid)

        _mode = IContainer(Fill::Static, Vector(15,0))
        _mode.SetColor(2)
        _mode.SetLabel("MODE")
        _line = IContainer(Fill::Flex)
        _line.SetColor(3)
        _line.SetLabel("LINE")

        _status.add(&_mode)
        _status.add(&_line)

        update()

        draw(&n)
    ;
;
