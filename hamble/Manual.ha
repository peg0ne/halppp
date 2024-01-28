get => ncurses, list, stringextensions, math
class Manual
    int current = 0
    int currentMan = 0
    int skip = 0
    int skipMan = 0
    Option<int> selected = None<int>()
    List<string> files = List<string>()
    List<string> content = List<string>()
    Manual =>
        Ncurses::init()
        Ncurses::start()
        select home from home_env()
            let found = list_reg_files($"{home}/.local/lib/halppp")
            foreach f in found
                let s = String(f)
                s.remove_back(3)
                if s.starts_with(".") do continue
                if s.len() == 0 do continue
                files.add(s.to_string())
            ;
        ;
    ;
    fn draw_enum int i, vector<string> *lines => int
        loop
            if i >= lines->size() doremi i
            let line = String(lines->at(i))
            if line.contains(";") doremi i
            if !line.starts_with("enum")
                line.remove_back(1)
                Ncurses::col(2)
                Ncurses::add_until(i - skipMan, 0, "-", COLS, false)
                Ncurses::col(2, false)
                Ncurses::add_until(i++ - skipMan, 1, line.to_string(), COLS, false)
            ;
            else
                Ncurses::col(1)
                Ncurses::add_until(i - skipMan, 0, "enum", COLS, false)
                Ncurses::col(1, false)
                Ncurses::add_until(i++ - skipMan, 5, line.replace("enum ", ""), COLS, false)
            ;
        ;
    ;
    fn draw_fn int i, vector<string> *lines, short col => int
        let line = String(lines->at(i))
        let print_line = line
        let remove_at = line.find(0, " do ")
        select r from remove_at
            print_line = String(line.substr(0, r))
        ;
        remove_at = line.find(0, " dore ")
        select r from remove_at
            print_line = String(line.substr(0, r))
        ;
        remove_at = line.find(0, " doremi ")
        select r from remove_at
            print_line = String(line.substr(0, r))
        ;
        if col != 0
            Ncurses::col(col)
            Ncurses::add_until(i - skipMan, 0, "-", COLS, false)
            Ncurses::col(col, false)
        ;
        else
            Ncurses::col(1)
            Ncurses::add_until(i - skipMan, 0, "fn", COLS, false)
            Ncurses::col(1, false)
            print_line = String(print_line.replace("fn ", ""))
        ;
        Ncurses::add_until(i++ - skipMan, col != 0 ? 2 : 3, print_line.to_string(), COLS, false)
        if line.contains(" do ") doremi i
        if line.contains(" dore ") doremi i
        if line.contains(" doremi ") doremi i
        loop
            if i >= lines->size() doremi i
            skipMan++
            if col == 0
                if String(lines->at(i)).starts_with(";") doremi i
                i++
            ;
            elif String(lines->at(i++)).starts_with("    ;") doremi i
        ;
    ;
    fn draw_class int i, vector<string> *lines => int
        let class_name = ""
        loop
            if i >= lines->size() doremi i
            let line = String(lines->at(i))
            if line.contains(";") doremi i
            if !line.starts_with("class ")
                let stripped = line.strip()
                if String(stripped).starts_with(class_name)
                    i = draw_fn(i, lines, 3)
                ;
                elif String(stripped).starts_with("fn ")
                    i = draw_fn(i, lines, 1)
                ;
                else do i++; skipMan++
            ;
            else
                let stripped = String(line.replace("class ", "")).strip()
                class_name = line.split()[1]
                Ncurses::col(1)
                Ncurses::add_until(i - skipMan, 0, "class", COLS, false)
                Ncurses::col(1, false)
                Ncurses::add_until(i++ - skipMan, 6, stripped, COLS, false)
            ;
        ;
    ;
    fn draw_struct int i, vector<string> *lines => int
        let struct_name = ""
        loop
            if i >= lines->size() doremi i
            let line = String(lines->at(i))
            if line.contains(";") doremi i
            if !line.starts_with("struct ")
                let stripped = line.strip()
                if String(stripped).starts_with(struct_name)
                    i = draw_fn(i, lines, 3)
                ;
                elif String(stripped).starts_with("fn ")
                    i = draw_fn(i, lines, 1)
                ;
                else do i++; skipMan++
            ;
            else
                let stripped = String(line.replace("struct ", "")).strip()
                struct_name = line.split()[1]
                Ncurses::col(1)
                Ncurses::add_until(i - skipMan, 0, "struct", COLS, false)
                Ncurses::col(1, false)
                Ncurses::add_until(i++ - skipMan, 7, stripped, COLS, false)
            ;
        ;
    ;
    fn draw_content =>
        Ncurses::clearScr()
        select s from selected
            select home from home_env()
                let lines = readlines($"{home}/.local/lib/halppp/{files.at(s)}.ha")
                content = List<string>(lines)
                let i = 0
                skipMan = currentMan
                while i < lines.size()
                    let line = String(lines[i])
                    if line.starts_with("enum")
                        i = draw_enum(i, &lines)
                    ;
                    elif line.starts_with("class")
                        i = draw_class(i, &lines)
                    ;
                    elif line.starts_with("struct")
                        i = draw_struct(i, &lines)
                    ;
                    elif line.starts_with("fn")
                        i = draw_fn(i, &lines, 0)
                    ;
                    else do skipMan++
                    i++
                ;
                return
            ;
        ;
        foreach i, f in files do Ncurses::add(i, 0, $"- {f}")
        Ncurses::mark_until(current, 0, 5, COLS)
    ;
    fn search_content char key =>
        foreach i, f in files
            if f.size() <= 0 do continue
            if f[0] != key do continue
            if i == current do continue
            else dore current = i
        ;
    ;
pub
    fn run =>
        draw_content()
        loop
            let max = files.len() < LINES ? files.len() - 1 : LINES - 1
            let maxMan = content.len() - skipMan < LINES ? 0 : content.len() - skipMan - LINES
            let key = Ncurses::key()
            switch key
            case 'j'
            case KEY_UP 
                select s from selected
                    currentMan = clamp(currentMan - 1, 0, maxMan)
                    break
                ;
                current = clamp(current - 1, 0, max)
                break
            case 'k'
            case KEY_DOWN 
                select s from selected
                    currentMan = clamp(currentMan + 1, 0, maxMan + 1)
                    break
                ;
                current = clamp(current + 1, 0, max)
                break
            case 'a'
                if selected.is_some() do break
                selected = Some(current)
                currentMan = 0
                skipMan = 0
                skip = 0
                break
            case 'b'
                if selected.is_none() do break
                selected = None<int>()
                currentMan = 0
                skip = 0
                break
            case 'q' dore Ncurses::stop()
            default
                if selected.is_some() do break
                search_content(key)
                break
            ;
            draw_content()
        ;
    ;
;
