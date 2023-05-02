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
    bool is_let = false
    MatchDef => do return
    MatchDef string matcher_expr, vector<string> statments, vector<MatchLines> lines, Option<string> id, bool is_let =>
        this->matcher_expr = matcher_expr
        this->statments = statments
        this->lines = lines
        this->id = id
        this->is_let = is_let
    ;
    fn to_cpp => string
        string matcher = EMPTY
        select returner from id
            if is_let
                matcher += "auto " + returner + " = "
                let default_statement = -1
                foreach i, statment in statments
                    if statment == "_" dobr default_statement = i
                ;
                if default_statement == -1 do display_err_message("[Match] match let statement requires default statement!", "")
                let l = lines[default_statement]
                matcher += l.lines[l.lines.size() - 1]
            ;
        ;
        matcher += "{"
        matcher += NEWLINE
        matcher += TAB
        matcher += "auto _match_expr_ = " + matcher_expr + LINE_END
        foreach i, statment in statments
            if i == 0 do matcher += "if (_match_expr_ == " + statment + ") {\n" 
            elif statment != "_" do matcher += "else if (_match_expr_ == " + statment + ") {\n"
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