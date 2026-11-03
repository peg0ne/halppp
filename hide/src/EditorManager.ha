get => components/Editor

// General hide settings; every other .json in ~/.config/hide is a syntax
glob
    SETTINGS_FILE "settings.json"
;
class EditorManager => IContent
    vector<Editor*> _editors = {}
    // Each space is a row of editors: side by side (HorizontalLayout), or
    // spiralling inwards (SpiralLayout) when _spiral is on
    vector<IContainer*> _editorspaces = {}
    Option<IContainer*> _activeSpace = None<IContainer*>()
    bool _spiral = false
    Option<Editor*> _activeEditor = None<Editor*>()
    vector<string> _shared_buffer = {}
    IContainer *_status_line
    CommandPallete _command_pallete = CommandPallete()
    EditorManager IContainer *status_line =>
        _status_line = status_line
        _origin = new VerticalLayout(Fill::Flex)
        // "layout": "spiral" in ~/.config/hide/settings.json starts in spiral layout
        let home = home_env().value_or(".")
        let settings = load_json($"{home}/.config/hide/{SETTINGS_FILE}")
        _spiral = settings.try_get_value_of("layout", (string)"horizontal") == "spiral"
        settings.destruct()
        add_space()
    ;
    fn new_space => IContainer*
        if _spiral doremi new SpiralLayout(Fill::Flex)
        return new HorizontalLayout(Fill::Flex)
    ;
    fn space_editors IContainer *space => vector<IContainer*>
        if _spiral doremi ((SpiralLayout*)space)->elements()
        return space->containers()->as_vec()
    ;
    fn space_add IContainer *space, IContainer *editor =>
        if _spiral do ((SpiralLayout*)space)->add_element(editor)
        else do space->add(editor)
    ;
    fn free_space IContainer *space =>
        if _spiral do ((SpiralLayout*)space)->destruct()
        delete(space)
    ;
    // Replaces all spaces with new ones of the current layout holding the given
    // editors (empty groups are dropped), keeping the active editor's space active
    fn rebuild_spaces vector<vector<IContainer*>> groups, bool spiral =>
        foreach space in _editorspaces do free_space(space)
        _spiral = spiral
        _editorspaces = {}
        _activeSpace = None<IContainer*>()
        _origin->clear()
        foreach group in groups
            if group.size() == 0 do continue
            let space = new_space()
            foreach editor in group
                space_add(space, editor)
                select active from _activeEditor
                    if active->origin() == editor do _activeSpace = Some(space)
                ;
            ;
            _editorspaces.push_back(space)
            _origin->add(space)
        ;
        if _activeSpace.is_none() && _editorspaces.size() > 0 do _activeSpace = Some(get_last(&_editorspaces))
    ;
    fn space_groups => vector<vector<IContainer*>>
        vector<vector<IContainer*>> groups = {}
        foreach space in _editorspaces do groups.push_back(space_editors(space))
        return groups
    ;
    fn activate Dir dir =>
        switch dir
        case Dir::Left dobr activate_h(dir)
        case Dir::Right dobr activate_h(dir)
        case Dir::Up dobr activate_v(dir)
        case Dir::Down dobr activate_v(dir)
        ;
    ;
    fn activate_v Dir dir =>
        let i = 0
        if _editors.size() < 2 do return
        if _editorspaces.size() < 2 do return
        select index from find_active_in_space()
        select active from _activeSpace
        foreach space in _editorspaces
            if space->Offset().eq(active->Offset())
                switch dir
                case Dir::Up
                    if i == 0 dobr i = _editorspaces.size() - 1
                    i--
                    break
                case Dir::Down
                    if i == _editorspaces.size() - 1 dobr i = 0
                    i++
                    break
                ;

                let active = _editorspaces.at(i)
                _activeSpace = Some(active)
                let editors = space_editors(active)
                if index >= editors.size()
                    index = editors.size() - 1
                ;
                
                let editor = editors.at(index)
                _activeEditor = find_editor_from_offset(editor->Offset())
                return
            ;
            i++
        ;;;
    ;
    fn activate_h Dir dir =>
        if _editors.size() < 2 do return
        select index from find_active_in_space()
        select space from _activeSpace
    
        let editors = space_editors(space)
        let size = editors.size()
        switch dir
        case Dir::Left
            if index == 0 dobr index = size - 1
            index--
            break
        case Dir::Right
            if index >= size - 1 dobr index = 0
            index++
            break
        ;
        let editor = editors.at(index)
        _activeEditor = find_editor_from_offset(editor->Offset())

        ;;
    ;
    fn find_editor_from_offset Vector offset => Option<Editor*>
        select space from _activeSpace
        foreach editor in _editors
            if editor->Offset().eq(offset) doremi Some(editor)
        ;;
        return None<Editor*>()
    ;
    fn find_active_in_space => Option<int>
        select active from _activeEditor doremi find_editor_in_space(active->path())
        return None<int>()
    ;    
    fn find_editor_in_space string path => Option<int>
        select editor from try_find_editor(path)
        select space from _activeSpace
        let editors = space_editors(space)
        foreach i, e in editors
            if e->Offset().eq(editor->Offset()) doremi Some(i)
        ;;;
        return None<int>()
    ;
pub
    fn open_file string path =>
        select editor from try_find_editor(path)
            _activeEditor = Some(editor)
        ;
        select a from _activeEditor do a->open(path)
    ;
    fn move_to int pos =>
        select a from _activeEditor do a->move_to(pos)
    ;
    fn write_editor => Command
        select a from _activeEditor do a->write_content()
        return Command::ModeNormal
    ;
    fn close_editor bool forced = false => Command
        if _editors.size() == 0 doremi Command::Exit
        _origin->clear()
        select a from _activeEditor
            if !a->has_changes() || forced
                a->close()
            ;
            else
                Ncurses::col(1)
                Ncurses::add(LINES-1, 0, "Buffer has changes please use q! if you really want to quit.")
                Ncurses::col(1,false)
                Ncurses::key()
                return Command::ModeCmdHan
            ;
        ;
        vector<vector<IContainer*>> groups = {}
        foreach group in space_groups()
            vector<IContainer*> buf = {}
            foreach editor in group
                if editor->Active() do buf.push_back(editor)
            ;
            groups.push_back(buf)
        ;
        rebuild_spaces(groups, _spiral)
        vector<Editor*> editors = {}
        foreach editor in _editors
            if editor->is_active() do editors.push_back(editor)
            else do delete editor
        ;
        _editors = editors
        if _editors.size() == 0 doremi Command::Exit
        _activeEditor = Some(get_last(&_editors))
        _activeSpace = Some(get_last(&_editorspaces))
        return Command::ModeNormal
    ;
    fn run Mode mode => Command
        let cmd = Command::Nop
        select a from _activeEditor do cmd = a->run(mode)
        switch cmd
        case Command::EditorLeft dobr activate(Dir::Left)
        case Command::EditorRight dobr activate(Dir::Right)
        case Command::EditorUp dobr activate(Dir::Up)
        case Command::EditorDown dobr activate(Dir::Down)
        ;
        return cmd
    ;
    fn set_syntax string syntax =>
        select a from _activeEditor
            a->set_syntax(syntax)
        ;
    ;
    fn draw =>
        foreach editor in _editors do editor->draw()
        select a from _activeEditor do a->draw(6)
    ;
    fn add_editor =>
        _editors.push_back(new Editor((string)"", &_shared_buffer, _status_line, &_command_pallete))
        select active from _activeSpace
            let editor = get_last(&_editors)
            _activeEditor = Some(editor)
            space_add(active, editor->origin())
        ;
    ;
    fn add_space =>
        _editorspaces.push_back(new_space())
        let space = get_last(&_editorspaces)
        _origin->add(space)
        _activeSpace = Some(space)
        add_editor()
    ;
    fn is_spiral => bool doremi _spiral
    // Switches every space between side by side and spiral layout
    fn set_spiral bool spiral =>
        if spiral == _spiral do return
        rebuild_spaces(space_groups(), spiral)
    ;
    fn toggle_spiral => do set_spiral(!_spiral)
    fn try_find_editor string path => Option<Editor*>
        for i until _editors.size()
            let p = _editors.at(i)->path()
            if p != path do continue
            return Some(_editors.at(i))
        ;
        return None<Editor*>()
    ;
    fn get_last<T> vector<T> *vec => T
        let count = vec->size()
        return get_at(vec, count - 1)
    ;
    fn get_at<T> vector<T> *vec, int at => T doremi vec->at(at)
    fn templates =>
        select a from _activeEditor do a->templates()
    ;
    fn search =>
        select a from _activeEditor do a->run_s()
    ;
    fn replace =>
        select a from _activeEditor do a->run_r()
    ;
;
