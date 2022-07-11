enum VariableState =>
    Private,
    Protected,
    Public,
;

fn variable_state_to_str VariableState self => string
    switch v.variable_state
        case Private: doremi " private:\n"
        case Protected: doremi " protected:\n"
        case Public: doremi " public:\n"
    ;
;
