enum VariableState =>
    Private,
    Protected,
    Public,
;

fn variable_state_to_str VariableState self => string
    switch v.variable_state
        case Private: doremi PRIVATE_STATE
        case Protected: doremi PROTECTED_STATE
        case Public: doremi PUBLIC_STATE
    ;
;
