get => components/Editor
class EditorManager => IContent
    vector<Editor*> _editors = {}
    vector<HorizontalLayout*> _editorspaces = {} 
    Option<HorizontalLayout*> _activeSpace = None<HorizontalLayout*>()
    Option<Editor*> _activeEditor = None<Editor*>()
    EditorManager Ncurses *n =>
        this->n = n
        _origin = new VerticalLayout(Fill::Flex)
        add_space()
    ;
pub
    fn open_file string path =>
        select editor from try_find_editor(path)
            _activeEditor = Some(editor)
        ;
        select a from _activeEditor do a->open(path)
    ;
    fn write_editor => Command
        select a from _activeEditor do a->write_content()
        return Command::ModeNormal
    ;
    fn close_editor => Command
        if _editors.size() == 1 doremi Command::Exit
        _origin->clear()
        select a from _activeEditor do a->set_active(false)
        vector<HorizontalLayout*> spaces = {}
        foreach space in _editorspaces
            let containers = space->containers()
            vector<IContainer*> buf = {}
            for i until containers->size()
                let editor = containers->at(i)
                if !editor->Active() do continue
                else do buf.push_back(editor)
            ;
            space->clear()
            if buf.size() == 0 do continue
            foreach editor in buf do space->add(editor)
            spaces.push_back(space)
        ;
        _editorspaces = spaces
        _origin->clear()
        foreach space in _editorspaces do _origin->add(space)
        vector<Editor*> editors = {}
        foreach editor in _editors
            if editor->is_active() do editors.push_back(editor)
            else do delete editor
        ;
        _editors = editors
        _activeEditor = Some(get_last(&_editors))
        _activeSpace = Some(get_last(&_editorspaces))
        return _editors.size() == 0 ? Command::Exit : Command::ModeNormal
    ;
    fn run Mode mode => Command
        select a from _activeEditor doremi a->run(mode)
        return Command::Nop
    ;
    fn draw =>
        foreach editor in _editors do editor->draw()
        select a from _activeEditor do a->draw(6)
    ;
    fn add_editor =>
        _editors.push_back(new Editor(n, (string)""))
        select active from _activeSpace
            let editor = get_last(&_editors)
            _activeEditor = Some(editor)
            active->add(editor->origin())
        ;
    ;
    fn add_space =>
        _editorspaces.push_back(new HorizontalLayout(Fill::Flex))
        let space = get_last(&_editorspaces)
        _origin->add(space)
        _activeSpace = Some(space)
        add_editor()
    ;
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
;