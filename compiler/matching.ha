fn match_construct Compiler *compiler_t => Expression doremi match_construct(compiler_t, None<string>(), false)
fn match_construct Compiler *compiler_t, Option<string> id, bool is_let => Expression
    let matcher = ""
    vector<string> statments = {}
    vector<MatchLines> internal = {}
    vector<string> operators = {}
    //Expression to match
    loop 
        let x = get_next_or_exit(compiler_t, "[Match] requires some kind of expression to match")
        if x.token == Token::NewLine do break
        if x.token == Token::Eof dobr display_err_message("[Match] missing expression", compiler_t->to_err_message())
        if x.is_do() dobr display_err_message("[Match] do is not valid in start expression", compiler_t->to_err_message())
        if x.is_base() dobr display_err_message("[Match] Token is not valid in start expression", compiler_t->to_err_message())
        matcher += x.name
    ;
    //Statements to match
    loop
        select peeked from compiler_t->peek()
            if peeked.is_conditional() || peeked.is_adv_conditional() || peeked.token == Token::Period || peeked.token == Token::Pointer
                compiler_t->next()
                operators.push_back(peeked.name)
            ;
            else do operators.push_back("==")
        ;
        statments.push_back(match_statements(compiler_t))
        internal.push_back(match_lines(compiler_t))
        if try_get(compiler_t, Token::NewLine) do get_next_or_exit(compiler_t, "[Match] Missing new line")
        if try_get(compiler_t, Token::SemiColon)
            get_next_or_exit(compiler_t, "[Match] Missing ; at the end")
            break
        ;
        elif try_get(compiler_t, Token::Eof) do display_err_message("[Match] Unclosed match statement", compiler_t->to_err_message())
    ;
    return Expression(MatchDef(matcher, statments, internal, id, is_let, operators))
; 

fn match_statements Compiler *compiler_t => string
    let statement = ""
    loop
        let x = get_next_or_exit(compiler_t, "[Match] statement not finalized")
        if x.token == Token::CoolArrow do break
        if x.token == Token::Eof do break
        statement += x.name
    ;
    return statement
;

fn match_lines Compiler *compiler_t => MatchLines
    let lines = MatchLines()
    let x = get_next_or_exit(compiler_t, "[Match] expected some expression")
    if x.is_do()
        lines.lines.push_back(expression_construct(compiler_t, x).to_cpp(2))
        return lines
    ;
    loop
        match x.token
        Token::SemiColon => do break
        Token::Eof => do break
        Token::NewLine => doco x = get_next_or_exit(compiler_t, "[Match] expected some expression")
        Token::Foreach => do lines.lines.push_back(for_construct(compiler_t, true).to_cpp(2))
        Token::For => do lines.lines.push_back(for_construct(compiler_t, false).to_cpp(2))
        Token::Condition => do lines.lines.push_back(condition_construct(compiler_t, x.name).to_cpp(2))
        Token::Switch => do lines.lines.push_back(switch_construct(compiler_t).to_cpp(2))
        Token::Select => do lines.lines.push_back(select_construct(compiler_t).to_cpp(2))
        Token::Match => do lines.lines.push_back(match_construct(compiler_t).to_cpp(2))
        _ => do lines.lines.push_back(expression_construct(compiler_t, x).to_cpp(2))
        ;
        x = get_next_or_exit(compiler_t, "[Match] expected some expression")
    ;
    return lines
;