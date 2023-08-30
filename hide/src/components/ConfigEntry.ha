class ConfigEntry => IContent
    int _current_selected = 0
    Syntax _syntax
    vector<Selectable*> _selectables = {}
    ConfigEntry =>
        _origin = new IContainer()
    ;
pub
    fn SetEntry Syntax syntax =>
        _syntax = syntax
        _current_selected = 0
        int current = 0
        foreach word in _syntax.wordlist()
            if current < _selectables.size()
                _selectables[current]->set_label(word)
            ;
            else
                _selectables.push_back(new Selectable(word))
            ;
            current++
        ;
        foreach rule in _syntax.rules()
            let value = $"{rule.type} {rule.value} {rule.validation_type} {rule.validation_value}"
            if current < _selectables.size()
                _selectables[current]->set_label(value)
            ;
            else
                _selectables.push_back(new Selectable(value))
            ;
            current++
        ;
        foreach custom in _syntax.custom()
            let value = $"Color: {custom.color} Capture: {custom.capture} Bold: {custom.bold} Dim: {custom.dim}"
            if current < _selectables.size()
                _selectables[current]->set_label(value)
            ;
            else
                _selectables.push_back(new Selectable(value))
            ;
            current++
        ;
        foreach t_origin in _syntax.templates()
            let value = $"Name: {t_origin.template_name} Template: "
            foreach t in t_origin.templates
                value += t
            ;
            if current < _selectables.size()
                _selectables[current]->set_label(value)
            ;
            else
                _selectables.push_back(new Selectable(value))
            ;
            current++
        ;
    ;
    fn run => bool
        let size = _origin->Size()
        let offset = _origin->Offset()
        foreach i, selectable in _selectables
            if _current_selected > i do continue
            if 3 * (i - _current_selected) >= size.y - 2 do continue
            selectable->set_offset(offset.x, offset.y + (3 * (i - _current_selected)))
            selectable->set_width(size.x)
            selectable->toggle_selection(i == _current_selected)
            selectable->draw()
        ;
        switch Ncurses::key()
        case KEY_UP dobr _current_selected = clamp(_current_selected - 1, 0, _selectables.size() - 1)
        case KEY_DOWN dobr _current_selected = clamp(_current_selected + 1, 0, _selectables.size() - 1)
        case 27 doremi false
        ;
        return true
    ;
;
