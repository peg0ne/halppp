fn switch_construct Compiler *compiler_t => Expressioner
    let cond = Conditions("switch")
    let expression = ConditionalExpression()
    loop
        let x = get_next_or_exit(compiler_t->next(), "[Switch] Switch is not closed")
        if x.t.is_do() do display_err_message("[Switch] Switch statements cannot have a do parameter")
        if x.token == Token::NewLine dobr cond.expressions.push_back(expression)
        expression.value_left += x.name + " "
    ;
    loop
        let x = get_next_or_exit(compiler_t->next(), "[Switch] Switch is not closed")
        let exit = false
        vector<Expressioner> result = {}
        switch x.token
            case Token::Default
                result = create_case(compiler_t, x.token == Token::Default)
                for i until result.size() do cond.lines.push_back(result.at(i))
                break
            case Token::Case
                result = create_case(compiler_t, x.token == Token::Default)
                for i until result.size() do cond.lines.push_back(result.at(i))
                break
            case Token::Eof dobr exit = true
            case Token::SemiColon dobr exit = true
            case Token::NewLine do break
            default dobr display_err_message("[Switch] Token not allowed in switch " + to_string(x.token))
        ;
        if exit do break
    ;
    return Expressioner(cond)
;

fn create_case Compiler *compiler_t, bool is_default => vector<Expressioner>
    vector<Expressioner> lines = {}
    string label = EMPTY
    if !is_default
        let next = get_next_or_exit(compiler_t->next(), "[Switch] Case unfinished")
        if none(next.token, {Token::Id, Token::Number, Token::Char}) do display_err_message("Token not allowed in switch: ")
        label = "case " + next.name
        if try_get(compiler_t->peek(), Token::DblColon)
            label += "::"
            compiler_t->next()
            let enum_name = get_next_or_exit(compiler_t->next(), "[Switch] Unexpected end")
            label += enum_name.name + ":\n"
        ;
    ;
    else do label = "default:\n"
    lines.push_back(Expressioner(label))
    loop
        let x = get_next_or_exit(compiler_t->next(), "[Switch] Case unfinished")
        vector<Expressioner> result = {}
        switch x.token
            case Token::Case
            case Token::Default
            case Token::SemiColon
                compiler_t->prev()
                doremi lines
            case Token::Condition dobr lines.push_back(condition_construct(compiler_t, x.name))
            case Token::For dobr lines.push_back(for_construct(compiler_t))
            case Token::Switch dobr lines.push_back(switch_construct(compiler_t))
            case Token::NewLine do break
            default dobr lines.push_back(expression_construct(compiler_t, x))
        ;
    ;
;
