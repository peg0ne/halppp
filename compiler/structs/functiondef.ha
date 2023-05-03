struct Function
    string id = EMPTY
    VariableState variable_state = VariableState::Public
    Option<Variable> return_value = None<Variable>()
    vector<Variable> arguments = {}
    vector<Expression> expressions = {}
    vector<string> templates = {}
    bool staticness = false
    Function VariableState state =>
        this->variable_state = state
    ;
    fn add_args Variable var => do arguments.push_back(var)
    fn add_expr Expression expr => do expressions.push_back(expr)
    fn to_cpp_start bool in_class => string
        string fun_str = templates.size() > 0 ? TEMPLATE : EMPTY
        for i until templates.size()
            fun_str += templates.at(i)
            fun_str += i + 1 < templates.size() ? TEMPLATE_MID : TEMPLATE_END
        ;
        fun_str += in_class ? TAB : EMPTY
        if staticness do fun_str += " static "
        fun_str += return_value.value_or(Variable(true)).v_type
        fun_str += SPACE + id + LPAREN
        for i until arguments.size()
            fun_str += arguments.at(i).to_cpp(EMPTY, EMPTY)
            fun_str += i + 1 < arguments.size() ? ARG_SEP : EMPTY
        ;
        fun_str += RPAREN
        return fun_str
    ;
    fn to_cpp_h => string doremi to_cpp_start(false) + LINE_END
    fn to_cpp bool in_class => string
        string fun_str = to_cpp_start(in_class)
        fun_str += BLOCK_START
        foreach e in expressions
            fun_str += e.to_cpp(1 + in_class)
        ;
        if in_class do fun_str += TAB
        fun_str += BLOCK_END
        return fun_str
    ;
;