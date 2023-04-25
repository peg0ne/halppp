private fn paste_line Vector *pos =>
    if _shared_buffer->size() == 0
        let clipboard = system_output("xclip -o -selection clipboard 2> /dev/null")
        for i until clipboard.size()
            if i != 0 do content_change(TextEdit::PasteLine)
            insert_line(&_text, ++pos->y, String(clipboard.at(i)).strip_end())
        ;
        return
    ;
    for i until _shared_buffer->size()
        if i != 0 do content_change(TextEdit::PasteLine)
        insert_line(&_text, ++pos->y, _shared_buffer->at(i))
    ;
;

private fn paste_word Vector *pos =>
    if _shared_buffer->size() == 0
        let clipboard = system_output("xclip -o -selection clipboard 2> /dev/null")
        if clipboard.size() == 0 do return
        if pos->x != 0 do pos->x++
        insert_snippet(&_text, pos, String(clipboard.at(0)).strip_end())
        return
    ;
    if pos->x != 0 do pos->x++
    insert_snippet(&_text, pos, _shared_buffer->at(0))
;

private fn paste_from_clip =>
    _shared_buffer->clear()
    text_editing(TextEdit::PasteLine)
;