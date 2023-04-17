fn expression_construct Compiler *compiler_t, AstToken first => Expression
    string doing = EMPTY
    string expression = EMPTY
    if first.token == Token::Let doremi get_let_expr(compiler_t)
    switch first.token
        case Token::Doco dobr doing = ";\ncontinue "
        case Token::Dobr dobr doing = ";\nbreak "
        case Token::Dore do doing = ";\nreturn "
        case Token::Do dobr expression = "\n"
        case Token::Doremi dobr expression = "\nreturn "
        case Token::Return dobr expression = "return "
        default dobr expression = first.name
    ;
    loop
        let x = get_next_or_exit(compiler_t, "[Expression] Expression ended unexpectedly")
        if x.token == Token::Eof dobr expression += doing
        if x.token == Token::NewLine
            let is_member = false
            select peeked from compiler_t->peek()
                is_member = String(peeked.name).starts_with(".")
            ;
            if !is_member dobr expression += doing
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
    string variable_type = EMPTY
    string expression = EMPTY
    string value = EMPTY
    loop
        let x = get_next_or_exit(compiler_t, "LET exception")
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
    expression += id + " = " + value
    return Expression(v)
;