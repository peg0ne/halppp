pub fn templates =>
    select h from _highlighter
        _selections.clear()
        let templates = h->syntax().templates()
        let container = HorizontalLayout(Vector(COLS/6*4, LINES/2), Vector(COLS/6, LINES/4))
        let content = List<string>()
        foreach t in templates do content.add(t.template_name)
        container.SetColor(-2)
        container.SetContent(content)
        if templates.size() == 0 do return
        let template_index = 0
        loop
            container.draw()
            Ncurses::mark_until(
                container.Offset() + Vector(0, template_index),
                4, container.Size().x, true)
            let key = Ncurses::key()
            if key == '\n' do break
            if key == 27 do return
            switch key
            case KEY_UP dobr template_index--
            case KEY_DOWN dobr template_index++
            ;
            if template_index < 0 do template_index = 0
            if template_index >= templates.size() do template_index = templates.size() - 1
        ;
        let temp = templates[template_index]
        _modifier = String("")
        _current_mode = Mode::Insert
        draw(6)
        foreach t in temp.templates
            let s = String(t)
            if s.starts_with("%")
                text_editing(TextEdit::InsertNl)
                draw(6)
                continue
            ;
            while s.starts_with("$")
                loop
                    let key = Ncurses::key()
                    if key == 127 do break
                    elif key =|= '\n' : ' ' dobr draw(6)
                    elif key == KEY_BACKSPACE
                        text_editing(TextEdit::RemoveChar)
                        draw(6)
                    ;
                    elif isgraph(key)
                        text_editing(TextEdit::Insert, string(1, key))
                        draw(6)
                    ;
                ;
                s.remove(0)
                if s.len() == 0 do break
                while !s.starts_with("$")
                    content_change(TextEdit::Insert)
                    insert_text(string(1, s.at(0)), &_selector, false)
                    draw(6)
                    s.remove(0)
                    if s.len() == 0 do break
                ;
                if s.len() == 0 do break
            ;
            content_change(TextEdit::Insert)
            foreach ch in s.to_string() do insert_text(string(1, ch), &_selector, false)
            draw(6)
        ;
        _current_mode = Mode::Normal
    ;
;