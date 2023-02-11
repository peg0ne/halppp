fn validate_function Function function, Compiler *compiler_t =>
    if compiler_t->has_function(function.id)
        foreach f in compiler_t->program->functions
            if f.arguments.size() != function.arguments.size() do return
            for j until f.arguments.size()
                if f.arguments[j].v_type != function.arguments[j].v_type do return
                j++
            ;
        ;
        display_err_message("Duplicate instances Function of: " + function.id, compiler_t->to_err_message())
    ;
;

fn function_construct Compiler *compiler_t, VariableState state, bool constr => Function doremi function_construct(compiler_t, state, constr, {})
fn function_construct Compiler *compiler_t, VariableState state, bool constr, vector<Variable> variables => Function
    let function = Function(state)
    let variables_in_func = {}
    if !constr
        function.id = get_id_or_exit(compiler_t, "[FunctionError]: No Function Id")
    ;
    let peeked_opt = compiler_t->peek()
    if peeked_opt.is_none() do display_err_message("Error when trying to parse function: " + function.id, compiler_t->to_err_message())
    if peeked_opt.value_or(AstToken("NONE")).token == Token::LessThan
        function.templates = template_construct(compiler_t)
    ;
    loop
        let vnb = construct_args(compiler_t, true)
        if !vnb.variable.has_minimum() do break
        function.add_args(vnb.variable)
        if vnb.is_end do break
    ;
    if function.id == "main"
        function.add_args(Variable("argc", "int"))
        function.add_args(Variable("argv[]", "char*"))
        function.return_value = Some(Variable("", "int"))
        select peeked from compiler_t->peek()
            if peeked.token != Token::NewLine
                display_err_message("Return value invalid on main function", compiler_t->to_err_message())
            ;
        ;
    ;
    else
        peeked_opt = compiler_t->peek()
        let is_do = peeked_opt.value_or(AstToken("NONE")).is_do()
        function.return_value = is_do ? Some(Variable(true)) : Some(get_type(compiler_t))
    ;
    loop
        let x = get_next_or_exit(compiler_t, "Function is not closed " + function.id)
        if any(x.token, {Token::SemiColon, Token::Function, Token::Eof}) do break
        if x.is_nl() do continue
        switch x.token
            case Token::Foreach
            case Token::For dobr function.add_expr(for_construct(compiler_t, x.token == Token::Foreach))
            case Token::Condition dobr function.add_expr(condition_construct(compiler_t, x.name))
            case Token::Switch dobr function.add_expr(switch_construct(compiler_t))
            case Token::Select dobr function.add_expr(select_construct(compiler_t))
            default
                let expr = expression_construct(compiler_t, x)
                function.add_expr(expr)
                select declaration from expr.e_declaration
                    foreach v in variables_in_func
                        if v.id == declaration.id
                            display_err_message("Multiple declarations with same name in function", compiler_t->to_err_message())
                        ;
                    ;
                    foreach v in variables
                        if v.id == declaration.id
                            display_err_message("Variable already declared in class", compiler_t->to_err_message())
                        ;
                    ;
                    foreach v in function.arguments
                        if v.id == declaration.id
                            display_err_message("Variable already declared in function arguments", compiler_t->to_err_message())
                        ;
                    ;
                    variables_in_func.push_back(declaration)
                ;
                
                break
        ;
        if x.is_do() do break
    ;
    if function.id == "main" do function.add_expr(Expression((string)"return 0"))
    validate_function(function, compiler_t)
    compiler_t->add_fn(function)
    return function
;