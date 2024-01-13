class LGREP
    static int key
    static int pos
    static int offset
    static string search
    static vector<string> files
    static List<string> filtered_files
    static List<string> buffer
    static MainContainer main
    static HorizontalLayout base
    static IContainer search_bar
    static IContainer content
    static VerticalLayout left
    static IContainer spacer
    static IContainer left_spacer
    static IContainer search_spacer
    static IContainer view
    static Highlighter h
    static fn crop_line string line => string doremi line.substr(0, view.Size().x)
    static fn add_count_info string count_info =>
        Ncurses::add(search_bar.Offset().y,
            search_bar.Offset().x + search_bar.Size().x - count_info.size(),
            count_info)
    ;
    static fn mark_current_selected int pos =>
        Ncurses::mark_until(content.Offset().y + pos,
            content.Offset().x,
            5, content.Size().x)
    ;
    static fn reset =>
        key = 0
        pos = 0
        offset = 0
        search = ""
        files.clear()
        filtered_files.clear()
    ;
    static fn set_content =>
        let i = 0
        let max = offset + view.Size().y
        buffer.clear()
        foreach file in filtered_files
            if i >= max do break
            if i >= offset do buffer.add(file)
            i++
        ;
        content.SetContent(buffer)
        if pos >= buffer.size()
            view.SetContent(List<string>())
            main.draw()
        ;
        else
            let lines = linq::take(readlines(buffer.at(pos)))
                .operate(LGREP::crop_line).as_list()
            view.SetContent(lines)
            h.new_syntax(buffer.at(pos))
            main.draw()
            h.highlight(&view)
        ;
    ;
    static fn get_files =>
        filtered_files.clear()
        let max_files = files.size()
        for i until max_files
            let file = files[i]
            if search == "" doco filtered_files.add(file)
            if file.find(search) == -1 do continue
            filtered_files.add(file)
        ;
    ;
    static fn lgrep_while const vector<string>* dirs, const int current, vector<string>* fs, const string start_dir, int depth =>
        let dir = dirs->at(current-1)
        if dir =|= "." : ".." do return
        if String(dir).ends_with("/.") do return
        if String(dir).ends_with("/..") do return
        let new_files = lgrep($"{start_dir}/{dir}", depth + 1)
        foreach f in new_files do fs->push_back($"{dir}/{f}")
    ;
    static fn lgrep_internal int depth, string start_dir =>
        let fs = list_reg_files(start_dir)
        foreach f in fs do files.push_back(f)
        if depth >= 5 do return
        let dirs = list_dirs(start_dir)
        let current = 0
        while (current++) < dirs.size() do LGREP::lgrep_while(&dirs, current, &files, start_dir, depth)
    ;
    static fn align_cursor =>
        if pos > buffer.size() - 1 do pos = buffer.size() - 1
        if pos > content.Size().y - 1
            pos = content.Size().y - 1
            offset++
        ;
        if pos < 0
            pos = 0
            if offset > 0 do offset--
        ;
    ;
    static fn exit => Option<string>
        Ncurses::start(false)
        return None<string>()
    ;
    static fn backspace =>
        if search.size() == 0 do return
        search.pop_back()
        LGREP::get_files()
    ;
    static fn add_search =>
        if !isgraph(key) do return
        search += key
        LGREP::get_files()
    ;
pub
    static fn init =>
        LGREP::reset()
        main = MainContainer(Vector(COLS/10, LINES/8))
        base = HorizontalLayout(Fill::Flex)
        search_bar = IContainer(Fill::Static, Vector(0,1))
        content = IContainer()
        left = VerticalLayout(Fill::Flex)
        spacer = IContainer(Fill::Static, Vector(2,0), "│")
        left_spacer = IContainer(Fill::Static, Vector(1,0))
        search_spacer = IContainer(Fill::Static, Vector(0,1), "─")
        view = IContainer()
        h = Highlighter("a.ha")
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
    ;
    static fn lgrep => vector<string> doremi lgrep(".", 0)
    static fn lgrep string start_dir, int depth => vector<string>
        let fs = list_reg_files(start_dir)
        if depth >= 5 doremi fs
        let dirs = list_dirs(start_dir)
        let current = 0
        while (current++) < dirs.size() do LGREP::lgrep_while(&dirs, current, &fs, start_dir, depth)
        return fs
    ;

    static fn Lgrep => Option<string>
        LGREP::reset()
        let async_tasks = async(launch::async, LGREP::lgrep_internal, 0, ".")
        Ncurses::start(true)
        loop
            if async_tasks.valid() && async_tasks.wait_for(0.1s) != future_status::ready
                LGREP::get_files()
            ;
            elif async_tasks.valid()
                async_tasks.wait_for(0.1s)
                async_tasks.get()
                LGREP::get_files()
            ;
            else do Ncurses::start(false)
            search_bar.SetLabel(search)
            LGREP::set_content()
            LGREP::add_count_info($"{filtered_files.len()}/{files.size()}")
            LGREP::mark_current_selected(pos)
            key = Ncurses::key()
            switch key
            case 27 doremi LGREP::exit()
            case KEY_DOWN dobr pos++
            case KEY_UP dobr pos--
            case KEY_PPAGE dobr pos-=1000
            case KEY_NPAGE dobr pos+=1000
            case '\n'
                if pos >= buffer.size() do break
                Ncurses::start(false)
                return buffer.at(pos)
            case '\b'
            case 127
            case KEY_BACKSPACE dobr LGREP::backspace()
            default dobr LGREP::add_search()
            ;
            LGREP::align_cursor()
        ;
    ;
;
