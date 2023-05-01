struct MatchLines
    vector<string> lines = {}
    MatchLines => do return
    MatchLines vector<string> lines =>
        this->lines = lines
    ;
;

struct MatchDef
    string matcher_expr = EMPTY
    vector<string> statments = {}
    vector<MatchLines> lines = {}
    Option<string> id = None<string>()
    MatchDef => do return
    MatchDef string matcher_expr, vector<string> statments, vector<MatchLines> lines, Option<string> id =>
        this->matcher_expr = matcher_expr
        this->statments = statments
        this->lines = lines
        this->id = id
    ;
    fn to_cpp => string
        string matcher = "{"
        matcher += NEWLINE
        matcher += TAB
        matcher += "auto _match_expr_ = " + matcher_expr + LINE_END
        foreach i, statment in statments
            if i == 0 do matcher += "if (_match_expr_ == " + statment + ") {\n" 
            elif statment != "_" do matcher += "elif (_match_expr_ == " + statment + ") {\n"
            else do matcher += "else {\n"
            let s_lines = lines[i]
            foreach j, line in s_lines.lines
                if j == s_lines.lines.size() - 1
                    select returner from id
                        matcher += returner + " = "
                    ;
                ;
                matcher += line + NEWLINE
            ;
            matcher += "}\n"
        ;
        matcher += "}\n"
        return matcher
    ;
;