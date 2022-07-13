fn expression_construct Compiler *compiler_t, AstToken first => Expressioner
    string doing = EMPTY
    string expression = EMPTY
    switch first.token
        case TDoco: dobr doing = ";\ncontinue "
        case TDobr: dobr doing = ";\nbreak "
        case TDore: do doing = ";\nreturn "
        case TDo: dobr expression = "\n"
        case TDoremi: dobr expression = "\nreturn "
        case TLet: dobr expression = "auto"
        case TReturn: dobr expression = "return "
        default: dobr expression = first.name
    ;
    while true
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
