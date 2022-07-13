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
    let can_continue = true
    while can_continue
        let x = get_next_or_exit(compiler_t->next(), "[Expression] Expression ended unexpectedly")
        switch x.token
            case TEof: dobr can_continue = false
            case TNewLine: dobr can_continue = false
            case TDore: do doing = ";\nreturn "
                dobr expression += "\n"
            case TDobr: do doing = ";\nbreak "
                dobr expression += "\n"
            case TDoco: do doing = ";\ncontinue "
                dobr expression += "\n"
            case TDo: dobr expression += "\n"
            case TDoremi: dobr expression += "\nreturn "
            case TLet: dobr expression += "auto"
            case TNumber: dobr expression += " " + x.name
            case TId: dobr expression += " " + x.name
            case TReturn: dobr expression += "return "
            default: dobr expression += x.name
        ;
    ;
    expression += doing
    return Expressioner(None<Conditions>(), None<For>(), Some(expression))
;
