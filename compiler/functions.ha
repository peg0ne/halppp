fn validate_function Function function, Compiler *compiler_t =>
    if compiler_t->has_function(function.id)
        for i until compiler_t->program->functions.size()
            let f = compiler_t->program->functions.at(i)
            if f.arguments.size() != function.arguments.size() do return
            for j until f.arguments.size()
                if f.arguments[j].v_type != function.arguments[j].v_type do return
                j++
            ;
        ;
        display_err_message("Duplicate instances Function of: " + function.id)
    ;
;

fn function_construct Compiler *compiler_t, VariableState state, bool constr => Function
    let function = Function(state)
    if !constr
        function.id = get_id_or_exit(compiler_t->next(), "[FunctionError]: No Function Id")
    ;
    let peeked_opt = compiler_t->peek()
    if peeked_opt.is_none() do display_err_message("Error when trying to parse function: " + function.id)
    if peeked_opt.value_or(AstToken("NONE")).token == Token::LessThan
        function.templates = template_construct(compiler_t)
    ;
    loop
        let vnb = construct_args(compiler_t)
        if !vnb.variable.has_minimum() do break
        function.add_args(vnb.variable)
        if vnb.is_end do break
    ;
    if function.id == "main"
        function.add_args(Variable("argc", "int"))
        function.add_args(Variable("argv[]", "char*"))
        function.return_value = Some(Variable("", "int"))
    ;
    else do function.return_value = Some(get_type(compiler_t))
    loop
        let x = get_next_or_exit(compiler_t->next(), "Function is not closed " + function.id)
        if any(x.token, {Token::SemiColon, Token::Function, Token::Eof}) do break
        if x.is_nl() do continue
        switch x.token 
            case Token::For dobr function.add_expr(for_construct(compiler_t))
            case Token::Condition dobr function.add_expr(condition_construct(compiler_t, x.name))
            case Token::Switch dobr function.add_expr(switch_construct(compiler_t))
            default dobr function.add_expr(expression_construct(compiler_t, x))
        ;
        if x.is_do() do break
    ;
    if function.id == "main"
        function.add_expr(Expressioner("return 0"))
    ;
    // validate_function(function, compiler_t)
    compiler_t->add_fn(function)
    return function
;

