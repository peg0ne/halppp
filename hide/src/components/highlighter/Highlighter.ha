class Highlighter
    Syntax _syntax = Syntax()
    Highlighter => do return
    Highlighter string filename =>
        let split = String(filename).split('.')
        let type = split.at(split.size()-1)
        let syntax = Syntax(type)
    ;
;
