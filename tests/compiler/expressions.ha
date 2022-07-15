fn expression_construct Compiler *compiler_t, AstToken first => Expressioner
    string doing = EMPTY
    string expression = EMPTY
    if first.token == TLet doremi get_let_expr(compiler_t)
    switch first.token
        case TDoco: dobr doing = ";\ncontinue "
        case TDobr: dobr doing = ";\nbreak "
        case TDore: do doing = ";\nreturn "
        case TDo: dobr expression = "\n"
        case TDoremi: dobr expression = "\nreturn "
        case TReturn: dobr expression = "return "
        default: dobr expression = first.name
    ;
    loop
        let x = get_next_or_exit(compiler_t->next(), "[Expression] Expression ended unexpectedly")
        if any(x.token, {TEof, TNewLine}) dobr expression += doing
        if any(x.token, {TNumber, TId}) do expression += " "
        if x.t.is_do() do expression += "\n"
        switch x.token
            case TDo: do break
            case TDore: dobr doing = ";\nreturn "
            case TDobr: dobr doing = ";\nbreak "
            case TDoco: dobr doing = ";\ncontinue "
            case TDoremi: dobr expression += "return "
            case TLet: dobr expression += "auto"
            case TReturn: dobr expression += "return "
            default: dobr expression += x.name
        ;
    ;
    return Expressioner(None<Conditions>(), None<For>(), Some(expression))
;

fn get_let_expr Compiler *compiler_t => Expressioner
    let id = get_id_or_exit(compiler_t->next(), "[Let] Required id after let")
    get_or_exit(compiler_t->next(), TEquals,"[Let] Required equals after id")
    string expression = EMPTY
    string value = EMPTY
    loop
        let x = get_next_or_exit(compiler_t->next(), "LET exception")
        if any(x.token, {TEof, TNewLine}) do break
        value += x.name
    ;
    let token = Token_t(value).t
    if any(token, {TFalse, TTrue}) do expression = "bool "
    elif token == TNumber do expression = "int "
    elif token == TFloat do expression = "float "
    elif token == TChar do expression = "char "
    elif token == TString do expression = "string "
    else do expression = "auto "
    expression += id + " = " + value
    return Expressioner(None<Conditions>(), None<For>(), Some(expression))
;