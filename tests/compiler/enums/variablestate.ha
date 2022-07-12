enum VariableState =>
    Private_State,
    Protected_State,
    Public_State,
;

fn variable_state_to_cpp VariableState self => string
    switch self
        case Private_State: doremi PRIVATE_STATE
        case Protected_State: doremi PROTECTED_STATE
        case Public_State: doremi PUBLIC_STATE
    ;
    return PRIVATE_STATE
;
