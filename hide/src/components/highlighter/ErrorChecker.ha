get => TreeSitter

fn error_checker Syntax* syntax, IContainer* container, string path, List<string> text, Vector internal_offset =>
    init_pair(256, 196, 239)
    TreeSitter(container, path, text, internal_offset, syntax).run()
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
        foreach rule in rules
            if rule.type == "starts_with" && !s.starts_with(rule.value) do continue
            if rule.type == "contains" && !s.contains(rule.value) do continue
            let matches = re(line, rule.expr, rule.capture)
            foreach m in matches
                if rule.validation_type == "file_exists" doco file_exists_error_check(m, offset, size, y, path_dir, line)
                if rule.validation_type == "equals" doco equals_error_check(m, offset, size, y, rule.validation_value, line)
            ;
        ;
        y++
    ;
;

fn file_exists_error_check RegexMatch r_match, Vector offset, Vector size, int y, string path_dir, string line =>
    let start = r_match.position + offset.x
    let end = size.x + offset.x
    let len = r_match.reg_match.size()
    if start > end do return
    if start + len > end do len = end - start
    select home from env("HOME")
        select f from read($"{home}/.local/lib/halppp/{r_match.reg_match}.ha") do return
        select f from read($"{path_dir}{r_match.reg_match}.ha") do return
        Ncurses::underline_until(y + offset.y, start, 256, len)
        Ncurses::mark_until(y + offset.y, offset.x-5, 256, 5)
    ;
    Ncurses::col(1)
    Ncurses::add_until(y + offset.y, line.size() + offset.x + 1, $"◉ CANNOT FIND FILE {r_match.reg_match}", end, true)
    Ncurses::col(1,false)
;

fn equals_error_check RegexMatch r_match, Vector offset, Vector size, int y, string validation_value, string line =>
    if r_match.reg_match == validation_value do return
    let start = r_match.position + offset.x
    let end = size.x + offset.x
    let len = r_match.reg_match.size()
    if start > end do return
    if start + len > end do len = end - start
    Ncurses::underline_until(y + offset.y, start, 256, len)
    Ncurses::mark_until(y + offset.y, offset.x-5, 256, 5)
    Ncurses::col(1)
    Ncurses::add_until(y + offset.y, line.size() + offset.x + 1, $"◉ Invalid token found \"{r_match.reg_match}\" expected \"{validation_value}\"", end, true)
    Ncurses::col(1,false)
;