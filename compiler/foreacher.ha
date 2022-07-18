fn for_construct Compiler *compiler_t => Expressioner
    let for_def = For()
    for_def.iterator = get_id_or_exit(compiler_t->next(), "[For] For loop is not closed")
    get_or_exit(compiler_t->next(), Token::Until, "[For] Missing until keyword")
    for_def.until = compiler_t->next().value_or(AstToken("NONE")).name
    loop
        let x = get_next_or_exit(compiler_t->next(), "[For] For loop is not closed")
        if x.is_do()
            for_def.lines.push_back(expression_construct(compiler_t, x))
            return Expressioner(for_def)
        ;
        if x.is_nl() do break
        for_def.until += x.name
    ;
    loop
        let x = get_next_or_exit(compiler_t->next(), "[For] For loop is not closed")
        if x.is_terminator() do break
        if x.is_nl() do continue
        switch x.token
            case Token::Condition dobr for_def.lines.push_back(condition_construct(compiler_t, x.name))
            case Token::For dobr for_def.lines.push_back(for_construct(compiler_t))
            case Token::Switch dobr for_def.lines.push_back(switch_construct(compiler_t))
            default dobr for_def.lines.push_back(expression_construct(compiler_t, x))
        ;
    ;
    return Expressioner(for_def)
;
