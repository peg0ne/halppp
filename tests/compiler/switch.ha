fn switch_construct Compiler *compiler_t => Expressioner
    let cond = Conditions("switch")
    let expression = ConditionalExpression()
    loop
        let x = get_next_or_exit(compiler_t->next(), "[Switch] Switch is not closed")
        if x.t.is_do() do display_err_message("[Switch] Switch statements cannot have a do parameter")
        if x.token == TNewLine dobr cond.expressions.push_back(expression)
        expression.value_left += x.name + " "
    ;
    loop
        let x = get_next_or_exit(compiler_t->next(), "[Switch] Switch is not closed")
        let exit = false
        vector<Expressioner> result = {}
        switch x.token
            case TDefault
                result = create_case(compiler_t, x.token == TDefault)
                for i until result.size() do cond.lines.push_back(result.at(i))
                break
            case TCase
                result = create_case(compiler_t, x.token == TDefault)
                for i until result.size() do cond.lines.push_back(result.at(i))
                break
            case TEof dobr exit = true
            case TSemiColon dobr exit = true
            case TNewLine do break
            default dobr display_err_message("[Switch] Token not allowed in switch " + x.token)
        ;
        if exit do break
    ;
    return Expressioner(Some(cond), None<For>(), None<string>())
;

fn create_case Compiler *compiler_t, bool is_default => vector<Expressioner>
    vector<Expressioner> lines = {}
    string label = EMPTY
    if !is_default
        let next = get_next_or_exit(compiler_t->next(), "[Switch] Case unfinished")
        if none(next.token, {TId, TNumber, TChar}) do display_err_message("Token not allowed in switch: ")
        label = "case " + next.name + ":\n"
        lines.push_back(Expressioner(None<Conditions>(), None<For>(), Some(label)))
    ;
    else
        label = "default:\n"
        lines.push_back(Expressioner(None<Conditions>(), None<For>(), Some(label)))
    ;
    loop
        let x = get_next_or_exit(compiler_t->next(), "[Switch] Case unfinished")
        vector<Expressioner> result = {}
        switch x.token
            case TCase
                compiler_t->prev()
                doremi lines
            case TDefault
                compiler_t->prev()
                doremi lines
            case TSemiColon
                compiler_t->prev()
                doremi lines
            case TCondition dobr lines.push_back(condition_construct(compiler_t, x.name))
            case TFor dobr lines.push_back(for_construct(compiler_t))
            case TSwitch dobr lines.push_back(switch_construct(compiler_t))
            case TNewLine do break
            default dobr lines.push_back(expression_construct(compiler_t, x))
        ;
    ;
;
