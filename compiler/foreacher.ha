fn for_construct Compiler *compiler_t, bool is_foreach => Expression
    let for_def = For(is_foreach)
    let mid_checker = is_foreach ? Token::In : Token::Until
    for_def.iterator = get_id_or_exit(compiler_t, "[For] For loop is not closed")
    if is_foreach
        if compiler_t->peek().value_or(AstToken("None")).token == Token::Comma
            get_next_or_exit(compiler_t, "[For] missing comma")
            for_def.named_variable = Some(get_id_or_exit(compiler_t, "[For] Requires identifier"))
        ;
    ;
    get_or_exit(compiler_t, mid_checker, "[For] Missing keyword: " + to_string(mid_checker))
    for_def.until = compiler_t->next().value_or(AstToken("NONE")).name
    loop
        let x = get_next_or_exit(compiler_t, "[For] For loop is not closed")
        if x.is_do()
            for_def.lines.push_back(expression_construct(compiler_t, x))
            return Expression(for_def)
        ;
        if x.is_nl() do break
        for_def.until += x.name
    ;
    loop
        let x = get_next_or_exit(compiler_t, "[For] For loop is not closed")
        if x.is_terminator() do break
        if x.is_nl() do continue
        switch x.token
            case Token::Foreach
            case Token::For dobr for_def.lines.push_back(for_construct(compiler_t, x.token == Token::Foreach))
            case Token::Condition dobr for_def.lines.push_back(condition_construct(compiler_t, x.name))
            case Token::Switch dobr for_def.lines.push_back(switch_construct(compiler_t))
            case Token::Select dobr for_def.lines.push_back(select_construct(compiler_t))
            case Token::Match dobr for_def.lines.push_back(match_construct(compiler_t, false))
            default dobr for_def.lines.push_back(expression_construct(compiler_t, x))
        ;
    ;
    return Expression(for_def)
;