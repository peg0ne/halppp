struct Variable
    string id = EMPTY
    string v_type = EMPTY
    Option<string> v_value = None<string>()
    VariableState variable_state = Private
    Variable =>
    ;
    Variable string id, string type, Option<string> value, VariableState state =>
        id = id
        v_type = type
        v_value = value
        variable_state = state
    ;
    Variable bool is_void =>
        id = RETURN_VALUE_IDS
        v_type = VOID
    ;
    fn has_id => bool doremi id.size() != 0
    fn has_type => bool doremi v_type.size() != 0
    fn has_minimum => bool doremi has_id() && has_type()
    fn to_cpp string spacing, string new_line => string
        let base = spacing + v_type + SPACE + id
        base += v_value.is_some() ? ASSIGNMENT : EMPTY
        base += v_value.value_or(EMPTY) + new_line
        return base
    ;
;
