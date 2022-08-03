class Highlighter
    Syntax _syntax
    Highlighter => do return
    Highlighter string filename =>
        let split = String(filename).split('.')
        let type = split.at(split.size()-1)
        _syntax = Syntax(type)
    ;
pub
    fn highlight IContainer* container, Ncurses *n =>
        let content = container->GetContent()
        let y = 0
        let boxes = _syntax.boxing()
        let custom = _syntax.custom()
        let offset = container->Offset()
        foreach line in content
            if y >= container->Size().y do break
            foreach part in custom
                let matches = re(line, part.expr, part.capture)
                foreach match in matches
                    n->mark_until(
                        y + offset.y,
                        match.position + offset.x,
                        part.color, 
                        match.match.size(),
                        part.bold)
                ;
            ;
            foreach box in boxes
                highlight_pairs(n, line, box.start, box.end, y + offset.y, offset.x, box.colors)
            ;
            y++
        ;
    ;
    
    fn highlight_pairs Ncurses *n, string line, string match, string end, int y, int x, vector<short> colors =>
        h_pairs_imp(n, line, match, end, Vector(x,y), 0, 0, colors)
    ;
    fn h_pairs_imp Ncurses *n, string line, string match, string end, Vector xy, int depth, int start, vector<short> colors => Option<int>
        //Try find first
        if colors.size() <= 0 do colors = {1}
        if start >= line.size() doremi None<int>()
        let first = line.find(match, start)
        if first == -1 doremi None<int>()
        if first + 1 >= line.size() doremi None<int>()
        n->mark(xy.y, xy.x + first, colors[depth % colors.size()])

        //Find end and next start
        let next = line.find(match, first + 1)
        let next_end = line.find(end, first + 1)
        if next_end == -1 doremi None<int>()
        
        //if next start is more than next end
        //it's not nested so we can mark safely and keep look for more
        elif next > next_end
            n->mark(xy.y, xy.x + next_end, colors[depth % colors.size()])
            h_pairs_imp(n, line, match, end, xy, 0, first + 1, colors)
        ;
        //else if next start is less than next end
        //It's nested and well need to keep checking until we find the end fo nesting
        elif next < next_end 
            let keep = h_pairs_imp(n, line, match, end, xy, depth + 1, first + 1, colors)
            loop
                select find from keep
                    if find + 1 >= line.size() doremi None<int>()
                    next_end = line.find(end, find + 1)
                    let next_start = line.find(match, find + 1)
                    if next_end < next_start
                        n->mark(xy.y, xy.x + next_end, colors[depth % colors.size()])
                        break
                    ;
                    keep = h_pairs_imp(n, line, match, end, xy, depth + 1, find + 1, colors)
                    continue
                ;
                break
            ;
        ;
        return Some((int)next_end)
    ;
;









