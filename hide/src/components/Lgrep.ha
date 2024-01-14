class LGREP
    static bool is_cached
    static bool is_content_search
    static int key
    static int pos
    static int offset
    static string search
    static vector<string> files
    static List<string> filtered_files
    static List<string> buffer
    static MainContainer main
    static HorizontalLayout base
    static IContainer header
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
        Ncurses::add(header.Offset().y,
            header.Offset().x + header.Size().x - count_info.size(),
            count_info)
    ;
    static fn mark_current_selected int pos =>
        Ncurses::mark_until(content.Offset().y + pos,
            content.Offset().x,
            5, content.Size().x)
    ;
    static fn reset const bool in_is_content_search = false =>
        is_content_search = in_is_content_search
        key = 0
        pos = 0
        offset = 0
        search = ""
        filtered_files.clear()
        header.SetLabel(is_content_search ? "Project Search" : "Live File Grep")
    ;
    static fn set_content =>
        let max = offset + view.Size().y
        buffer.clear()
        foreach i, file in filtered_files
            if i >= max do break
            if i >= offset do buffer.add(file)
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
        if is_content_search && search == "" do return
        let max_files = files.size()
        for i until max_files
            let file = files[i]
            if !is_content_search
                if search == "" doco filtered_files.add(file)
                if file.find(search) == -1 do continue
                filtered_files.add(file)
                continue
            ;
            select content from read(file)
                if content.find(search) == -1 do continue
                filtered_files.add(file)
            ;
        ;
    ;
    static fn lgrep_while const vector<string>* dirs, const int current, vector<string>* fs, const string start_dir, int depth =>
        let dir = dirs->at(current-1)
        if dir =|= "." : ".." : ".git" : ".cargo" : ".android" : ".cache" : ".config" : ".electron_build_tools" : ".java" : ".npm" : ".gradle" : ".icons" : ".local" : ".steam" : ".mozilla" : ".prefix" : ".var" : ".vscode" : ".wine" : ".vpython-root" : "Android" : ".godot" : ".nv" : "PackageCache" : "android-studio" : "OpenRGB" : "node_modules" : ".dotnet" : ".rustup" : "CachedNodeOutput" do return
        if String(dir).ends_with("/.") do return
        if String(dir).ends_with("/..") do return
        if String(start_dir).contains("Code/User") do return
        if String(start_dir).contains("Code/CachedData") do return
        if String(start_dir).contains("Code/Work") do return
        if String(start_dir).contains("Code/Service") do return
        if String(start_dir).contains("Library/Artifacts") do return
        if String(start_dir).contains("Library/ScriptAssemblies") do return
        let new_files = lgrep($"{start_dir}/{dir}", depth + 1)
        foreach f in new_files
            let f_str = String(f)
            if !LGREP::is_valid_suffix(f_str) do continue
            if LGREP::is_binary($"{start_dir}/{dir}/{f}") do continue
            fs->push_back($"{dir}/{f}")
        ;
    ;
    static fn is_valid_suffix String file_name => bool
        if file_name.ends_with(".bin") doremi false
        if file_name.ends_with(".import") doremi false
        if file_name.ends_with(".ttf") doremi false
        if file_name.ends_with(".ogg") doremi false
        if file_name.ends_with(".tscn") doremi false
        if file_name.ends_with(".otf") doremi false
        if file_name.ends_with(".gem") doremi false
        if file_name.ends_with(".uuid") doremi false
        if file_name.ends_with(".db") doremi false
        if file_name.ends_with(".uasset") doremi false
        if file_name.ends_with(".crate") doremi false
        if file_name.ends_with(".tdb") doremi false
        if file_name.ends_with(".dat") doremi false
        if file_name.ends_with(".pt") doremi false
        if file_name.ends_with(".png") doremi false
        if file_name.ends_with(".mp4") doremi false
        if file_name.ends_with(".mp3") doremi false
        if file_name.ends_with(".wav") doremi false
        if file_name.ends_with(".jar") doremi false
        if file_name.ends_with(".pyc") doremi false
        if file_name.ends_with(".rmeta") doremi false
        if file_name.ends_with(".rlib") doremi false
        if file_name.ends_with(".jpg") doremi false
        if file_name.ends_with(".jpeg") doremi false
        if file_name.ends_with(".webm") doremi false
        if file_name.ends_with(".webp") doremi false
        if file_name.ends_with(".gif") doremi false
        if file_name.ends_with(".avi") doremi false
        if file_name.ends_with(".bmp") doremi false
        if file_name.ends_with(".qmic") doremi false
        if file_name.ends_with(".pdf") doremi false
        if file_name.ends_with(".svg") doremi false
        if file_name.ends_with(".d") doremi false
        if file_name.ends_with(".lock") doremi false
        if file_name.ends_with(".zip") doremi false
        if file_name.ends_with(".7z") doremi false
        if file_name.ends_with(".msi") doremi false
        if file_name.ends_with(".exe") doremi false
        if file_name.ends_with(".cargo-ok") doremi false
        if file_name.ends_with(".dll") doremi false
        if file_name.ends_with(".dist-info") doremi false
        if file_name.ends_with(".shada") doremi false
        if file_name.ends_with(".tar") doremi false
        if file_name.ends_with(".vdf") doremi false
        if file_name.ends_with(".vdi") doremi false
        if file_name.ends_with(".iso") doremi false
        if file_name.ends_with(".ii") doremi false
        if file_name.ends_with(".qmlc") doremi false
        if file_name.ends_with(".storageRecordIndex") doremi false
        return true
    ;
    static fn is_binary string file_path => bool
        string linebuf
        ifstream reader(file_path)
        if !reader doremi true
        getline(reader, linebuf)
        if linebuf.size() <= 1 doremi false
        if linebuf[0] < 10 doremi true
        if linebuf[0] == '\177' doremi true
        if linebuf[0] == '\37' doremi true
        if linebuf.size() < 3 doremi false
        if linebuf[0] == 'x' && linebuf[1] < 10 doremi true
        if linebuf[0] == '0' && linebuf[1] == '\r' doremi true
        if linebuf[0] == '0' && linebuf[1] == '\\' doremi true
        if linebuf[0] == 'P' && linebuf[1] == 'K' && linebuf[2] < 10 doremi true
        return false
    ;
    static fn lgrep_internal int depth, string start_dir =>
        let fs = list_reg_files(start_dir)
        foreach f in fs
            if !LGREP::is_valid_suffix(f) do continue
            if LGREP::is_binary(f) do continue
            files.push_back(f)
        ;
        if depth >= 5 do return
        let dirs = list_dirs(start_dir)
        let current = 0
        while (current++) < dirs.size() do LGREP::lgrep_while(&dirs, current, &files, start_dir, depth)
    ;
    static fn align_cursor =>
        if buffer.size() == 0
            pos = 0
            offset = 0
            return
        ;
        let height = content.Size().y - 1
        let max_offset = filtered_files.size() - height - 1
        let delta_pos = pos >= height ? pos - height : pos
        if pos > height
            offset += delta_pos
            pos = height
        ;
        if pos < 0
            offset += delta_pos
            pos = 0
        ;
        if offset < 0 do offset = 0
        if offset > max_offset do offset = max_offset
        if pos > buffer.size() - 1 do pos = buffer.size() - 1
    ;
    static fn exit => Option<string>
        Ncurses::start(false)
        return Option<string>(" ")
    ;
    static fn backspace =>
        if search.size() == 0 do return
        search.pop_back()
        LGREP::get_files()
    ;
    static fn add_search =>
        if key == ' ' do search += key
        if !isgraph(key) do return
        search += key
        LGREP::get_files()
    ;
    static fn handle_key => Option<string>
        key = Ncurses::key()
        switch key
        case 27 doremi LGREP::exit()
        case KEY_DOWN dobr pos++
        case KEY_UP dobr pos--
        case KEY_PPAGE dobr pos-=content.Size().y-1
        case KEY_NPAGE dobr pos+=content.Size().y-1
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
        return None<string>()
    ;
pub
    static fn init bool load_on_init = false =>
        if load_on_init
            is_cached = true
            let _ = async(launch::async, LGREP::lgrep_internal, 0, ".")
        ;
        LGREP::reset()
        main = MainContainer(Vector(COLS/10, LINES/8))
        base = HorizontalLayout(Fill::Flex)
        header = IContainer(Fill::Static, Vector(0,1))
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
        left.add(&header)
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

    static fn Lgrep bool in_is_content_search = false => Option<string>
        if !is_cached
            is_cached = true
            let _ = async(launch::async, LGREP::lgrep_internal, 0, ".")
        ;
        LGREP::reset(in_is_content_search)
        LGREP::get_files()
        LGREP::set_content()
        LGREP::add_count_info($"{filtered_files.len()}/{files.size()}")
        LGREP::mark_current_selected(pos)
        loop
            search_bar.SetLabel(search)
            LGREP::set_content()
            LGREP::add_count_info($"{filtered_files.len()}/{files.size()}")
            LGREP::mark_current_selected(pos)
            select fp from LGREP::handle_key()
                if fp == " " doremi None<string>()
                return fp
            ;
        ;
    ;
;
