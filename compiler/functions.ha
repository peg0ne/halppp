fn validate_function Function function, Compiler *compiler_t =>
    if compiler_t->has_function(function.id)
        foreach f in compiler_t->program->functions
            if f.arguments.size() != function.arguments.size() do return
            for j until f.arguments.size()
                if f.arguments[j].v_type != function.arguments[j].v_type do return
                j++
            ;
        ;
        error($"Duplicate instances Function of: {function.id}", compiler_t->recap())
    ;
;

fn function_construct Compiler *compiler_t, VariableState state, bool constr => Function doremi function_construct(compiler_t, state, constr, {})
fn function_construct Compiler *compiler_t, VariableState state, bool constr, vector<Variable> variables => Function
    let function = Function(state)
    vector<Variable> variables_in_func = {}
    if !constr
        let func_id = get_next_or_exit(compiler_t, "[FunctionError]: No Function Id")
        if func_id.token == Token::Id do function.id = func_id.name
        else
            switch func_id.token
            case Token::And
            case Token::Or
            case Token::Sum
            case Token::Sub
            case Token::Bang
            case Token::Asterix
            case Token::DblLessThan
            case Token::DblMoreThan
            case Token::Equality
            case Token::NonEquality
            case Token::ForwardSlash
            case Token::LessThan
            case Token::LessThanOrEquals
            case Token::MoreThan
            case Token::MoreThanOrEquals
                function.id = "operator" + func_id.name
                break
            case Token::LBrack
                function.id = "operator[]"
                break
            default dobr error($"Expected id or operator but got: {func_id.name}", compiler_t->recap())
            ;
        ;
    ;
    let peeked_opt = compiler_t->peek()
    if peeked_opt.is_none() do error($"Error when trying to parse function: {function.id}", compiler_t->recap())
    if peeked_opt.value_or(AstToken("NONE")).token == Token::LessThan
        compiler_t->next()
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
                error("Return value invalid on main function", compiler_t->recap())
            ;
        ;
    ;
    else
        peeked_opt = compiler_t->peek()
        let is_do = peeked_opt.value_or(AstToken("NONE")).is_do()
        function.return_value = is_do ? Some(Variable(true)) : Some(get_type(compiler_t))
    ;
    loop
        let x = get_next_or_exit(compiler_t, $"Function is not closed {function.id}")
        if any(x.token, {Token::SemiColon, Token::Eof}) do break
        if x.token == Token::Function dobr error($"Function above is not closed {function.id}", compiler_t->recap())
        if x.is_nl() do continue
        switch x.token
            case Token::Foreach
            case Token::For dobr function.add_expr(for_construct(compiler_t, x.token == Token::Foreach))
            case Token::Condition dobr function.add_expr(condition_construct(compiler_t, x.name))
            case Token::Switch dobr function.add_expr(switch_construct(compiler_t))
            case Token::Select dobr function.add_expr(select_construct(compiler_t))
            case Token::Match dobr function.add_expr(match_construct(compiler_t))
            default
                let expr = expression_construct(compiler_t, x)
                function.add_expr(expr)
                select declaration from expr.e_declaration
                    foreach v in variables_in_func
                        if v.id == declaration.id
                            error("Multiple declarations with same name in function", compiler_t->recap())
                        ;
                    ;
                    foreach v in variables
                        if v.id == declaration.id
                            error("Variable already declared in class", compiler_t->recap())
                        ;
                    ;
                    foreach v in function.arguments
                        if v.id == declaration.id
                            error("Variable already declared in function arguments", compiler_t->recap())
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