fn condition_construct Compiler *compiler_t, string condition_type => Expressioner
    let condition_def = condition_type != "elif" ? Conditions(condition_type) : Conditions("else if")
    let expression = ConditionalExpression()
    while true
        let x = get_next_or_exit(compiler_t->next(), "[Condition] Condition is not closed")
        if x.t.is_do()
            condition_def.expressions.push_back(expression)
            condition_def.lines.push_back(expression_construct(compiler_t, x))
            return Expressioner(Some(condition_def), None<For>(), None<string>())
        ;
        if x.t.is_conditional_sep()
            expression.continuation = x.name
            condition_def.expressions.push_back(expression)
            expression = ConditionalExpression()
            continue
        ;
        if x.t.is_conditional() doco expression.operator_value = x.name
        if x.token == TNewLine dobr condition_def.expressions.push_back(expression)
        if expression.operator_value.size() == 0 doco expression.value_left += x.name + " "
        expression.value_right += x.name + " "
    ;
    let can_continue = true
    while can_continue
        let x = get_next_or_exit(compiler_t->next(), "[Condition] Condition is not closed")
        switch x.token
            case TCondition: dobr condition_def.lines.push_back(condition_construct(compiler_t, x.name))
            case TFor: dobr condition_def.lines.push_back(for_construct(compiler_t))
            case TSemiColon: dobr can_continue = false
            case TEof: dobr can_continue = false
            case TNewLine: do break
            default: dobr condition_def.lines.push_back(expression_construct(compiler_t, x))
        ;
    ;
    return Expressioner(Some(condition_def), None<For>(), None<string>())
;
