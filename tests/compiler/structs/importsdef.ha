struct Include
    string include = EMPTY
    Include string include =>
        include = include
    ;
    fn to_cpp => string
        string include_str = INCLUDE
        include_str += starts_with(include, QUOTE) ? include : RARROW + include + LARROW
        include_str += NEWLINE
        return include_str
    ;
;
struct Uses
    string usings = EMPTY
    Uses string usings =>
        usings = usings
    ;
    fn to_cpp => string doremi NAMESPACE + usings + LINE_END
;
struct Get
    string get = EMPTY
;
