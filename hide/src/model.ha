get => enums/[movement, commands, rects, modes, textedit]
get => components/IContent
get => EditorManager
get => components/[Explorer, CommandLine, ModeView, Terminal]

class Model => MainContainer
    IContainer _line = IContainer(Fill::Flex)
    HorizontalLayout _top = HorizontalLayout(Fill::Flex)
    HorizontalLayout _status = HorizontalLayout(Fill::Static, Vector(0,1))
    Terminal _term = Terminal()
    Explorer _explorer = Explorer()
    ModeView _mode_view = ModeView()
    EditorManager _manager = EditorManager(&_line)
    CommandLine _command_line = CommandLine(&_manager)

    Model int argc, char **argv =>
        mousemask(ALL_MOUSE_EVENTS, NULL)
        _top.SetColor(0)
        _status.SetColor(1)
        _line.SetColor(3)
        _line.SetLabel(" << [f] $ [0,0]")

        add(&_top)
        add(&_status)
        add(_command_line.origin())

        _top.add(_explorer.origin())
        _top.add(_manager.origin())

        _status.add(_mode_view.origin())
        _status.add(&_line)

        if argc >= 2
            _manager.open_file(argv[1])
        ;

        update()
        draw()
    ;
pub
    fn render =>
        update()
        draw()
        _explorer.draw()
        _manager.draw()
    ;
    fn run => bool
        let mode = _mode_view.mode()
        let cmd = Command::Nop
        curs_set(mode == Mode::Insert)
        //Mode Dependant run
        switch mode
        case Mode::FileEx dobr cmd = _explorer.run()
        case Mode::CmdHan dobr cmd = _command_line.run(&_manager)
        case Mode::Normal 
        case Mode::Visual 
        case Mode::Insert dobr cmd = _manager.run(mode)
        ;
        //Command with mode changes
        switch cmd
        case Command::CloseEditor dobr cmd = _manager.close_editor()
        case Command::CloseEditorForced dobr cmd = _manager.close_editor(true)
        case Command::WriteEditor dobr cmd = _manager.write_editor()
        case Command::WriteCloseEditor
            _manager.write_editor()
            cmd = _manager.close_editor()
            break
        ;
        //Ye ol commands
        switch cmd
        case Command::Exit
            Ncurses::stop()
            return true
        case Command::ModeFileEx dobr _mode_view.set(Mode::FileEx)
        case Command::ModeCmdHan dobr _mode_view.set(Mode::CmdHan)
        case Command::ModeNormal dobr _mode_view.set(Mode::Normal)
        case Command::ModeInsert dobr _mode_view.set(Mode::Insert)
        case Command::ModeVisual dobr _mode_view.set(Mode::Visual)
        case Command::SelectFile dobr _manager.open_file(_explorer.get_fp())
        case Command::SplitVertical   dobr _manager.add_space()
        case Command::SplitHorizontal dobr _manager.add_editor()
        case Command::EditorTemplates dobr _manager.templates()
        case Command::EditorSearch    dobr _manager.search()
        case Command::EditorReplace   dobr _manager.replace()
        case Command::Terminal        dobr _term.show()
        case Command::Nop do break
        ;
        _explorer.set_visibility(_mode_view.mode())
        return false
    ;
;