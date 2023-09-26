fn lgrep => vector<string> doremi lgrep(".", 0)
fn lgrep string start_dir, int depth => vector<string>
    let files = list_reg_files(start_dir)
    if depth >= 5 doremi files
    let dirs = list_dirs(start_dir)
    let current = 0
    while (current++) < dirs.size()
        let dir = dirs.at(current-1)
        if dir =|= ".": ".." do continue
        if String(dir).ends_with("/.") do continue
        if String(dir).ends_with("/..") do continue
        let new_files = lgrep($"{start_dir}/{dir}", depth + 1)
        foreach f in new_files do files.push_back($"{dir}/{f}")
    ;
    return files
;

fn lgrep_p vector<string> *files, int depth, string start_dir =>
    let fs = list_reg_files(start_dir)
    foreach f in fs do files->push_back(f)
    if depth >= 5 do return
    let dirs = list_dirs(start_dir)
    let current = 0
    while (current++) < dirs.size()
        let dir = dirs.at(current-1)
        if dir =|= ".": ".." do continue
        if String(dir).ends_with("/.") do continue
        if String(dir).ends_with("/..") do continue
        let new_files = lgrep($"{start_dir}/{dir}", depth + 1)
        foreach f in new_files do files->push_back($"{dir}/{f}")
    ;
;

fn get_files vector<string> files, string search => List<string>
    List<string> filtered_files = List<string>()
    foreach file in files
        if search == "" doco filtered_files.add(file)
        if file.find(search) == -1 do continue
        filtered_files.add(file)
    ;
    return filtered_files
;

fn Lgrep => Option<string>
    let key = 0
    let pos = 0
    let search = ""
    vector<string> files = {}
    let a = async(launch::async, lgrep_p, &files, 0, ".")
    Ncurses::start(true)
    let main = MainContainer(Vector(COLS/10, LINES/8))
    let base = HorizontalLayout(Fill::Flex)
    let search_bar = IContainer(Fill::Static, Vector(0,1))
    let content = IContainer()
    let left = VerticalLayout(Fill::Flex)
    let spacer = IContainer(Fill::Static, Vector(2,0), "│")
    let left_spacer = IContainer(Fill::Static, Vector(1,0))
    let search_spacer = IContainer(Fill::Static, Vector(0,1), "─")
    let view = IContainer()
    main.add(&base)
    base.SetColor(-2)
    spacer.SetColor(2)
    base.add(&left_spacer)
    base.add(&left)
    base.add(&spacer)
    base.add(&view)
    left.add(&search_bar)
    left.add(&search_spacer)
    left.add(&content)
    let offset = 0
    let filtered_files = get_files(files, search)
    loop
        search_bar.SetLabel(search)
        let i = 0
        let max = offset + view.Size().y
        let buf = List<string>()
        foreach file in filtered_files
            if i >= max do break
            if i >= offset do buf.add(file)
            i++
        ;
        content.SetContent(buf)
        if pos >= buf.size()
            view.SetContent(List<string>())
            main.draw()
        ;
        else
            let lines = linq::take(readlines(buf.at(pos)))
                .operate([&view](string line){return line.substr(0, view.Size().x);}).as_list()
            view.SetContent(lines)
            let h = Highlighter(buf.at(pos))
            main.draw()
            h.highlight(&view)
        ;
        let count_info = $"{filtered_files.len()}/{files.size()}"
        Ncurses::add(search_bar.Offset().y,
            search_bar.Offset().x + search_bar.Size().x - count_info.size(),
            count_info)
        Ncurses::mark_until(content.Offset().y + pos,
            content.Offset().x,
            5, content.Size().x)
        key = Ncurses::key()
        switch key
        case 27
            Ncurses::start(false)
            return None<string>()
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
            filtered_files = get_files(files, search)
            break
        default
            if isgraph(key)
                search += key
                filtered_files = get_files(files, search)
            ;
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
