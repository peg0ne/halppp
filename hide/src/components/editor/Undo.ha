private fn content_change TextEdit edit => 
    let j = load_json(json_path())
    Json *entry = new Json()
    entry->try_add("text", _text.at(_selector.y))
    entry->try_add("type", (int)edit)
    entry->try_add("posy", _selector.y)
    entry->try_add("posx", _selector.x)
    j.try_add("undo", JsonType::Array)
    j.try_add("redo", JsonType::Array)
    select undo from j["undo"]
        undo->add(entry)
        sort_selections()
        foreach selection in _selections
            Json *sel_entry = new Json()
            sel_entry->try_add("text", _text.at(selection.y))
            sel_entry->try_add("type", (int)edit)
            sel_entry->try_add("posy", selection.y)
            sel_entry->try_add("posx", selection.x)
            undo->add(sel_entry)
        ;
    ;
    write_json(json_path(), j)
    j.destruct()
;

private fn redo => do undo(false)
private fn undo bool is_undo = true =>
    let getter = is_undo ? "undo" : "redo"
    let setter = is_undo ? "redo" : "undo"
    let j = load_json(json_path())
    let entry = new Json()
    select obj from j[getter]
        let last = obj->size() - 1
        select u from obj->try_get(last)
            let text = u->try_get_value_of("text", (string)"")
            let type = u->try_get_value_of("type", 0.0)
            let posy = u->try_get_value_of("posy", 0.0)
            let posx = u->try_get_value_of("posx", 0.0)
            select store from j[setter]
                entry->add(new Json("text", text))
                entry->add(new Json("type", type))
                entry->add(new Json("posy", posy))
                entry->add(new Json("posx", posx))
                store->add(entry)
                undo_handler(text, (TextEdit)type, Vector(posx, posy), is_undo)
            ;
            obj->pop()
            write_json(json_path(), j)
            entry->destruct()
            delete(entry)
        ;
    ;
;

private fn undo_handler string text, TextEdit type, Vector pos, bool is_undo =>
    _selector = pos
    switch type
    case TextEdit::PasteLine
        if !is_undo dobr _text.insert(pos.y+1, text)
        _text.remove(pos.y+1)
        break
    case TextEdit::DeleteLine
        if is_undo dobr _text.insert(pos.y, text)
        _text.remove(pos.y)
        break
    case TextEdit::InsertNl
        if is_undo
            _text.set(pos.y, text)
            _text.remove(pos.y + 1)
        ;
        else do insert_nl(&_selector, 0)
        break
    default dobr _text.set(pos.y, text)
    ;
;