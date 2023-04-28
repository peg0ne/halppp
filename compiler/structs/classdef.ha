struct Class
    bool is_struct = false
    string id = EMPTY
    Option<string> inherit = None<string>()
    vector<Function> functions = {}
    vector<Variable> variables = {}
    vector<string> templates = {}
    vector<Variable> inherited_variables = {}
    vector<Function> inherited_functions = {}
    fn get_variables => vector<Variable>
        let vec = variables
        foreach v in inherited_variables do vec.push_back(v)
        foreach f in functions do vec.push_back(Variable(f.id, "FUNC"))
        foreach f in inherited_functions do vec.push_back(Variable(f.id, "FUNC"))
        return vec
    ;
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
        foreach v in variables
            class_str += variable_state_to_cpp(v.variable_state)
            class_str += v.to_cpp(TAB, LINE_END)
        ;
        foreach f in functions
            class_str += variable_state_to_cpp(f.variable_state)
            class_str += f.to_cpp(true)
        ;
        class_str += RBRACK
        class_str += LINE_END
        return class_str
    ;
;