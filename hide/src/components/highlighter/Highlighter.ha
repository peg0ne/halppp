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
            y++
        ;
    ;
;
