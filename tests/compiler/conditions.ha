fn condition_construct Compiler *compiler_t, string condition_type => Expressioner
    let cond = Conditions(condition_type)
    let expression = ConditionalExpression()
    if condition_type == "elif" do cond = Conditions("else if")
    if condition_type == "loop"
        cond = Conditions("while")
        expression.value_left = "true"
    ;
    loop
        let x = get_next_or_exit(compiler_t->next(), "[Condition] Condition is not closed")
        if x.t.is_do()
            cond.add_expr(expression)
            cond.lines.push_back(expression_construct(compiler_t, x))
            return Expressioner(Some(cond), None<For>(), None<string>())
        ;
        if x.t.is_conditional_sep()
            expression.continuation = x.name
            cond.add_expr(expression)
            doco expression = ConditionalExpression()
        ;
        if x.t.is_conditional() doco expression.operator_value = x.name
        if x.token == TNewLine dobr cond.add_expr(expression)
        if expression.operator_value.size() == 0 doco expression.value_left += x.name + " "
        expression.value_right += x.name + " "
    ;
    loop
        let x = get_next_or_exit(compiler_t->next(), "[Condition] Condition is not closed")
        if any(x.token, {TSemiColon, TEof}) do break
        if x.token == TNewLine do continue;
        switch x.token
            case TCondition dobr cond.lines.push_back(condition_construct(compiler_t, x.name))
            case TFor dobr cond.lines.push_back(for_construct(compiler_t))
            default dobr cond.lines.push_back(expression_construct(compiler_t, x))
        ;
    ;
    return Expressioner(Some(cond), None<For>(), None<string>())
;
