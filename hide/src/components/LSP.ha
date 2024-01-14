named => LSP
    struct LSPFileAndText
        string file_name
        Option<string> text
        LSPFileAndText string file_name, Option<string> text =>
            this->file_name = file_name
            this->text = text
        ;
    ;
    fn show_definition string word, string lang =>
        let func_start = $"fn {word} "
        let project_files = LGREP::lgrep()
        vector<string> lib_files = {}
        select home from env("HOME")
            let dir = $"{home}/.local/lib"
            lib_files = LGREP::lgrep(dir, 0)
            lib_files = linq::take(lib_files)
                .operate([dir](string file) {
                    return $"{dir}/{file}";
                }).as_vec()
        ;
        let files = linq::take(project_files)
            .join(lib_files)
            .where([lang] (string file_name) {
                return String(file_name).ends_with($".{lang}");
            })
            .operate<LSPFileAndText>([] (string file_name) {
                return LSPFileAndText(file_name, read(file_name));
            })
            .where([] (LSPFileAndText fat) {
                return fat.text.is_some();
            })
            .where([word, func_start] (LSPFileAndText fat) {
                return String(fat.text.value_or("")).contains(func_start);
            }).as_vec()

        vector<string> matches = {}
        let max_len = 0
        foreach i,f in files
            select c from f.text
                let content = String(c)
                let args = ""
                let return_type = ""
                while !content.starts_with(func_start) do content.remove(0)
                for i until func_start.size() do content.remove(0)
                while !content.starts_with("=>")
                    args += content[0]
                    content.remove(0)
                ;
                for i until 2 do content.remove(0)
                while !content.starts_with("\n") && !content.starts_with(" do")
                    return_type += content[0]
                    content.remove(0)
                ;
                let m_str = $"Args: {args} Returns: {return_type} File: {f.file_name}"
                matches.push_back(m_str)
                if m_str.size() > max_len do max_len = m_str.size()
            ;
        ;
        Ncurses::box(0, 0, matches.size() + 2, clamp(max_len + 2, COLS/3, COLS))
        foreach i,s in matches do Ncurses::add(i + 1, 1, s)
        Ncurses::key()
    ;
;
