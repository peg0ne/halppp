get => ErrorChecker

class Highlighter
    Syntax _syntax
    Highlighter => do return
    Highlighter string filename =>
        let split = String(filename).split('.')
        let type = split.at(split.size()-1)
        _syntax = Syntax(type)
    ;
pub
    fn new_syntax string filename =>
        _syntax.destruct()
        let split = String(filename).split('.')
        let type = split.at(split.size()-1)
        _syntax = Syntax(type)
    ;
    fn destruct => do _syntax.destruct()
    fn syntax => Syntax doremi _syntax
    fn wordlist => vector<string> doremi _syntax.wordlist()
    fn error_check IContainer* container, string path, List<string> text, Vector internal_offset => do error_checker(&_syntax, container, path, text, internal_offset)
    fn highlight IContainer* container, => do highlight(container, false, 0)
    fn highlight IContainer* container, bool is_label, int x_offset =>
        if !_syntax.is_complete() do return
        let content = container->GetContent()
        if is_label
            content.clear()
            content.add(container->Label())
        ;
        let y = 0
        let boxes = _syntax.boxing()
        let custom = _syntax.custom()
        let offset = container->Offset()
        let size = container->Size()
        offset.x += x_offset
        let end = size.x + offset.x
        foreach line in content
            if y >= size.y do break
            if _syntax.name() == "halppp" && String(line).strip() == ";"
                let found = line.find(";")
                for i until size.y
                    if y-(i+1) < 0 do break
                    let above = content.at(y-(i+1))
                    if found >= above.size() || above.at(found) == ' '
                        attron(A_DIM)
                        Ncurses::add(y + offset.y - (i + 1), found + offset.x, '.')
                        attroff(A_DIM)
                    ;
                    else do break
                ;
            ;
            foreach part in custom
                let matches = re(line, part.expr, part.capture)
                foreach m in matches
                    let start = m.position + offset.x
                    let len = m.reg_match.size()
                    if start > end do continue
                    if start + len > end
                        len = end - start
                    ;
                    Ncurses::mark_until(
                        y + offset.y,
                        start,
                        part.color, 
                        len,
                        part.bold,
                        part.dim)
                ;
            ;
            foreach box in boxes
                highlight_pairs(line, box.start,
                    box.end,
                    y + offset.y,
                    offset.x, box.colors, end)
            ;
            y++
        ;
    ;
    
    fn highlight_pairs string line, string match, string end, int y, int x, vector<short> colors, int max_x =>
        h_pairs_imp(line, match, end, Vector(x,y), 0, 0, colors, max_x)
    ;
    fn h_pairs_imp string line, string match, string end, Vector xy, int depth, int start, vector<short> colors, int max_x => Option<int>
        //Try find first
        if colors.size() <= 0 do return None<int>()
        if start >= line.size() doremi None<int>()
        let first = line.find(match, start)
        if first == -1 doremi None<int>()
        if first + 1 >= line.size() doremi None<int>()
        if xy.x + first < max_x
            Ncurses::mark(xy.y, xy.x + first, colors[depth % colors.size()])
        ;

        //Find end and next start
        let next = line.find(match, first + 1)
        let next_end = line.find(end, first + 1)
        if next_end == -1 doremi None<int>()
        elif next > next_end
            if xy.x + next_end < max_x
                Ncurses::mark(xy.y, xy.x + next_end, colors[depth % colors.size()])
            ;
            h_pairs_imp(line, match, end, xy, 0, first + 1, colors, max_x)
        ;
        elif next < next_end 
            let keep = h_pairs_imp(line, match, end, xy, depth + 1, first + 1, colors, max_x)
            loop
                select find from keep
                    if find == -1 doremi None<int>()
                    if find + 1 >= line.size() doremi None<int>()
                    next_end = line.find(end, find + 1)
                    let next_start = line.find(match, find + 1)
                    if next_end < next_start
                        if xy.x + next_end < max_x
                            Ncurses::mark(xy.y, xy.x + next_end, colors[depth % colors.size()])
                        ;
                        break
                    ;
                    keep = h_pairs_imp(line, match, end, xy, depth + 1, find + 1, colors, max_x)
                    continue
                ;
                break
            ;
        ;
        return Some((int)next_end)
    ;
;
