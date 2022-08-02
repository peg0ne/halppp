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
        if any(x.token, {Token::Eof, Token::NewLine}) dobr expression += doing
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
            default dobr expression += x.name
        ;
    ;
    return Expression(expression)
;

fn get_let_expr Compiler *compiler_t => Expression
    let id = get_id_or_exit(compiler_t, "[Let] Required id after let")
    get_or_exit(compiler_t, Token::Equals,"[Let] Required equals after id")
    string expression = EMPTY
    string value = EMPTY
    loop
        let x = get_next_or_exit(compiler_t, "LET exception")
        if any(x.token, {Token::Eof, Token::NewLine}) do break
        value += x.name
    ;
    let token = Token_t(value)
    if token.is_bool() do expression = "bool "
    elif token.is_num() do expression = "int "
    elif token.is_float() do expression = "float "
    elif token.is_char() do expression = "char "
    elif token.is_string() do expression = "string "
    else do expression = "auto "
    expression += id + " = " + value
    return Expression(expression)
;
