struct EnumValue
    string name = EMPTY
    Option<string> value = None<string>()
    EnumValue => do return
;

struct Enum
    string name = EMPTY
    vector<EnumValue> enums = {}
    Enum string enum_name =>
        this->name = enum_name
    ;
    fn to_cpp_string_start => string doremi $"string to_string({name} enumerator)"
    fn to_cpp_start => string doremi $"{ENUM}{name}: int"
    fn to_cpp_h => string doremi to_cpp_start() + LINE_END + to_cpp_string_start() + LINE_END
    fn to_cpp => string
        let enum_str = $"{to_cpp_start()}{BLOCK_START}"
        foreach e in enums
            enum_str += $"{TAB}{e.name}"
            select e_val from e.value do enum_str += $"{ASSIGNMENT}{e_val}"
            enum_str += ENUM_SEP
        ;
        enum_str += $"{RBRACK}{LINE_END}{to_cpp_string_start()}{BLOCK_START}"
        enum_str += "switch (enumerator) {\n" 
        foreach e in enums
            enum_str += $"case {name}::{e.name}"
            enum_str += $": return \"{e.name}\";\n"
        ;
        enum_str += "default: return \"UNKNOWN TYPE\";\n}};\n"
        return enum_str
    ;
;