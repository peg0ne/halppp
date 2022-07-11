struct ConditionalExpression
    string value_left = EMPTY
    string value_right = EMPTY
    string operator = EMPTY
    string continuation = EMPTY
    ConditionalExpression =>
    ;
    fn to_cpp => string
        let expr_str = value_left + SPACE
        expr_str += operator + SPACE
        expr_str += value_right + SPACE + continuation
        return expr_str
    ;
;

struct Condition
    string conditioner = EMPTY
    vector<ConditionalExpression> expressions = {}
    vector<Expression> lines = {}
    Condition string conditioner =>
        conditioner = conditioner
    ;
    fn to_cpp int indentation => string
        let condition_str = EMPTY
        for i until indentation do condition_str += TAB
        condition_str += conditioner
        if conditioner != ELSE
            condition_str += LPAREN
            for i until expressions.size() do condition_str += expression.at(i).to_cpp()
            condition_str += RPAREN
        ;
        condition_str += BLOCK_START
        for i until lines.size() do condition_str += lines.at(i).to_cpp(indentation + 1)
        for i until indentation do condition_str += TAB
        condition_str += BLOCK_END
        return condition_str
    ;
;
