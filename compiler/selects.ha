fn select_construct Compiler *compiler_t, vector<Variable> variables => Expression
    let select_def = Select()
    select_def.value_name = get_id_or_exit(compiler_t, "[Select] is not closed")
    variables.push_back(Variable(select_def.value_name, "TYPE"))
    get_or_exit(compiler_t, Token::From, "[Select] Missing keyword: from")
    select_def.optional_value = compiler_t->next().value_or(AstToken("NONE")).name
    loop
        let x = get_next_or_exit(compiler_t, "[Select] is not closed")
        if x.is_do()
            select_def.lines.push_back(expression_construct(compiler_t, x, variables))
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
            case Token::For dobr select_def.lines.push_back(for_construct(compiler_t, x.token == Token::Foreach, variables))
            case Token::Condition dobr select_def.lines.push_back(condition_construct(compiler_t, x.name, variables))
            case Token::Switch dobr select_def.lines.push_back(switch_construct(compiler_t, variables))
            case Token::Select dobr select_def.lines.push_back(select_construct(compiler_t, variables))
            default
                let expr = expression_construct(compiler_t, x, variables)
                select_def.lines.push_back(expr)
                select declaration from expr.e_declaration
                    foreach v in variables
                        if v.id == declaration.id && v.v_type != "FUNC"
                            display_err_message("Variable has already been declared", compiler_t->to_err_message())
                        ;
                    ;
                    variables.push_back(declaration)
                ;
                break
        ;
    ;
    return Expression(select_def)
;