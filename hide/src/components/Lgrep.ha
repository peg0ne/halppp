fn lgrep => vector<string>
    let files = list_reg_files(".")
    let dirs = list_dirs(".")
    let current = 0
    while (current++) < dirs.size()
        let dir = dirs.at(current-1)
        if dir =|= ".": ".." do continue
        if String(dir).ends_with("/.") do continue
        if String(dir).ends_with("/..") do continue
        let new_files = list_reg_files(dir)
        let new_dirs = list_dirs(dir)
        foreach f in new_files do files.push_back($"{dir}/{f}")
        foreach d in new_dirs do dirs.push_back($"{dir}/{d}")
    ;
    return files
;

fn Lgrep Ncurses* n => Option<string>
    let key = 0
    let pos = 0
    let search = ""
    let files = List<string>(lgrep())
    let base = HorizontalLayout(Vector(COLS/10*8, LINES/8*6), Vector(COLS/10, LINES/8))
    let search_bar = IContainer(Fill::Static, Vector(0,1))
    let content = IContainer()
    let left = VerticalLayout(Fill::Flex)
    let spacer = IContainer(Fill::Static, Vector(2,0), "│")
    let left_spacer = IContainer(Fill::Static, Vector(1,0))
    let view = IContainer()
    base.SetColor(-2)
    spacer.SetColor(2)
    base.add(&left_spacer)
    base.add(&left)
    base.add(&spacer)
    base.add(&view)
    left.add(&search_bar)
    left.add(&content)
    let offset = 0
    loop
        search_bar.SetLabel(search)
        let buf = linq::take(files)
            .where([search](string file){return file.find(search) != -1;})
            .where_with_iterator([offset](string file, int i){return i >= offset;})
            .as_list()
        content.SetContent(buf)
        if pos >= buf.size()
            view.SetContent(List<string>())
            base.draw(n)
        ;
        else
            view.SetContent(readlines(buf.at(pos)))
            let h = Highlighter(buf.at(pos))
            base.draw(n)
            h.highlight(&view, n)
        ;
        n->mark_until(content.Offset().y + pos,
            content.Offset().x,
            5, content.Size().x)
        key = n->key()
        switch key
        case 27 doremi None<string>()
        case KEY_DOWN dobr pos++
        case KEY_UP dobr pos--
        case KEY_PPAGE dobr pos-=1000
        case KEY_NPAGE dobr pos+=1000
        case '\n'
            if pos >= buf.size() do break
            return buf.at(pos)
        case '\b'
        case 127
        case KEY_BACKSPACE
            if search.size() == 0 do break
            search.pop_back()
            break
        default
            if isgraph(key) do search += key
            break
        ;
        if pos > buf.size() - 1 do pos = buf.size() - 1
        if pos > content.Size().y - 1
            pos = content.Size().y - 1
            offset++
        ;
        if pos < 0
            pos = 0
            if offset > 0 do offset--
        ;
    ;
;