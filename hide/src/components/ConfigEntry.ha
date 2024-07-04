get => ConfigUpdater

class ConfigEntry => IContent
    int _current_selected = 0
    Syntax _syntax
    vector<Selectable*> _selectables = {}
    bool _reload = false
    ConfigEntry =>
        _origin = new IContainer()
    ;
    fn reload =>
        let home = home_env().value_or(".")
        let path = $"{home}/.config/hide/{_syntax.file_type()}.json"
        let config = load_json(path)
        let syntax = Syntax(config)
        syntax.set_file_type(_syntax.file_type())
        SetEntry(syntax)
        config.destruct()
        _reload = true
    ;
    fn get_selectable int pos, string label => Selectable*
        if pos >= _selectables.size() do _selectables.push_back(new Selectable(label))
        let selectable = _selectables[pos]
        selectable->set_label(label)
        selectable->set_outline(true)
        selectable->clear_func()
        return selectable
    ;
pub
    fn get_reload => bool
        let reload = _reload
        _reload = false
        return reload
    ;
    fn SetEntry Syntax syntax =>
        _syntax = syntax
        _current_selected = 0
        int current = 0

        let add_word = get_selectable(current, "Add Word")
        add_word->add_func(bind(ConfigUpdater::add_word, syntax.file_type()))
        current++

        foreach word in _syntax.wordlist()
            let edit_word = get_selectable(current, word)
            edit_word->set_outline(false)
            edit_word->add_func(bind(ConfigUpdater::edit_word, word, syntax.file_type()))
            current++
        ;
        foreach rule in _syntax.rules()
            let value = $"{rule.type} | {rule.value} | {rule.validation_type} | {rule.validation_value}"
            let edit_rule = get_selectable(current, value)
            current++
        ;
        foreach i,custom in _syntax.custom()
            let value = $"Rule: {custom.regex_str} | Color: {custom.color} | Capture: {custom.capture} | Bold: {custom.bold} | Dim: {custom.dim}"
            let edit_custom = get_selectable(current, value)
            edit_custom->add_func(bind(ConfigUpdater::edit_custom, custom, i, syntax.file_type()))
            current++
        ;
        foreach t_origin in _syntax.templates()
            let value = $"Name: {t_origin.template_name} | Template: "
            foreach t in t_origin.templates do value += t
            let edit_template = get_selectable(current, value)
            current++
        ;
    ;
    fn run => bool
        let size = _origin->Size()
        let offset = _origin->Offset()
        let currentDrawPos = -_current_selected
        foreach i, selectable in _selectables
            let padding = selectable->has_outline() ? 3 : 1
            currentDrawPos += _current_selected > i ? 1 : padding
            if _current_selected > i do continue
            if currentDrawPos > size.y do break
            selectable->set_offset(offset.x, offset.y + currentDrawPos - padding)
            selectable->set_width(size.x)
            selectable->toggle_selection(i == _current_selected)
            selectable->draw()
        ;
        switch Ncurses::key()
        case KEY_UP dobr _current_selected = clamp(_current_selected - 1, 0, _selectables.size() - 1)
        case KEY_DOWN dobr _current_selected = clamp(_current_selected + 1, 0, _selectables.size() - 1)
        case 27 doremi false
        case '\n'
            _selectables[_current_selected]->execute()
            reload()
            break
        ;
        return true
    ;
;
