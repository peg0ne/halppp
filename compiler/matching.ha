fn match_construct Compiler *compiler_t => Expression doremi match_construct(compiler_t, None<string>(), false)
fn match_construct Compiler *compiler_t, Option<string> id, bool is_let => Expression doremi match_construct(compiler_t, id, is_let, false)
fn match_construct Compiler *compiler_t, Option<string> id, bool is_let, bool is_return => Expression
    let matcher = ""
    vector<string> statments = {}
    vector<MatchLines> internal = {}
    vector<string> operators = {}
    //Expression to match
    loop 
        let x = next_or_exit(compiler_t, "[Match] requires some kind of expression to match")
        if x.token == Token::NewLine do break
        if x.token == Token::Eof dobr error("[Match] missing expression", compiler_t->recap())
        if x.is_do() dobr error("[Match] do is not valid in start expression", compiler_t->recap())
        if x.is_base() dobr error("[Match] Token is not valid in start expression", compiler_t->recap())
        matcher += x.name
    ;
    //Statements to match
    loop
        let op = "=="
        let adv_token = Token::UNKNOWN
        select peeked from compiler_t->peek()
            if peeked.is_adv_conditional()
                compiler_t->next()
                adv_token = peeked.token
            ;
            elif peeked.is_conditional() || peeked.token == Token::Period || peeked.token == Token::Pointer
                compiler_t->next()
                op = peeked.name
            ;
        ;
        if adv_token != Token::UNKNOWN
            operators.push_back(EMPTY)
            statments.push_back(match_adv_statements(compiler_t, adv_token))
        ;
        else
            operators.push_back(op)
            statments.push_back(match_statements(compiler_t))
        ;
        internal.push_back(match_lines(compiler_t))
        if try_get(compiler_t, Token::NewLine) do next_or_exit(compiler_t, "[Match] Missing new line")
        if try_get(compiler_t, Token::SemiColon)
            next_or_exit(compiler_t, "[Match] Missing ; at the end")
            break
        ;
        elif try_get(compiler_t, Token::Eof) do error("[Match] Unclosed match statement", compiler_t->recap())
    ;
    let match_def = MatchDef(matcher, statments, internal, id, is_let, operators)
    match_def.is_return = is_return
    return Expression(match_def)
; 

fn match_statements Compiler *compiler_t => string
    let statement = ""
    loop
        let x = next_or_exit(compiler_t, "[Match] statement not finalized")
        if x.token == Token::CoolArrow do break
        if x.token == Token::Eof do break
        statement += x.name
    ;
    return statement
;

fn match_adv_statements Compiler *compiler_t, Token adv => string
    let op = "=="
    let sep = " && "
    switch adv
        case Token::AllLessOrEquals dobr op = "<="
        case Token::AllLessThan dobr op = "<"
        case Token::AllMoreOrEquals dobr op = ">="
        case Token::AllMoreThan dobr op = ">"
        case Token::AllNotEquals dobr op = "!="
        case Token::AnyEquals dobr sep = " || "
        default do break
    ;
    let statement = $"_match_expr_ {op} "
    loop
        let x = next_or_exit(compiler_t, "[Match] statement not finalized")
        if x.token == Token::CoolArrow do break
        if x.token == Token::Eof do break
        if x.token == Token::Colon doco statement += $"{sep}_match_expr_ {op} "
        statement += x.name
    ;
    return statement
;

fn match_lines Compiler *compiler_t => MatchLines
    let lines = MatchLines()
    let x = next_or_exit(compiler_t, "[Match] expected some expression")
    if x.is_do()
        lines.lines.push_back(expression_construct(compiler_t, x, true).to_cpp(2))
        return lines
    ;
    loop
        match x.token
        Token::SemiColon => do break
        Token::Eof => do break
        Token::NewLine => doco x = next_or_exit(compiler_t, "[Match] expected some expression")
        Token::Foreach => do lines.lines.push_back(for_construct(compiler_t, true).to_cpp(2))
        Token::For => do lines.lines.push_back(for_construct(compiler_t, false).to_cpp(2))
        Token::Condition => do lines.lines.push_back(condition_construct(compiler_t, x.name).to_cpp(2))
        Token::Switch => do lines.lines.push_back(switch_construct(compiler_t).to_cpp(2))
        Token::Select => do lines.lines.push_back(select_construct(compiler_t).to_cpp(2))
        Token::Match => do lines.lines.push_back(match_construct(compiler_t).to_cpp(2))
        _ => do lines.lines.push_back(expression_construct(compiler_t, x).to_cpp(2))
        ;
        x = next_or_exit(compiler_t, "[Match] expected some expression")
    ;
    return lines
;
