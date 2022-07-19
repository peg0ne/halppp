fn for_construct Compiler *compiler_t, bool is_foreach => Expression
    let for_def = For(is_foreach)
    let mid_checker = is_foreach ? Token::In : Token::Until
    for_def.iterator = get_id_or_exit(compiler_t->next(), "[For] For loop is not closed")
    get_or_exit(compiler_t->next(), mid_checker, "[For] Missing keyword: " + to_string(mid_checker))
    for_def.until = compiler_t->next().value_or(AstToken("NONE")).name
    loop
        let x = get_next_or_exit(compiler_t->next(), "[For] For loop is not closed")
        if x.is_do()
            for_def.lines.push_back(expression_construct(compiler_t, x))
            return Expression(for_def)
        ;
        if x.is_nl() do break
        for_def.until += x.name
    ;
    loop
        let x = get_next_or_exit(compiler_t->next(), "[For] For loop is not closed")
        if x.is_terminator() do break
        if x.is_nl() do continue
        switch x.token
            case Token::Foreach
            case Token::For dobr for_def.lines.push_back(for_construct(compiler_t, x.token == Token::Foreach))
            case Token::Condition dobr for_def.lines.push_back(condition_construct(compiler_t, x.name))
            case Token::Switch dobr for_def.lines.push_back(switch_construct(compiler_t))
            default dobr for_def.lines.push_back(expression_construct(compiler_t, x))
        ;
    ;
    return Expression(for_def)
;
