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
    fn to_cpp => string
        string enum_str = ENUM + name + BLOCK_START
        for i until enums.size()
            let e = enums.at(i)
            enum_str += TAB + e.name
            enum_str += e.value.is_some() ? ASSIGNMENT + e.value.value_or(EMPTY) : EMPTY
            enum_str += ENUM_SEP
        ;
        enum_str += RBRACK
        enum_str += LINE_END
        return enum_str
    ;
;
