struct Variable
    string id = EMPTY
    string v_type = EMPTY
    Option<string> v_value = None<string>()
    VariableState variable_state = Private_State
    Variable =>
    ;
    Variable string id, string type, Option<string> value, VariableState state =>
        this->id = id
        this->v_type = type
        this->v_value = value
        this->variable_state = state
    ;
    Variable bool is_void =>
        this->id = RETURN_VALUE_IDS
        this->v_type = VOID
    ;
    fn has_id => bool doremi id.size() != 0
    fn has_type => bool doremi v_type.size() != 0
    fn has_minimum => bool doremi has_id() && has_type()
    fn to_cpp string spacing, string new_line => string
        string base = spacing + v_type + SPACE + id
        base += v_value.is_some() ? ASSIGNMENT : EMPTY
        base += v_value.value_or(EMPTY) + new_line
        return base
    ;
;
