get => enums/[movement, commands, rects, modes, textedit]
get => components/[IContainer, IContent]
get => components/[CommandLine, Editor, Explorer, ModeView]

class Model => MainContainer
    Ncurses n = Ncurses()
    Option<Editor*> _active = None<Editor*>()
    HorizontalLayout _top = HorizontalLayout(Fill::Flex)
    HorizontalLayout _status = HorizontalLayout(Fill::Static, Vector(0,1))
    vector<HorizontalLayout> _editorspace = {}
    vector<Editor> _editors_a = {}
    vector<Editor> _editors_b = {}
    vector<Editor> _editors_c = {}
    vector<Editor> _editors_d = {}
    vector<Editor> _editors_e = {}
    VerticalLayout _grid = VerticalLayout(Fill::Flex)
    Explorer _explorer = Explorer(&n)
    CommandLine _command_line = CommandLine(&n)
    ModeView _mode_view = ModeView(&n)
    IContainer _line = IContainer(Fill::Flex)

    Model int argc, char **argv =>
        curs_set(0)
        _top.SetColor(0)
        _status.SetColor(1)
        _grid.SetColor(6)
        _line.SetColor(3)
        _line.SetLabel(" << [f] $ [0,0]")

        add(&_top)
        add(&_status)
        add(_command_line.origin())

        _top.add(_explorer.origin())
        _top.add(&_grid)

        _status.add(_mode_view.origin())
        _status.add(&_line)

        add_space()
        update()
        draw(&n)
    ;
pub
    fn refresh =>
        _grid.clear()
        for i until _editorspace.size()
            if !_editorspace.at(i).Active() do continue
            _grid.add(&_editorspace.at(i))
        ;
    ;
    fn get_list int index => vector<Editor>*
        switch index
        case 1 doremi &_editors_a
        case 2 doremi &_editors_b
        case 3 doremi &_editors_c
        case 4 doremi &_editors_d
        case 5 doremi &_editors_e
        default doremi &_editors_a
        ;
    ;
    fn open_file string path =>
        select a from _active
            a->open(path)
        ;
    ;
    fn close_editor => bool
        select a from _active
            a->set_active(false)
            for i until _editorspace.size()
                let editors = get_list(_editorspace.size() - i)
                for j until editors->size()
                    let is_active = editors->at(j).is_active()
                    if is_active
                        _active = Some(&editors->at(j))
                        _mode_view.set(Mode::Normal)
                        return false
                    ;
                ;
                _editorspace.at(_editorspace.size() - 1 - i).SetActive(false)
                refresh()
            ;
        ;
        n.stop();
        return true
    ;
    fn add_editor Option<string> path =>
        let editors = get_list(_editorspace.size())
        if editors->size() >= 5 do return
        editors->push_back(Editor(&n, path.value_or("")))
        _active = Some(&editors->back())
        if editors->size() <= 0 do return
        for i until _editorspace.size()
            let e = _editorspace.at(i)
            e.clear()
            editors = get_list(i+1)
            for j until editors->size() do e.add(editors->at(j).origin())
            _editorspace[i] = e
        ;
        refresh()
        _mode_view.set(Mode::FileEx)
    ;
    fn add_space =>
        if _editorspace.size() >= 5 do return
        _editorspace.push_back(HorizontalLayout(Fill::Flex))
        if _editorspace.size() <= 0 do return
        add_editor(None<string>())
    ;
    fn render =>
        update()
        draw(&n)
        _explorer.draw()
        for i until _editorspace.size()
            let editors = get_list(i+1)
            for j until editors->size() do editors->at(j).draw()
        ;
        select a from _active do a->draw(6)
    ;
    fn run => bool
        let mode = _mode_view.mode()
        let cmd = Command::Nop
        switch mode
        case Mode::FileEx dobr cmd = _explorer.run()
        case Mode::CmdHan dobr cmd = _command_line.run()
        case Mode::Normal 
        case Mode::Visual 
        case Mode::Insert
            select a from _active
                cmd = a->run(mode)
            ;
            break
        ;
        switch cmd
        case Command::Exit dobr n.stop(); return true
        case Command::ModeFileEx dobr _mode_view.set(Mode::FileEx)
        case Command::ModeCmdHan dobr _mode_view.set(Mode::CmdHan)
        case Command::ModeNormal dobr _active.is_none() ? _mode_view.set(Mode::FileEx) : _mode_view.set(Mode::Normal)
        case Command::ModeInsert dobr _active.is_none() ? _mode_view.set(Mode::FileEx) : _mode_view.set(Mode::Insert)
        case Command::ModeVisual dobr _active.is_none() ? _mode_view.set(Mode::FileEx) : _mode_view.set(Mode::Visual)
        case Command::SelectFile dobr open_file(_explorer.get_fp())
        case Command::SplitVertical dobr add_space()
        case Command::SplitHorizontal dobr add_editor(None<string>())
        case Command::CloseEditor doremi close_editor()
        case Command::Nop do break
        ;
        _explorer.set_visibility(_mode_view.mode())
        return false
    ;
;
