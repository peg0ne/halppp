fn switch_construct Compiler *compiler_t => Expression
    let cond = Condition("switch")
    let expression = ConditionalExpression()
    loop
        let x = next_or_exit(compiler_t, "[Switch] Switch is not closed")
        if x.is_do() do error("[Switch] Switch statements cannot have a do parameter", compiler_t->recap())
        if x.is_nl() dobr cond.expressions.push_back(expression)
        expression.value_left += x.name + " "
    ;
    loop
        let x = next_or_exit(compiler_t, "[Switch] Switch is not closed")
        let exit = false
        vector<Expression> result = {}
        switch x.token
            case Token::Default
                result = create_case(compiler_t, x.token == Token::Default)
                foreach i in result do cond.lines.push_back(i)
                break
            case Token::Case
                result = create_case(compiler_t, x.token == Token::Default)
                foreach i in result do cond.lines.push_back(i)
                break
            case Token::Eof dobr exit = true
            case Token::SemiColon dobr exit = true
            case Token::NewLine do break
            default dobr error($"[Switch] Token not allowed in switch {x.token}", compiler_t->recap())
        ;
        if exit do break
    ;
    return Expression(cond)
;

fn create_case Compiler *compiler_t, bool is_default => vector<Expression>
    vector<Expression> lines = {}
    let label = ""
    if !is_default
        let next = next_or_exit(compiler_t, "[Switch] Case unfinished")
        label = "case " + next.name
        let name = String(next.name)
        if next.is_id() && !name.starts_with("KEY_")
            if !compiler_t->has_enum(next.name) do error($"[Switch] Enum member doesn't exist: {next.name}", compiler_t->recap())
        ;
        if !next.valid_case() do error("Token not allowed in switch: ", compiler_t->recap())
        if next.is_id() && try_get(compiler_t, Token::DblColon)
            label += "::"
            compiler_t->next()
            let enum_name = next_or_exit(compiler_t, "[Switch] Unexpected end")
            if !compiler_t->has_enum_name(enum_name.name) do error($"[Switch] Enum member doesn't exist: {enum_name.name}", compiler_t->recap())
            label += enum_name.name
        ;
        label += ":\n"
    ;
    else do label = "default:\n"
    lines.push_back(Expression(label))
    loop
        let x = next_or_exit(compiler_t, "[Switch] Case unfinished")
        vector<Expression> result = {}
        switch x.token
            case Token::Case
            case Token::Default
            case Token::SemiColon
                compiler_t->prev()
                doremi lines
            case Token::Foreach
            case Token::For dobr lines.push_back(for_construct(compiler_t, x.token == Token::Foreach))
            case Token::Condition dobr lines.push_back(condition_construct(compiler_t, x.name))
            case Token::Switch dobr lines.push_back(switch_construct(compiler_t))
            case Token::Select dobr lines.push_back(select_construct(compiler_t))
            case Token::Match dobr lines.push_back(match_construct(compiler_t))
            case Token::NewLine do break
            default dobr lines.push_back(expression_construct(compiler_t, x))
        ;
    ;
;