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
    vector<string> operators = {}
    MatchDef => do return
    MatchDef string matcher_expr, vector<string> statments, vector<MatchLines> lines, Option<string> id, bool is_let, vector<string> operators =>
        this->matcher_expr = matcher_expr
        this->statments = statments
        this->lines = lines
        this->id = id
        this->is_let = is_let
        this->operators = operators
    ;
    fn to_cpp => string
        let matcher = ""
        select returner from id
            if is_let
                matcher += $"auto {returner} = "
                let default_statement = -1
                foreach i, statment in statments
                    if statment == "_" dobr default_statement = i
                ;
                if default_statement == -1 do error("[Match] match let statement requires default statement!", "")
                let l = lines[default_statement]
                matcher += l.lines[l.lines.size() - 1]
            ;
        ;
        matcher += "{"
        matcher += $"\n{TAB}auto _match_expr_ = {matcher_expr}{LINE_END}"
        foreach i, statment in statments
            if i == 0 do matcher += $"if (_match_expr_ {operators[i]} {statment}) {BLOCK_START}"
            elif statment != "_" do matcher += $"else if (_match_expr_ {operators[i]} {statment}) {BLOCK_START}"
            else do matcher += "else {\n"
            let s_lines = lines[i]
            foreach j, line in s_lines.lines
                if j == s_lines.lines.size() - 1
                    select returner from id
                        matcher += $"{returner} = "
                    ;
                ;
                matcher += $"{line}\n"
            ;
            matcher += "}\n"
        ;
        matcher += "}\n"
        return matcher
    ;
;
