fn expression_construct Compiler *compiler_t, AstToken first => Expression doremi expression_construct(compiler_t, first, false)
// Remembers where the expression starts, so g++ errors point at the .ha line (see expr_to_cpp)
fn expression_construct Compiler *compiler_t, AstToken first, bool is_match => Expression
    let line = compiler_t->current_line + 1
    let expr = expression_construct_at(compiler_t, first, is_match)
    if compiler_t->source_file.size() > 0 && line > 0
        expr.src_line = line
        expr.src_file = compiler_t->source_file
    ;
    return expr
;
fn expression_construct_at Compiler *compiler_t, AstToken first, bool is_match => Expression
    let doing = ""
    let expression = ""
    if first.token == Token::Raw doremi Expression(first.name, true)
    // `if x do for ...`: a plain do followed by a statement builds that statement
    if first.token == Token::Do
        let peeked = compiler_t->peek().value_or(AstToken("\n"))
        if any(peeked.token, {Token::For, Token::Foreach, Token::Condition, Token::Switch, Token::Select, Token::Match})
            let statement = next_or_exit(compiler_t, "[Expression] Expected statement after do")
            switch statement.token
                case Token::Foreach
                case Token::For doremi for_construct(compiler_t, statement.token == Token::Foreach)
                case Token::Condition doremi condition_construct(compiler_t, statement.name)
                case Token::Switch doremi switch_construct(compiler_t)
                case Token::Select doremi select_construct(compiler_t)
                default doremi match_construct(compiler_t)
            ;
        ;
    ;
    if first.token == Token::Let doremi get_let_expr(compiler_t)
    if first.token == Token::MoreThan doremi get_lambda_expr(compiler_t)
    if first.token == Token::Id && try_get(compiler_t, Token::Equals)
        let t = next_or_exit(compiler_t, "[Expression] Expected =")
        expression = first.name   
        expression += t.name
        if try_get(compiler_t, Token::Match)
            next_or_exit(compiler_t, "[Expression] Expected match")
            return match_construct(compiler_t, Some(first.name), false)
        ;
    ;
    elif first.token == Token::Return && try_get(compiler_t, Token::Match)
        // return match x ... : every arm returns its last line
        next_or_exit(compiler_t, "[Expression] Expected match")
        return match_construct(compiler_t, None<string>(), false, true)
    ;
    else
        switch first.token
            case Token::Doco dobr doing = ";\ncontinue "
            case Token::Dobr dobr doing = ";\nbreak "
            case Token::Dore do doing = ";\nreturn "
            case Token::Do dobr expression = "\n"
            case Token::Doremi dobr expression = "\nreturn "
            case Token::Return dobr expression = "return "
            default dobr expression = first.name
        ;
    ;
    loop
        let x = next_or_exit(compiler_t, "[Expression] Expression ended unexpectedly")
        if x.token == Token::Eof dobr expression += doing
        if x.token == Token::NewLine
            select peeked from compiler_t->peek()
                if none(peeked.token, {Token::Period, Token::Pointer}) || is_match
                    expression += doing
                    break
                ;
            ;
        ;
        if any(x.token, {Token::Number, Token::Id}) do expression += " "
        if x.is_do() do expression += "\n"
        switch x.token
            case Token::Do do break
            case Token::Dore dobr doing = ";\nreturn "
            case Token::Dobr dobr doing = ";\nbreak "
            case Token::Doco dobr doing = ";\ncontinue "
            case Token::Doremi dobr expression += "return "
            case Token::Let dobr expression += "auto"
            case Token::Return dobr expression += "return "
            case Token::New dobr expression += "new "
            default dobr expression = join_token(expression, x.name)
        ;
    ;
    return Expression(expression)
;

fn get_let_expr Compiler *compiler_t => Expression
    let id = id_or_exit(compiler_t, "[Let] Required id after let")
    get_or_exit(compiler_t, Token::Equals,"[Let] Required equals after id")
    let variable_type = ""
    let value = ""
    let has_operator = false
    if try_get(compiler_t, Token::Match)
        next_or_exit(compiler_t, "Expected match")
        return match_construct(compiler_t, Some(id), true)
    ;
    if try_get(compiler_t, Token::Map)
        next_or_exit(compiler_t, "Expected map")
        return map_construct(compiler_t, id, true)
    ;
    loop
        let x = next_or_exit(compiler_t, "[Let] Expected token got nothing")
        if x.token == Token::Eof do break
        if x.token == Token::NewLine
            let is_member = false
            select peeked from compiler_t->peek()
                is_member = String(peeked.name).starts_with(".")
            ;
            if !is_member do break
        ;
        if x.is_conditional() || x.is_conditional_sep() || x.is_adv_conditional() do has_operator = true
        value = join_token(value, x.name)
        if x.token == Token::New do value += " "
    ;
    let token = Token_t(value)
    if has_operator do variable_type = "auto "
    elif token.is_bool() do variable_type = "bool "
    elif token.is_num() do variable_type = "int "
    elif token.is_float() do variable_type = "float "
    elif token.is_char() do variable_type = "char "
    elif token.is_string() do variable_type = "string "
    else do variable_type = "auto "
    let v = Variable(id, variable_type, Some(value), VariableState::Private)
    return Expression(v)
;

fn get_lambda_expr Compiler *compiler_t => Expression
    let id = id_or_exit(compiler_t, "[Lambda] Required id after >")
    let base = ""
    let has_return = false
    vector<string> parameters = {}
    let args = ""
    loop
        let x = next_or_exit(compiler_t, "[Lambda] Incomplete lambda")
        if x.token == Token::Id && String(x.name).starts_with("(")
            args = x.name
            break
        ;
        switch x.token
        case Token::Id dobr parameters.push_back(x.name)
        case Token::Equals dobr parameters.push_back(x.name)
        default dobr error("[Lambda] Incorrect parameter value", compiler_t->recap())
        ;
        x = next_or_exit(compiler_t, "[Lambda] Incomplete lambda")
        if x.token == Token::Id && String(x.name).starts_with("(")
            args = x.name
            break
        ;
        if x.token == Token::Comma doco parameters.push_back(",")
        error("[Lambda] Comma missing", compiler_t->recap())
    ;
    base += "["
    foreach p in parameters do base += p
    base += $"]{args}" + "{"
    let x = next_or_exit(compiler_t, "[Lambda] Incomplete lambda")
    if x.is_do()
        has_return = x.token == Token::Doremi
        let expr = expression_construct(compiler_t, x)
        base += expr.to_cpp(2)
    ;
    elif x.token == Token::NewLine
        loop
            x = next_or_exit(compiler_t, "[Lambda] Incomplete lambda")
            if x.token == Token::SemiColon do break
            if x.token == Token::Return do has_return = true
            if x.is_nl() do continue
            switch x.token
            case Token::Foreach
            case Token::For dobr base += for_construct(compiler_t, x.token == Token::Foreach).to_cpp(2)
            case Token::Condition dobr base += condition_construct(compiler_t, x.name).to_cpp(2)
            case Token::Switch dobr base += switch_construct(compiler_t).to_cpp(2)
            case Token::Select dobr base += select_construct(compiler_t).to_cpp(2)
            case Token::Match dobr base += match_construct(compiler_t).to_cpp(2)
            default dobr base += expression_construct(compiler_t, x).to_cpp(2)
            ;
        ;
    ;
    if !has_return do base += "return true;"
    base += "}"
    let v = Variable(id, "auto", Some(base), VariableState::Private)
    return Expression(v)
;
