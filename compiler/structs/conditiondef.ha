struct ConditionalExpression
    string value_left = EMPTY
    string value_right = EMPTY
    string operator_value = EMPTY
    string continuation = EMPTY
    ConditionalExpression => do return
    fn to_cpp => string
        let expr_str = value_left + SPACE
        expr_str += operator_value + SPACE
        expr_str += value_right + SPACE + continuation
        return expr_str
    ;
;

struct Condition
    string conditioner = EMPTY
    vector<ConditionalExpression> expressions = {}
    vector<Expression> lines = {}
    Condition => do return
    Condition string conditioner =>
        this->conditioner = conditioner
    ;
    fn add_expr ConditionalExpression cexpr => do expressions.push_back(cexpr)
    fn to_cpp int indentation => string
        string condition_str = EMPTY
        for i until indentation do condition_str += TAB
        condition_str += conditioner
        if conditioner != TOKEN_ELSE
            condition_str += LPAREN
            for i until expressions.size() do condition_str += expressions.at(i).to_cpp()
            condition_str += RPAREN
        ;
        condition_str += BLOCK_START
        for i until lines.size() do condition_str += expr_to_cpp(&lines.at(i), indentation + 1)
        condition_str += BLOCK_END
        return condition_str
    ;
;
