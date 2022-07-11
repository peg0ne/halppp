struct Include
    string include = EMPTY
    Include string include =>
        include = include
    ;
    fn to_cpp => string
        let include_str = INCLUDE
        include_str += include.starts_with(QUOTE) ? include : RARROW + include + LARROW
        include_str += NEWLINE
        return include_str
    ;
;
struct Use
    string using = EMPTY
    Use =>
        using = using
    ;
    fn to_cpp => string doremi NAMESPACE + using + LINE_END
;
struct Get
    string get = EMPTY
;
