private fn delete_line Vector *pos, bool is_multi = false =>
    if !is_multi do _shared_buffer->clear()
    _shared_buffer->push_back(_text.at(pos->y))
    remove_line(&_text, pos)
;

private fn delete_from Vector *pos =>
    let s = _text.at(pos->y)
    _shared_buffer->clear()
    _shared_buffer->push_back(_text.at(pos->y).substr(pos->x))
    remove_until(&_text, pos)
;

private fn delete_word Vector *pos, bool spacebreak = false =>
    remove_word(&_text, pos, spacebreak)
;

private fn run_d => Command
    let edit_cmd = Option<TextEdit>()
    switch Ncurses::key()
    case 'd' dobr edit_cmd = Some(TextEdit::DeleteLine)
    case 'w' dobr edit_cmd = Some(TextEdit::DeleteWord)
    case 'e' dobr edit_cmd = Some(TextEdit::DeleteWordExlusive)
    ;
    select edit from edit_cmd
        select num from _modifier.to_num()
            if num == 0 do text_editing(edit)
            for i until num
                text_editing(edit, i != 0)
            ;
            _modifier = String("")
            return Command::Nop
        ;
        text_editing(edit)
    ;
    return Command::Nop
;