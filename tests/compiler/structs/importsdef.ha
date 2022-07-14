struct Include
    string include = EMPTY
    Include string include =>
        this->include = include
    ;
    fn to_cpp => string
        let is_quoted = String(include).starts_with(QUOTE)
        string include_str = INCLUDE
        include_str += is_quoted ? include : LARROW + include + RARROW
        include_str += NEWLINE
        return include_str
    ;
;
struct Uses
    string usings = EMPTY
    Uses string usings =>
        this->usings = usings
    ;
    fn to_cpp => string doremi NAMESPACE + usings + LINE_END
;
struct Get
    string get = EMPTY
;
