struct Class 
    bool is_struct = false
    string id = ""
    Option<string> inherit = None<string>()
    vector<Function> functions = {}
    vector<Variable> variables = {}
    vector<string> template = {}
    fn to_cpp => string
        let class_str = template.size() > 0 ? "template <typename " : ""
        for i until template.size()
            class_str += template.at(i)
            class_str +=  i + 1 < template.size() ? class_str += ", typename " : ">\n"
        ;
        class_str += is_struct ? "struct " : "class "
        class_str += id
        class_str += inherit.is_some ? ": public " : "" 
        class_str += inherit.value_or("")
        class_str += " {\n"
        for v until variables.size()
            class_str += variable_state_to_cpp(v.variable_state)
            class_str += v.to_cpp("    ", ";\n")
        ;
        for f until functions.size()
            class_str += variable_state_to_cpp(v.variable_state)
            class_str += f.to_cpp(true)
        ;
        class_str += "};\n"
        return class_str
    ;
;
