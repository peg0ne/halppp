enum VariableState =>
    Private_State,
    Protected_State,
    Public_State,
;

fn variable_state_to_cpp VariableState self => string
    if self == Private_State doremi PRIVATE_STATE
    if self == Protected_State doremi PROTECTED_STATE
    if self == Public_State doremi PUBLIC_STATE
    return PRIVATE_STATE
;
