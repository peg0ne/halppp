struct Function
    string id = EMPTY
    VariableState variable_state = Public
    Option<Variable> return_value = None<Variable>()
    vector<Variable> arguments = {}
    vector<Expression> expressions = {}
    vector<string> template = {}
    Function VariableState state =>
        variable_state = state
    ;
    fn to_cpp bool in_class => string
        let fun_str = template.size() > 0 ? TEMPLATE : EMPTY
        for i until template.size()
            fun_str += template.at(i)
            fun_str += i + 1 < template.size() = TEMPLATE_MID : TEMPLATE_END
        ;
        fun_str += in_class ? TAB : EMPTY
        fun_str += return_value.value_or(VOID)
        fun_str += SPACE + id + LPAREN
        for i until arguments.size()
            let a = arguments.at(i)
            fun_str += a.to_cpp(EMPTY, EMPTY)
            fun_str += i + 1 < arguments.size() ? ARG_SEP : ARG_END
        ;
        for i until expressions.size() do fun_str += expression.at(i).to_cpp()
        fun_str +=in_class ? TAB + BLOCK_END ? BLOCK_END
        return fun_str
    ;
;
