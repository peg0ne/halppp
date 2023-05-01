fn select_construct Compiler *compiler_t => Expression
    let select_def = Select()
    select_def.value_name = get_id_or_exit(compiler_t, "[Select] is not closed")
    get_or_exit(compiler_t, Token::From, "[Select] Missing keyword: from")
    select_def.optional_value = compiler_t->next().value_or(AstToken("NONE")).name
    loop
        let x = get_next_or_exit(compiler_t, "[Select] is not closed")
        if x.is_do()
            select_def.lines.push_back(expression_construct(compiler_t, x))
            return Expression(select_def)
        ;
        if x.is_nl() do break
        select_def.optional_value += x.name
    ;
    loop
        let x = get_next_or_exit(compiler_t, "[Select] is not closed")
        if x.is_terminator() do break
        if x.is_nl() do continue
        switch x.token
            case Token::Foreach
            case Token::For dobr select_def.lines.push_back(for_construct(compiler_t, x.token == Token::Foreach))
            case Token::Condition dobr select_def.lines.push_back(condition_construct(compiler_t, x.name))
            case Token::Switch dobr select_def.lines.push_back(switch_construct(compiler_t))
            case Token::Select dobr select_def.lines.push_back(select_construct(compiler_t))
            case Token::Match dobr select_def.lines.push_back(match_construct(compiler_t))
            default dobr select_def.lines.push_back(expression_construct(compiler_t, x))
        ;
    ;
    return Expression(select_def)
;