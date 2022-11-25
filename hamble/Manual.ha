get => ncurses, list, stringextensions, math
class Manual
    Ncurses n = Ncurses()
    int current = 0
    int skip = 0
    Option<int> selected = None<int>()
    List<string> files = List<string>()
    List<string> content = List<string>()
    Manual =>
        n.start()
        let found = list_reg_files("../lib")
        foreach f in found
            let s = String(f)
            s.remove_back(3)
            if s.starts_with(".") do continue
            if s.len() == 0 do continue
            files.add(s.to_string())
        ;
    ;
    fn draw_enum int i, vector<string> *lines => int
        loop
            if i >= lines->size() doremi i
            let line = String(lines->at(i))
            if line.contains(";") doremi i
            if !line.starts_with("enum")
                line.remove_back(1)
                n.col(2)
                n.add_until(i - skip, 0, "-", COLS, false)
                n.col(2, false)
                n.add_until(i++ - skip, 1, line.to_string(), COLS, false)
            ;
            else
                n.col(1)
                n.add_until(i - skip, 0, "enum", COLS, false)
                n.col(1, false)
                n.add_until(i++ - skip, 5, line.replace("enum ", ""), COLS, false)
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
            n.col(col)
            n.add_until(i - skip, 0, "-", COLS, false)
            n.col(col, false)
        ;
        else
            n.col(1)
            n.add_until(i - skip, 0, "fn", COLS, false)
            n.col(1, false)
            print_line = String(print_line.replace("fn ", ""))
        ;
        n.add_until(i++ - skip, col != 0 ? 2 : 3, print_line.to_string(), COLS, false)
        if line.contains(" do ") doremi i
        if line.contains(" dore ") doremi i
        if line.contains(" doremi ") doremi i
        loop
            if i >= lines->size() doremi i
            skip++
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
                else do i++; skip++
            ;
            else
                let stripped = String(line.replace("class ", "")).strip()
                class_name = line.split()[1]
                n.col(1)
                n.add_until(i - skip, 0, "class", COLS, false)
                n.col(1, false)
                n.add_until(i++ - skip, 6, stripped, COLS, false)
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
                else do i++; skip++
            ;
            else
                let stripped = String(line.replace("struct ", "")).strip()
                struct_name = line.split()[1]
                n.col(1)
                n.add_until(i - skip, 0, "struct", COLS, false)
                n.col(1, false)
                n.add_until(i++ - skip, 7, stripped, COLS, false)
            ;
        ;
    ;
    fn draw_content =>
        n.clearScr()
        select s from selected
            let lines = readlines($"../lib/{files.at(s)}.ha")
            let i = 0
            skip = current
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
                else do skip++
                i++
            ;
            return
        ;
        foreach i, f in files do n.add(i, 0, $"- {f}")
        n.mark_until(current, 0, 5, COLS)
    ;
pub
    fn run =>
        draw_content()
        loop
            let max = files.len() - 1 < LINES - 1 ? files.len() - 1 : LINES - 1
            switch n.key()
            case 'j'
            case KEY_UP dobr current = clamp(current - 1, 0, max)
            case 'k'
            case KEY_DOWN dobr current = clamp(current + 1, 0, max)
            case 'a'
                selected = Some(current)
                current = 0
                break
            case 'b'
                selected = None<int>()
                current = 0
                break
            case 'q' dore n.stop()
            ;
            draw_content()
        ;
    ;
;