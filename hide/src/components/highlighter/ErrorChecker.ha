fn error_checker Syntax* syntax, IContainer* container, Ncurses* n, string path =>
    if !syntax->is_complete() do return
    let content = container->GetContent()
    let y = 0
    let rules = syntax->rules()
    let offset = container->Offset()
    let size = container->Size()
    let end = size.x + offset.x
    let path_dir = ""
    let path_split = String(path).split('/')
    path_split.pop_back()
    foreach p in path_split do path_dir += p + "/"
    foreach line in content
        if y >= size.y do break
        let s = String(line)
        if s.starts_with("get")
            let matches = re(line, "[\\s,]([\\w/.)]*)", 1)
            foreach match in matches
                let start = match.position + offset.x
                let len = match.match.size()
                if start > end do continue
                if start + len > end
                    len = end - start
                ;
                select home from env("HOME")
                    select f from read($"{home}/.local/lib/halppp/{match.match}.ha") do continue
                    select f from read($"{path_dir}{match.match}.ha") do continue
                    n->mark_until(
                        y + offset.y,
                        start,
                        6,
                        len,
                        true,
                        true)
                ;
            ;
        ;
        y++
    ;
;