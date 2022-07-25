get => enums/[movement, commands, rects]
get => components/IContainer

class Model => MainContainer
    HorizontalLayout _top
    HorizontalLayout _status
    vector<HorizontalLayout> _editorspace = {}
    vector<IContainer> _editors_a = {}
    vector<IContainer> _editors_b = {}
    vector<IContainer> _editors_c = {}
    vector<IContainer> _editors_d = {}
    vector<IContainer> _editors_e = {}
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

        _top.add(&_fileex)
        _top.add(&_grid)

        _mode = IContainer(Fill::Static, Vector(15,0))
        _mode.SetColor(2)
        _line = IContainer(Fill::Flex)
        _line.SetColor(3)

        _status.add(&_mode)
        _status.add(&_line)

        add_space()
        update()
        draw(&n)
    ;
    pub fn refresh =>
        _grid.clear()
        for i until _editorspace.size() do _grid.add(&_editorspace.at(i))
    ;
    pub fn get_list int index => vector<IContainer>*
        switch index
        case 1 doremi &_editors_a
        case 2 doremi &_editors_b
        case 3 doremi &_editors_c
        case 4 doremi &_editors_d
        case 5 doremi &_editors_e
        default doremi &_editors_a
        ;
    ;
    pub fn add_editor =>
        let editors = get_list(_editorspace.size())
        if editors->size() >= 5 do return
        editors->push_back(IContainer(Fill::Flex))
        if editors->size() <= 0 do return
        for i until _editorspace.size()
            let e = _editorspace.at(i)
            e.clear()
            editors = get_list(i+1)
            for j until editors->size()
                e.add(&editors->at(j))
            ;
            _editorspace[i] = e
        ;
        refresh()
    ;
    pub fn add_space =>
        if _editorspace.size() >= 5 do return
        _editorspace.push_back(HorizontalLayout(Fill::Flex))
        if _editorspace.size() <= 0 do return
        add_editor()
    ;
    pub fn render =>
        update()
        draw(&n)
    ;
    pub fn file_ex =>
        _fileex.SetActive(!_fileex.Active())
    ;
;
