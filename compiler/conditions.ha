enum ConditionError
    Closed,
;

fn co_err ConditionError err => string doremi co_err(err, EMPTY, false, "")
fn co_err ConditionError err, string opt => string doremi co_err(err, opt, false, "")
fn co_err ConditionError err, string opt, bool display, string recap => string
    string msg = "[Condition] "
    switch err
    case ConditionError::Closed dobr msg += "Condition is not closed "
    default do break
    ;
    msg += opt
    if display do display_err_message(msg, recap)
    return msg
;

fn condition_construct Compiler *compiler_t, string condition_type => Expression
    let cond = Condition(condition_type)
    let expression = ConditionalExpression()
    if condition_type == "elif" do cond = Condition("else if")
    if condition_type == "loop"
        cond = Condition("while")
        expression.value_left = "true"
    ;
    loop
        let x = get_next_or_exit(compiler_t, co_err(ConditionError::Closed))
        if x.is_do()
            cond.add_expr(expression)
            cond.lines.push_back(expression_construct(compiler_t, x))
            return Expression(cond)
        ;
        if x.is_conditional_sep()
            expression.continuation = x.name
            cond.add_expr(expression)
            doco expression = ConditionalExpression()
        ;
        if x.is_adv_conditional()
            adv_conditional_construct(compiler_t, &expression, x)
            cond.add_expr(expression)
            doco expression = ConditionalExpression()
        ;
        if x.is_conditional() doco expression.operator_value = x.name
        if x.is_nl() dobr cond.add_expr(expression)
        if expression.operator_value.size() == 0 doco expression.value_left += x.name + " "
        expression.value_right += x.name + " "
    ;
    loop
        let x = get_next_or_exit(compiler_t, co_err(ConditionError::Closed))
        if x.is_terminator() do break
        if x.is_nl() do continue
        switch x.token
            case Token::Foreach
            case Token::For dobr cond.lines.push_back(for_construct(compiler_t, x.token == Token::Foreach))
            case Token::Condition dobr cond.lines.push_back(condition_construct(compiler_t, x.name))
            case Token::Switch dobr cond.lines.push_back(switch_construct(compiler_t))
            case Token::Select dobr cond.lines.push_back(select_construct(compiler_t))
            default dobr cond.lines.push_back(expression_construct(compiler_t, x))
        ;
    ;
    return Expression(cond)
;

fn adv_conditional_construct Compiler *compiler_t, ConditionalExpression *expr, AstToken token =>
    let separator = "&& "
    switch token.token
        case Token::AllEquals dobr expr->operator_value = "=="
        case Token::AllLessOrEquals dobr expr->operator_value = "<="
        case Token::AllLessThan dobr expr->operator_value = "<"
        case Token::AllMoreOrEquals dobr expr->operator_value = ">="
        case Token::AllMoreThan dobr expr->operator_value = ">"
        case Token::AllNotEquals dobr expr->operator_value = "!="
        case Token::AnyEquals
            expr->operator_value = "=="
            separator = "|| "
            break
        default dobr display_err_message("UNKOWN TOKEN", compiler_t->to_err_message())
    ;
    let op = expr->operator_value + " "
    let left = expr->value_left + " "
    let is_first = true
    loop
        let x = compiler_t->peek().value_or(' ')
        if compiler_t->peek().is_none() do return
        if x.is_do() do return
        if x.is_conditional_sep() do return
        if x.is_nl() do return
        if x.name == ":" doco compiler_t->next()
        if !is_first do expr->value_right += separator + left + op
        expr->value_right += x.name + " "
        compiler_t->next()
        is_first = false
    ;
;