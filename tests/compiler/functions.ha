fn validate_function Function function, Compiler *compiler_t =>
    let contains = compiler_t->contains_function(function.id)
    if contains
        for i until compiler_t->program.functions.size()
            let f = compiler_t->program.functions.at(i)
            if f.arguments.size() != function.arguments.size() do return
            for j until f.arguments.size()
                if f.arguments[j].v_type != function.arguments[j].v_type do return
                j++
            ;
        ;
        display_err_message("Duplicate instances Function of: " + function.id)
    ;
;

fn function_construct Compiler *compiler_t, VariableState variable_state, bool constructor => Function
    let function = Function(variable_state)
    if !constructor 
        function.id = get_id_or_exit(compiler_t->next(), "[FunctionError]: No Function Id")
    ;
    let peeked_opt = compiler_t->peek()
    if peeked_opt.is_none() do display_err_message("Error when trying to parse function: " + function.id)
    if peeked_opt.value_or(AstToken("NONE")).token == TLessThan do function.templates = template_construct(compiler_t)
    while true
        let vnb = construct_args(compiler_t, None<string>())
        if !vnb.variable.has_minimum() do break
        function.add_args(vnb.variable)
        if vnb.is_end do break
    ;
    if function.id == "main"
        function.add_args(Variable("argc", "int", None<string>(), Private_State))
        function.add_args(Variable("argv[]", "char*", None<string>(), Private_State))
        function.return_value = Some(Variable("", "int", None<string>(), Private_State))
    ;
    else do function.return_value = Some(get_type(compiler_t))
    let can_continue = true
    while can_continue
        let x = get_next_or_exit(compiler_t->next(), "Function is not closed " + function.id)
        if any(x.token, {TSemiColon, TFunction, TEof}) do break
        if x.token == TNewLine do continue
        switch x.token 
            case TFor: dobr function.add_expr(for_construct(compiler_t))
            case TCondition: dobr function.add_expr(condition_construct(compiler_t, x.name))
            default: dobr function.add_expr(expression_construct(compiler_t, x))
        ;
        if x.t.is_do() do break
    ;
    if function.id == "main" do function.add_expr(Expressioner(None<Conditions>(), None<For>(), Some((string)"return 0")))
    // validate_function(function, compiler_t)
    compiler_t->add_fn(function)
    return function
;

