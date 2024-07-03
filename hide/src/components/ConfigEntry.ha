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
        if current < _selectables.size()
            _selectables[current]->set_label("Add Word")
        ;
        else
            _selectables.push_back(new Selectable("Add Word"))
        ;
        _selectables[current]->set_outline(true)
        _selectables[current]->add_func(bind(ConfigUpdater::add_word, syntax.file_type()))
        current++
        foreach word in _syntax.wordlist()
            if current < _selectables.size()
                _selectables[current]->set_label(word)
            ;
            else
                _selectables.push_back(new Selectable(word))
            ;
            _selectables[current]->set_outline(false)
            _selectables[current]->add_func(bind(ConfigUpdater::edit_word, word, syntax.file_type()))
            current++
        ;
        foreach rule in _syntax.rules()
            let value = $"{rule.type} | {rule.value} | {rule.validation_type} | {rule.validation_value}"
            if current < _selectables.size()
                _selectables[current]->set_label(value)
            ;
            else
                _selectables.push_back(new Selectable(value))
            ;
            _selectables[current]->set_outline(true)
            current++
        ;
        foreach custom in _syntax.custom()
            let value = $"Rule: {custom.regex_str} | Color: {custom.color} | Capture: {custom.capture} | Bold: {custom.bold} | Dim: {custom.dim}"
            if current < _selectables.size()
                _selectables[current]->set_label(value)
            ;
            else
                _selectables.push_back(new Selectable(value))
            ;
            _selectables[current]->set_outline(true)
            current++
        ;
        foreach t_origin in _syntax.templates()
            let value = $"Name: {t_origin.template_name} | Template: "
            foreach t in t_origin.templates
                value += t
            ;
            if current < _selectables.size()
                _selectables[current]->set_label(value)
            ;
            else
                _selectables.push_back(new Selectable(value))
            ;
            _selectables[current]->set_outline(true)
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
