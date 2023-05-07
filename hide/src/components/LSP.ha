named => LSP
    fn show_definition string word, string lang =>
        let func_start = $"fn {word} "
        let project_files = lgrep()
        vector<string> lib_files = {}
        select home from env("HOME")
            let dir = $"{home}/.local/lib"
            lib_files = lgrep(dir)
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
            .operate<Option<string>>([] (string file_name) {
                return read(file_name);
            })
            .where([] (Option<string> opt) {
                return opt.is_some();
            })
            .where([word, func_start] (Option<string> opt) {
                return String(opt.value_or("")).contains(func_start);
            }).as_vec()

        foreach i,f in files
            select c from f
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
                Ncurses::add(i,0, $"Args: {args} Returns: {return_type}")
            ;
        ;
        Ncurses::key()
    ;
;