struct Class
    bool is_struct = false
    string id = EMPTY
    Option<string> inherit = None<string>()
    vector<Function> functions = {}
    vector<Variable> variables = {}
    vector<string> templates = {}
    fn contains Variable v => bool
        foreach var in variables
            if var.id == v.id doremi true
        ;
        return false
    ;
    fn to_cpp_start => string
        string class_str = templates.size() > 0 ? TEMPLATE : EMPTY
        for i until templates.size()
            class_str += templates.at(i)
            class_str += i + 1 < templates.size() ? TEMPLATE_MID : TEMPLATE_END
        ;
        class_str += is_struct ? STRUCT : CLASS
        class_str += id
        return class_str
    ;
    fn to_cpp_start_inherit => string
        string class_str = to_cpp_start()
        select i from inherit do class_str += INHERIT + i
        return class_str
    ;
    fn to_cpp_h => string doremi to_cpp_start() + LINE_END
    fn to_cpp => string
        string class_str = to_cpp_start_inherit()
        class_str += BLOCK_START
        let previous_state = VariableState::Private
        foreach i,v in variables
            if i == 0 || v.variable_state != previous_state
                class_str += variable_state_to_cpp(v.variable_state)
                previous_state = v.variable_state
            ;
            class_str += v.to_cpp(TAB, LINE_END)
        ;
        foreach i,f in functions
            if i == 0 || f.variable_state != previous_state
                class_str += variable_state_to_cpp(f.variable_state)
                previous_state = f.variable_state
            ;
            class_str += f.to_cpp(true)
        ;
        class_str += RBRACK
        class_str += LINE_END
        foreach v in variables
            if !v.staticness do continue
            class_str += v.v_type + " " + id + "::" + v.id
            select value from v.v_value
                class_str += " = " + value
            ;
            if v.v_value.is_none() && String(v.v_type).contains("*")
                class_str += " = nullptr"
            ;
            class_str += LINE_END
        ;
        return class_str
    ;
;