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
        let ast = _syntax.ast()
        let offset = container->Offset()
        foreach line in content
            if y >= container->Size().y do break
            foreach token in ast
                let last = 0
                loop
                    let found = line.find(token.token, last)
                    if found == -1 do break
                    last = found + 1
                    n->mark_until(
                        y + offset.y,
                        found + offset.x,
                        token.color, 
                        token.token.size())
                ;
            ;
            highlight_numbers(n, line, y + offset.y, offset.x, 8)
            highlight_pairs(n, line, "[", "]", y + offset.y, offset.x)
            highlight_pairs(n, line, "(", ")", y + offset.y, offset.x)
            highlight_pairs(n, line, "{", "}", y + offset.y, offset.x)
            highlight_matched(n, line, "\"", y + offset.y, offset.x, 3)
            highlight_matched(n, line, "'", y + offset.y, offset.x, 8)
            y++
        ;
    ;
    fn highlight_numbers Ncurses *n, string line, int y, int x, short color =>
        vector<string> nums = {"0","1","2","3","4","5","6","7","8","9"}
        foreach num in nums
            let last = 0
            loop
                let found = line.find(num, last)
                if found == -1 do break
                last = found + 1
                n->mark(y, found + x, color)
            ;
        ;
    ;
    fn highlight_matched Ncurses *n, string line, string match, int y, int x, short color =>
        let last = 0
        let prev = -1
        loop
            let found = line.find(match, last)
            if found == -1 do break
            last = found + 1
            if prev != -1
                n->mark_until(
                    y,
                    prev + x,
                    color,
                    last - prev)
                prev = -1
                continue
            ;
            prev = found
        ;
    ;
    fn highlight_pairs Ncurses *n, string line, string match, string end, int y, int x =>
        h_pairs_imp(n, line, match, end, Vector(x,y), 0, 0)
    ;
    fn h_pairs_imp Ncurses *n, string line, string match, string end, Vector xy, int depth, int start => Option<int>
        vector<short> colors = {1,2,3,7,8,9}
        let first = line.find(match, start)
        if first == -1 doremi None<int>()
        n->mark(xy.y, xy.x + first, colors[depth % colors.size()])
        let next = line.find(match, first + 1)
        let next_end = line.find(end, first + 1)
        if next_end == -1 doremi None<int>()
        elif next > next_end
            n->mark(xy.y, xy.x + next_end, colors[depth % colors.size()])
            h_pairs_imp(n, line, match, end, xy, 0, first + 1)
        ;
        elif next < next_end 
            let keep = h_pairs_imp(n, line, match, end, xy, depth + 1, first + 1)
            select find from keep
                next_end = line.find(end, find + 1)
                n->mark(xy.y, xy.x + next_end, colors[depth % colors.size()])
            ;
        ;
        return Some((int)next_end)
    ;
;





