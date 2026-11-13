fn same_signature Function a, Function b => bool
    if a.id != b.id || a.templates != b.templates doremi false
    if a.arguments.size() != b.arguments.size() doremi false
    for j until a.arguments.size()
        if a.arguments[j].v_type != b.arguments[j].v_type doremi false
    ;
    return true
;

// Member functions are validated per class in class_internal_declarations
fn validate_function Function function, Compiler *compiler_t =>
    if function.is_member do return
    foreach f in compiler_t->program->functions
        if f.is_member do continue
        if same_signature(f, function) do error($"Duplicate instances Function of: {function.id}", compiler_t->recap())
    ;
;

fn function_construct Compiler *compiler_t, VariableState state, bool constr => Function doremi function_construct(compiler_t, state, constr, {}, false)
fn function_construct Compiler *compiler_t, VariableState state, bool constr, vector<Variable> variables => Function doremi function_construct(compiler_t, state, constr, variables, true)
fn function_construct Compiler *compiler_t, VariableState state, bool constr, vector<Variable> variables, bool is_member => Function
    let function = Function(state)
    function.is_member = is_member
    vector<Variable> variables_in_func = {}
    if !constr
        let func_id = next_or_exit(compiler_t, "[FunctionError]: No Function Id")
        if func_id.token == Token::Id do function.id = func_id.name
        elif func_id.token == Token::Where do function.id = func_id.name
        // Top-level keywords mean nothing after fn, so `fn get` and `fn use` are fine
        elif any(func_id.token, {Token::Get, Token::Include, Token::Use, Token::Named, Token::Compiler}) do function.id = func_id.name
        else
            switch func_id.token
            case Token::And
            case Token::Or
            case Token::Sum
            case Token::Sub
            case Token::Increment
            case Token::Decrement
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
            default dobr error($"Expected id or operator but got: {func_id.name}{keyword_note(func_id)}", compiler_t->recap())
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
    elif constr
        // Constructor initializer list: `Square int s => Rect(s, s), label("sq")`
        loop
            let peeked = compiler_t->peek().value_or(AstToken("\n"))
            if peeked.is_nl() || peeked.is_do() || peeked.is_terminator() do break
            compiler_t->next()
            function.initializer = join_token(function.initializer, peeked.name)
        ;
        function.return_value = Some(Variable(true))
    ;
    else
        peeked_opt = compiler_t->peek()
        let is_do = peeked_opt.value_or(AstToken("NONE")).is_do()
        function.return_value = is_do ? Some(Variable(true)) : Some(get_type(compiler_t))
    ;
    loop
        let x = next_or_exit(compiler_t, $"Function is not closed {function.id}")
        if any(x.token, {Token::SemiColon, Token::Eof}) do break
        if x.token == Token::Function dobr error($"Function above is not closed {function.id}", compiler_t->recap())
        if x.is_nl() do continue
        // `fn f => do for ...`: a one-line body that is itself a statement
        let one_line_statement = false
        if x.token == Token::Do
            let peeked = compiler_t->peek().value_or(AstToken("\n"))
            if any(peeked.token, {Token::For, Token::Foreach, Token::Condition, Token::Switch, Token::Select, Token::Match})
                x = next_or_exit(compiler_t, "[Function] Expected statement after do")
                one_line_statement = true
            ;
        ;
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
        if x.is_do() || one_line_statement do break
    ;
    if function.id == "main" do function.add_expr(Expression((string)"return 0"))
    validate_function(function, compiler_t)
    compiler_t->add(function)
    return function
;
