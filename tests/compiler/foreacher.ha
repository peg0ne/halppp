fn for_construct Compiler *compiler_t => Expressioner
    let for_def = For()
    for_def.iterator = get_id_or_exit(compiler_t->next(), "[For] For loop is not closed")
    get_or_exit(compiler_t->next(), TUntil, "[For] Missing until keyword")
    for_def.until = compiler_t->next().value_or(AstToken("NONE")).name
    loop
        let x = get_next_or_exit(compiler_t->next(), "[For] For loop is not closed")
        if x.t.is_do()
            for_def.lines.push_back(expression_construct(compiler_t, x))
            return Expressioner(None<Conditions>(), Some(for_def), None<string>())
        ;
        if x.token == TNewLine do break
        for_def.until += x.name
    ;
    loop
        let x = get_next_or_exit(compiler_t->next(), "[For] For loop is not closed")
        if any(x.token, {TSemiColon, TEof}) do break
        if x.token == TNewLine do continue
        switch x.token
            case TCondition dobr for_def.lines.push_back(condition_construct(compiler_t, x.name))
            case TFor dobr for_def.lines.push_back(for_construct(compiler_t))
            default dobr for_def.lines.push_back(expression_construct(compiler_t, x))
        ;
    ;
    return Expressioner(None<Conditions>(), Some(for_def), None<string>())
;
