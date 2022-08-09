enum ClassError
    Closed,
    Definition,
    Duplicate,
    Inheritance,
    NoId,
    NoInheritor,
;

fn c_err ClassError err => string doremi c_err(err, EMPTY, false, "")
fn c_err ClassError err, string opt => string doremi c_err(err, opt, false, "")
fn c_err ClassError err, string opt, bool display, string recap => string
    string msg = "[Class] "
    switch err
    case ClassError::Closed      dobr msg += "Class is not closed "
    case ClassError::Definition  dobr msg += "Invalid class definition of: "
    case ClassError::Duplicate   dobr msg += "Duplicate instance of: "
    case ClassError::Inheritance dobr msg += "Invalid inheritance of: "
    case ClassError::NoId        dobr msg += "Invalid class declaration"
    case ClassError::NoInheritor dobr msg += "Invalid Inheritor Token\nExpected Id for inheritance for class: "
    default do break
    ;
    msg += opt
    if display do display_err_message(msg, recap)
    return msg
;

fn class_validate Class class_def, Compiler *compiler_t =>
    // Check Duplicate Classes
    if compiler_t->has_class(class_def.id)
        c_err(ClassError::Duplicate, class_def.id, true, compiler_t->to_err_message())
    ;
    // Check Inheritance
    select inherit from class_def.inherit
        if compiler_t->has_class(inherit) do return
        c_err(ClassError::Inheritance, class_def.id, true, compiler_t->to_err_message())
    ;
;

fn class_construct Compiler *compiler_t, bool is_struct => Class
    let class_def = Class()
    class_def.is_struct = is_struct
    
    class_def.id = get_id_or_exit(compiler_t, c_err(ClassError::NoId))
    // Set Inheritance Or Template
    let next = get_next_or_exit(compiler_t, c_err(ClassError::Definition, class_def.id))
    if next.token == Token::LessThan
        class_def.templates = template_construct(compiler_t)
        next = get_next_or_exit(compiler_t, c_err(ClassError::Definition, class_def.id))
    ;
    if next.token == Token::CoolArrow
        class_def.inherit = Some(get_id_or_exit(compiler_t, c_err(ClassError::NoInheritor, class_def.id)))
    ;
    //Construct inner Class values
    let variable_state = !is_struct ? VariableState::Private : VariableState::Public
    loop
        let next = get_next_or_exit(compiler_t, c_err(ClassError::Closed, class_def.id))
        if next.token == Token::Function
            let function = function_construct(compiler_t, variable_state, false)
            doco class_def.functions.push_back(function)
        ;
        elif any(next.token, {Token::Id, Token::Type})
            if next.name == class_def.id
                let function = function_construct(compiler_t, VariableState::Public, true)
                function.return_value = Some(Variable(EMPTY, class_def.id))
                doco class_def.functions.push_back(function)
            ;
            let vnb = construct_args(compiler_t, Some(next.name))
            vnb.variable.variable_state = variable_state
            doco class_def.variables.push_back(vnb.variable)
        ;
        elif any(next.token, {Token::Eof, Token::SemiColon, Token::Class}) do break
        switch next.token
        case Token::Private dobr variable_state = VariableState::Private
        case Token::Protected dobr variable_state = VariableState::Protected
        case Token::Public dobr variable_state = VariableState::Public
        default do break
        ;
    ;
    class_validate(class_def, compiler_t)
    compiler_t->add_class(class_def)
    return class_def
;