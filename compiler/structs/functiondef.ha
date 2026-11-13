struct Function
    string id = EMPTY
    VariableState variable_state = VariableState::Public
    Option<Variable> return_value = None<Variable>()
    vector<Variable> arguments = {}
    vector<Expression> expressions = {}
    vector<string> templates = {}
    bool staticness = false
    bool virtualness = false
    bool is_member = false
    Function VariableState state =>
        this->variable_state = state
    ;
    fn add_args Variable var => do arguments.push_back(var)
    fn add_expr Expression expr => do expressions.push_back(expr)
    fn to_cpp_start bool in_class => string doremi to_cpp_start(in_class, true)
    fn to_cpp_start bool in_class, bool defaults => string
        string fun_str = templates.size() > 0 ? TEMPLATE : EMPTY
        for i until templates.size()
            fun_str += templates.at(i)
            fun_str += i + 1 < templates.size() ? TEMPLATE_MID : TEMPLATE_END
        ;
        fun_str += in_class ? TAB : EMPTY
        if staticness do fun_str += " static "
        if virtualness do fun_str += " virtual "
        fun_str += return_value.value_or(Variable(true)).v_type
        fun_str += $" {id}("
        for i until arguments.size()
            let arg = arguments.at(i)
            if !defaults do arg.v_value = None<string>()
            fun_str += arg.to_cpp(EMPTY, EMPTY)
            fun_str += i + 1 < arguments.size() ? ARG_SEP : EMPTY
        ;
        fun_str += RPAREN
        return fun_str
    ;
    fn to_cpp_h => string doremi to_cpp_start(false) + LINE_END
    fn to_cpp bool in_class => string doremi to_cpp(in_class, true)
    // A definition that follows its declaration must not repeat default arguments
    fn to_cpp_def => string doremi to_cpp(false, false)
    fn to_cpp bool in_class, bool defaults => string
        let fun_str = to_cpp_start(in_class, defaults)
        fun_str += BLOCK_START
        foreach e in expressions
            fun_str += e.to_cpp(1 + in_class)
        ;
        if in_class do fun_str += TAB
        fun_str += BLOCK_END
        return fun_str
    ;
    // Template functions and deduced (auto) return types need their body wherever
    // they are called, so incremental builds keep them in the shared header
    fn header_only => bool
        if templates.size() > 0 doremi true
        return String(return_value.value_or(Variable(true)).v_type).contains("auto")
    ;
    // Out-of-class definition for a method of owner: `ret owner::id(args) {...}`
    fn to_cpp_out_of_line string owner => string
        string fun_str = id.size() == 0 ? EMPTY : return_value.value_or(Variable(true)).v_type + SPACE
        fun_str += id.size() == 0 ? $"{owner}::{owner}(" : $"{owner}::{id}("
        for i until arguments.size()
            let arg = arguments.at(i)
            arg.v_value = None<string>()
            fun_str += arg.to_cpp(EMPTY, EMPTY)
            fun_str += i + 1 < arguments.size() ? ARG_SEP : EMPTY
        ;
        fun_str += $"{RPAREN}{BLOCK_START}"
        foreach e in expressions
            fun_str += e.to_cpp(1)
        ;
        fun_str += BLOCK_END
        return fun_str
    ;
;
