get => enums/[movement, commands, rects]
get => components/IContainer

class Model => MainContainer
    HorizontalLayout _top
    HorizontalLayout _editors
    HorizontalLayout _status
    IContainer _fileex
    IContainer _mode
    IContainer _line
    IContainer _cmd
    Ncurses n = Ncurses()

    Model int argc, char **argv =>
        _top = HorizontalLayout(Fill::Flex)
        _fileex = IContainer(Fill::Static, Vector(25,0))
        _editors = HorizontalLayout(Fill::Flex)
        _status = HorizontalLayout(Fill::Static, Vector(0,1))
        _mode = IContainer(Fill::Static, Vector(15,0))
        _line = IContainer(Fill::Flex)
        _cmd = IContainer(Fill::Static, Vector(0,1))

        _top.add(&_fileex)
        _top.add(&_editors)

        _status.add(&_mode)
        _status.add(&_line)

        add(&_top)
        add(&_status)
        add(&_cmd)

        _top.SetColor(0)
        _status.SetColor(1)
        _mode.SetColor(2)
        _cmd.SetColor(3)

        update()

        draw(&n)
    ;
;
