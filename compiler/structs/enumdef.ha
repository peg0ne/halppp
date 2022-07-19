struct EnumValue
    string name = EMPTY
    Option<string> value = None<string>()
    EnumValue =>
    ;
;

struct Enum
    string name = EMPTY
    vector<EnumValue> enums = {}
    Enum string enum_name =>
        this->name = enum_name
    ;
    fn to_cpp_string_start => string doremi "string to_string(" + name + " enumerator)"
    fn to_cpp_start => string doremi ENUM + name + ": int"
    fn to_cpp_h => string doremi to_cpp_start() + LINE_END + to_cpp_string_start() + LINE_END
    fn to_cpp => string
        string enum_str = to_cpp_start() + BLOCK_START
        for i until enums.size()
            let e = enums.at(i)
            enum_str += TAB + e.name
            enum_str += e.value.is_some() ? ASSIGNMENT + e.value.value_or(EMPTY) : EMPTY
            enum_str += ENUM_SEP
        ;
        enum_str += RBRACK
        enum_str += LINE_END
        enum_str += to_cpp_string_start() + BLOCK_START
        enum_str += "switch (enumerator) {\n" 
        for i until enums.size()
            let e = enums.at(i)
            enum_str += "case " + name
            enum_str += "::" + e.name
            enum_str += ": return \"" + e.name + "\";\n"
        ;
        enum_str += "default: return \"UNKNOWN TYPE\";\n}};\n"
        return enum_str
    ;
;