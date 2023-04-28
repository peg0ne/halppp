fn switch_construct Compiler *compiler_t, vector<Variable> variables => Expression
    let cond = Condition("switch")
    let expression = ConditionalExpression()
    loop
        let x = get_next_or_exit(compiler_t, "[Switch] Switch is not closed")
        if x.is_do() do display_err_message("[Switch] Switch statements cannot have a do parameter", compiler_t->to_err_message())
        if x.is_nl() dobr cond.expressions.push_back(expression)
        expression.value_left += x.name + " "
    ;
    loop
        let x = get_next_or_exit(compiler_t, "[Switch] Switch is not closed")
        let exit = false
        vector<Expression> result = {}
        switch x.token
            case Token::Default
                result = create_case(compiler_t, x.token == Token::Default, variables)
                foreach i in result do cond.lines.push_back(i)
                break
            case Token::Case
                result = create_case(compiler_t, x.token == Token::Default, variables)
                foreach i in result do cond.lines.push_back(i)
                break
            case Token::Eof dobr exit = true
            case Token::SemiColon dobr exit = true
            case Token::NewLine do break
            default dobr display_err_message("[Switch] Token not allowed in switch " + to_string(x.token), compiler_t->to_err_message())
        ;
        if exit do break
    ;
    return Expression(cond)
;

fn create_case Compiler *compiler_t, bool is_default, vector<Variable> variables => vector<Expression>
    vector<Expression> lines = {}
    string label = EMPTY
    if !is_default
        let next = get_next_or_exit(compiler_t, "[Switch] Case unfinished")
        label = "case " + next.name
        let name = String(next.name)
        if next.is_id() && !name.starts_with("KEY_")
            if !compiler_t->has_enum(next.name) do display_err_message("[Switch] Enum member doesn't exist:" + next.name, compiler_t->to_err_message())
        ;
        if !next.valid_case() do display_err_message("Token not allowed in switch: ", compiler_t->to_err_message())
        if next.is_id() && try_get(compiler_t, Token::DblColon)
            label += "::"
            compiler_t->next()
            let enum_name = get_next_or_exit(compiler_t, "[Switch] Unexpected end")
            if !compiler_t->has_enum_name(enum_name.name) do display_err_message("[Switch] Enum member doesn't exist: " + enum_name.name, compiler_t->to_err_message())
            label += enum_name.name
        ;
        label += ":\n"
    ;
    else do label = "default:\n"
    lines.push_back(Expression(label))
    loop
        let x = get_next_or_exit(compiler_t, "[Switch] Case unfinished")
        vector<Expression> result = {}
        switch x.token
            case Token::Case
            case Token::Default
            case Token::SemiColon
                compiler_t->prev()
                doremi lines
            case Token::Foreach
            case Token::For dobr lines.push_back(for_construct(compiler_t, x.token == Token::Foreach, variables))
            case Token::Condition dobr lines.push_back(condition_construct(compiler_t, x.name, variables))
            case Token::Switch dobr lines.push_back(switch_construct(compiler_t, variables))
            case Token::Select dobr lines.push_back(select_construct(compiler_t, variables))
            case Token::NewLine do break
            default dobr lines.push_back(expression_construct(compiler_t, x, variables))
        ;
    ;
;