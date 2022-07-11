struct Class 
    bool is_struct = false
    string id = EMPTY
    Option<string> inherit = None<string>()
    vector<Function> functions = {}
    vector<Variable> variables = {}
    vector<string> template = {}
    fn to_cpp => string
        let class_str = template.size() > 0 ? TEMPLATE : EMPTY
        for i until template.size()
            class_str += template.at(i)
            class_str += i + 1 < template.size() ? TEMPLATE_MID : TEMPLATE_END
        ;
        class_str += is_struct ? STRUCT : CLASS
        class_str += id
        class_str += inherit.is_some ? INHERIT : EMPTY 
        class_str += inherit.value_or(EMPTY)
        class_str += BLOCK_START
        for i until variables.size()
            let v = variables.at(i)
            class_str += variable_state_to_cpp(v.variable_state)
            class_str += v.to_cpp(TAB, LINE_END)
        ;
        for i until functions.size()
            let f = functions.at(i)
            class_str += variable_state_to_cpp(f.variable_state)
            class_str += f.to_cpp(true)
        ;
        class_str += RBRACK + LINE_END
        return class_str
    ;
;
