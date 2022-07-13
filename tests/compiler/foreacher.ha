fn for_construct Compiler *compiler_t => Expressioner
    let for_def = For()
    for_def.iterator = get_id_or_exit(compiler_t->next(), "[For] For loop is not closed")
    get_or_exit(compiler_t->next(), TUntil, "[For] Missing until keyword")
    for_def.until = compiler_t->next().value_or(AstToken("NONE")).name
    while true
        let x = get_next_or_exit(compiler_t->next(), "[For] For loop is not closed")
        if x.t.is_do()
            for_def.lines.push_back(expression_construct(compiler_t, x))
            return Expressioner(None<Conditions>(), Some(for_def), None<string>())
        ;
        if x.token == TNewLine do break
        for_def.until += x.name
    ;
    let can_continue = true
    while can_continue
        let x = get_next_or_exit(compiler_t->next(), "[For] For loop is not closed")
        switch x.token
            case TCondition: dobr for_def.lines.push_back(condition_construct(compiler_t, x.name))
            case TFor: dobr for_def.lines.push_back(for_construct(compiler_t))
            case TSemiColon: dobr can_continue = false
            case TEof: dobr can_continue = false
            case TNewLine: dobr can_continue = true
            default: dobr for_def.lines.push_back(expression_construct(compiler_t, x))
        ;
    ;
    return Expressioner(None<Conditions>(), Some(for_def), None<string>())
;
