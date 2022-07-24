get => enums/[movement, commands]
get => components/[IComponent, core/[line, content]]
get => components/[cmdline, modeview]
get => components/[statusline, editor, fileexplorer]

struct Model
    Vector rect
    bool is_alive = true
    bool is_dirty = true
    Ncurses n = Ncurses()
    CommandLine cmdline = CommandLine(&n)
    ModeView modeview = ModeView(&n)
    StatusLine statusline = StatusLine(&n)
    FileExplorer fileexplorer = FileExplorer(&n, ".")
    vector<Editor> editors = {}
    Option<Editor*> active = None<Editor*>()
    Model int argc, char **argv =>
        curs_set(0)
        this->rect = Vector(COLS, LINES)
        if argc >= 2 do open_editor(argv[1])
    ;
    fn dirty => do is_dirty = true
    fn find_editor_index string path => int
        for i until editors.size()
            if editors.at(i).path == path doremi i
        ;
        return -1
    ;
    fn find_editor string path => Option<Editor*>
        for i until editors.size()
            if editors.at(i).path == path doremi Some(&editors.at(i))
        ;
        return None<Editor*>()
    ;
    fn get_editor_at int at => Option<Editor*>
        if at < editors.size() doremi Some(&editors.at(at))
        return None<Editor*>()
    ;
    fn open_editor string path =>
        dirty()
        modeview.set(Mode::Normal)
        select a from active do a->is_active = false
        select e from find_editor(path)
            e->is_active = true
            active = Some(e)
            return
        ;
        let new_editor = Editor(&n, &statusline, path, editors.size())
        editors.push_back(new_editor)
        active = Some(&editors.back())
    ;
    fn close_editor =>
        if editors.size() == 1 do return
        dirty()
        modeview.set(Mode::Normal)
        vector<Editor> buf = {}
        select a from active
            foreach e in editors
                if e.path == a->path do continue
                e.active(false)
                buf.push_back(e)
            ;
        ;
        editors = buf
        select e from get_editor_at(0)
            e->active(true)
            active = Some(e)
        ;
    ;
    fn draw =>
        if COLS != rect.x || LINES != rect.y || is_dirty
            rect = Vector(COLS, LINES)
            n.clearScr()
        ;
        cmdline.draw()
        modeview.draw()
        statusline.draw()
        fileexplorer.draw(modeview.is_filex())
        for i until editors.size() do editors.at(i).draw(editors.size(), i, modeview.mode == Mode::FileEx)
    ;
    fn is_exit => bool
        let mode = modeview.mode
        let cmd = Command::Nop
        switch mode
        case Mode::FileEx dobr cmd = fileexplorer.run()
        case Mode::CmdHan dobr cmd = cmdline.run()
        case Mode::Normal 
        case Mode::Visual 
        case Mode::Insert
            select a from active dobr cmd = a->run(mode, find_editor_index(a->path), editors.size())
            break
        ;
        switch cmd
        case Command::Exit dobr n.stop(); return true
        case Command::ModeFileEx dobr modeview.set(Mode::FileEx)
        case Command::ModeCmdHan dobr modeview.set(Mode::CmdHan)
        case Command::ModeNormal dobr active.is_none() ? modeview.set(Mode::FileEx) : modeview.set(Mode::Normal)
        case Command::ModeInsert dobr active.is_none() ? modeview.set(Mode::FileEx) : modeview.set(Mode::Insert)
        case Command::ModeVisual dobr active.is_none() ? modeview.set(Mode::FileEx) : modeview.set(Mode::Visual)
        case Command::SelectFile dobr open_editor(fileexplorer.get_fp())
        case Command::Nop do break
        ;
        return false
    ;
;
