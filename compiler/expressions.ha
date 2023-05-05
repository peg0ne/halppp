fn expression_construct Compiler *compiler_t, AstToken first => Expression
    let doing = ""
    let expression = ""
    if first.token == Token::Let doremi get_let_expr(compiler_t)
    if first.token == Token::MoreThan doremi get_lambda_expr(compiler_t)
    if first.token == Token::Id && try_get(compiler_t, Token::Equals)
        let t = get_next_or_exit(compiler_t, "[Expression] Expected =")
        expression = first.name   
        expression += t.name
        if try_get(compiler_t, Token::Match)
            get_next_or_exit(compiler_t, "[Expression] Expected match")
            return match_construct(compiler_t, Some(first.name), false)
        ;
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
        let x = get_next_or_exit(compiler_t, "[Expression] Expression ended unexpectedly")
        if x.token == Token::Eof dobr expression += doing
        if x.token == Token::NewLine
            select peeked from compiler_t->peek()
                if none(peeked.token, {Token::Period, Token::Pointer})
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
            default dobr expression += x.name
        ;
    ;
    return Expression(expression)
;

fn get_let_expr Compiler *compiler_t => Expression
    let id = get_id_or_exit(compiler_t, "[Let] Required id after let")
    get_or_exit(compiler_t, Token::Equals,"[Let] Required equals after id")
    let variable_type = ""
    let value = ""
    if try_get(compiler_t, Token::Match)
        get_next_or_exit(compiler_t, "Expected match")
        return match_construct(compiler_t, Some(id), true)
    ;
    loop
        let x = get_next_or_exit(compiler_t, "[Let] Expected token got nothing")
        if x.token == Token::Eof do break
        if x.token == Token::NewLine
            let is_member = false
            select peeked from compiler_t->peek()
                is_member = String(peeked.name).starts_with(".")
            ;
            if !is_member do break
        ;
        value += x.name
        if x.token == Token::New do value += " "
    ;
    let token = Token_t(value)
    if token.is_bool() do variable_type = "bool "
    elif token.is_num() do variable_type = "int "
    elif token.is_float() do variable_type = "float "
    elif token.is_char() do variable_type = "char "
    elif token.is_string() do variable_type = "string "
    else do variable_type = "auto "
    let v = Variable(id, variable_type, Some(value), VariableState::Private)
    return Expression(v)
;

fn get_lambda_expr Compiler *compiler_t => Expression
    let id = get_id_or_exit(compiler_t, "[Lambda] Required id after >")
    let base = ""
    let has_return = false
    vector<string> parameters = {}
    let args = ""
    loop
        let x = get_next_or_exit(compiler_t, "[Lambda] Incomplete lambda")
        if x.token == Token::Id && String(x.name).starts_with("(")
            args = x.name
            break
        ;
        switch x.token
        case Token::Id dobr parameters.push_back(x.name)
        default dobr display_err_message("[Lambda] Incorrect parameter value", compiler_t->to_err_message())
        ;
        x = get_next_or_exit(compiler_t, "[Lambda] Incomplete lambda")
        if x.token == Token::Id && String(x.name).starts_with("(")
            args = x.name
            break
        ;
        if x.token == Token::Comma doco parameters.push_back(",")
        display_err_message("[Lambda] Comma missing", compiler_t->to_err_message())
    ;
    base += "["
    foreach p in parameters do base += p
    base += $"]{args}" + "{"
    let x = get_next_or_exit(compiler_t, "[Lambda] Incomplete lambda")
    if x.is_do()
        has_return = x.token == Token::Doremi
        let expr = expression_construct(compiler_t, x)
        base += expr.to_cpp(2)
    ;
    elif x.token == Token::NewLine
        loop
            x = get_next_or_exit(compiler_t, "[Lambda] Incomplete lambda")
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