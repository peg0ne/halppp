named => LSP
    struct LSPFileAndText
        string file_name
        Option<string> text
        LSPFileAndText => do return
        LSPFileAndText string file_name, Option<string> text =>
            this->file_name = file_name
            this->text = text
        ;
    ;
    struct LSPFoundTarget
        string file_name
        int found_at_line
        LSPFoundTarget => do return
        LSPFoundTarget string file_name, int found_at_line =>
            this->file_name = file_name
            this->found_at_line = found_at_line
        ;
    ;
    fn show_definition string word, string lang => Option<LSPFoundTarget>
        let func_start = $"fn {word} "
        let project_files = LGREP::lgrep()
        select home from home_env()
            let dir = $"{home}/.local/lib"
            let unhandled_files = LGREP::lgrep(dir, 0)
            let lib_files = map<string>(unhandled_files).select(x => $"{dir}/{x}")
            project_files = linq::take(project_files).join(lib_files).as_vec()
        ;
        let files = map<LSPFileAndText>(project_files)
            .where(x => String(x).ends_with($".{lang}"))
            .select(x => LSPFileAndText(x, read(x)))
            .where(x => x.text.is_some())
            .where(x => String(x.text.value_or("")).contains(func_start))

        vector<string> matches = {}
        vector<LSPFoundTarget> file_names = {}
        let max_len = 0
        foreach f in files
            let found_at_line = 1
            select c from f.text
                let content = String(c)
                let args = ""
                let return_type = ""
                while content.len() > 0 && !content.starts_with(func_start)
                    if content[0] == '\n' do found_at_line++
                    content.remove(0)
                ;
                if content.len() == 0 do continue
                for i until func_start.size() do content.remove(0)
                while content.len() > 0 && !content.starts_with("=>")
                    args += content[0]
                    content.remove(0)
                ;
                for i until 2 do content.remove(0)
                if content.len() == 0 do continue
                while content.len() > 0 && !content.starts_with("\n") && !content.starts_with(" do")
                    return_type += content[0]
                    content.remove(0)
                ;
                let m_str = $"Args: {args} Returns: {return_type} File: {f.file_name}"
                matches.push_back(m_str)
                file_names.push_back(LSPFoundTarget(f.file_name, found_at_line))
                if m_str.size() > max_len do max_len = m_str.size()
            ;
        ;
        let pos = 0
        if file_names.size() == 0 doremi None<LSPFoundTarget>()
        loop
            Ncurses::box(0, 0, matches.size() + 2, clamp(max_len + 2, COLS/3, COLS))
            foreach i,s in matches do Ncurses::add(i + 1, 1, s)
            Ncurses::mark_until(1 + pos, 1, 5, clamp(max_len, COLS/3, COLS))
            let key = Ncurses::key()
            switch key
            case '\n' doremi Option<LSPFoundTarget>(file_names[pos])
            case KEY_DOWN dobr pos++
            case KEY_UP dobr pos--
            default doremi None<LSPFoundTarget>()
            ;
            if pos < 0 do pos = matches.size() - 1
            if pos >= matches.size() do pos = 0
        ;
    ;
;
