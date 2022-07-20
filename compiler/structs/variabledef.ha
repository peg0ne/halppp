struct Variable
    string id = EMPTY
    string v_type = EMPTY
    Option<string> v_value = None<string>()
    VariableState variable_state = VariableState::Private
    Variable => do return
    Variable string id, string type =>
        this->id = id
        this->v_type = type
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
        select v from v_value do base += ASSIGNMENT + v
        base += new_line
        return base
    ;
;
