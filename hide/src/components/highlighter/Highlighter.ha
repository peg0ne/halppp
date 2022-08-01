class Highlighter
    Syntax _syntax = 
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
        let last_start = 0
        let last_end = line.size()
        let pairs = 0
        vector<short> colors = {1,2,3,7,8,9}
        loop
            let start = line.find(match, last_start)
            if start == -1 do break
            let close = line.rfind(end, last_end)
            if close == -1 do break
            last_start = start + 1
            last_end = close - 1
            let color = colors[pairs % colors.size()]
            n->mark(y, start + x, color)
            n->mark(y, close + x, color)
            pairs++
        ;
    ;
;

