enum VariableState
    Private,
    Protected,
    Public,
;

fn variable_state_to_cpp VariableState self => string
    switch self
    case VariableState::Private doremi PRIVATE_STATE
    case VariableState::Protected doremi PROTECTED_STATE
    case VariableState::Public doremi PUBLIC_STATE
    default doremi PRIVATE_STATE
    ;
;
