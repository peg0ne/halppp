struct Function
    string id = EMPTY
    VariableState variable_state = Public_State
    ClassOption<Variable> return_value = ClassNone<Variable>()
    vector<Variable> arguments = {}
    vector<Expressioner> expressions = {}
    vector<string> templates = {}
    Function VariableState state =>
        variable_state = state
    ;
    fn to_cpp bool in_class => string
        string fun_str = templates.size() > 0 ? TEMPLATE : EMPTY
        for i until templates.size()
            fun_str += templates.at(i)
            fun_str += i + 1 < templates.size() ? TEMPLATE_MID : TEMPLATE_END
        ;
        fun_str += in_class ? TAB : EMPTY
        fun_str += return_value.value_or(Variable(true)).v_type
        fun_str += SPACE + id + LPAREN
        for i until arguments.size()
            let a = arguments.at(i)
            fun_str += a.to_cpp(EMPTY, EMPTY)
            fun_str += i + 1 < arguments.size() ? ARG_SEP : ARG_END
        ;
        for i until expressions.size() do fun_str += expressions.at(i).to_cpp(1 + in_class)
        if in_class do fun_str += TAB
        fun_str += BLOCK_END
        return fun_str
    ;
;
