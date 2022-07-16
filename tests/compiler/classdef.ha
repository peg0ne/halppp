enum ClassError =>
    CClosed,
    CDefinition,
    CDuplicate,
    CInheritance,
    CNoId,
    CNoInheritor,
;

fn c_err ClassError err => string doremi c_err(err, EMPTY, false)
fn c_err ClassError err, string opt => string doremi c_err(err, opt, false)
fn c_err ClassError err, string opt, bool display => string
    string msg = "[Class] "
    switch err
    case CClosed      dobr msg += "Class is not closed "
    case CDefinition  dobr msg += "Invalid class definition of: "
    case CDuplicate   dobr msg += "Duplicate instance of: "
    case CInheritance dobr msg += "Invalid inheritance of: "
    case CNoId        dobr msg += "Invalid class declaration"
    case CNoInheritor dobr msg += "Invalid Inheritor Token\nExpected Id for inheritance for class: "
    default do break
    ;
    msg += opt
    if display do display_err_message(msg)
    return msg
;

fn class_validate Class class_def, Compiler *compiler_t =>
    // Check Duplicate Classes
    if compiler_t->has_class(class_def.id)
        c_err(CDuplicate, class_def.id, true)
    ;
    // Check Inheritance
    let inherit = class_def.inherit
    if inherit.is_none() do return
    if compiler_t->has_class(inherit.value_or(EMPTY)) do return
    let contains = compiler_t->has_class(inherit.value_or(EMPTY))
    if class_def.inherit.is_some() && !contains
        c_err(CInheritance, class_def.id, true)
    ;
;

fn class_construct Compiler *compiler_t, bool is_struct => Class
    let class_def = Class()
    class_def.is_struct = is_struct
    
    class_def.id = get_id_or_exit(compiler_t->next(), c_err(CNoId))
    // Set Inheritance Or Template
    let next = get_next_or_exit(compiler_t->next(), c_err(CDefinition, class_def.id))
    if next.token == TLessThan
        class_def.templates = template_construct(compiler_t)
        next = get_next_or_exit(compiler_t->next(), c_err(CDefinition, class_def.id))
    ;
    if next.token == TCoolArrow do class_def.inherit = Some(get_id_or_exit(compiler_t->next(), c_err(CNoInheritor, class_def.id)))
    //Construct inner Class values
    let variable_state = !is_struct ? Private_State : Public_State
    loop
        let next = get_next_or_exit(compiler_t->next(), c_err(CClosed, class_def.id))
        if next.token == TFunction
            let function = function_construct(compiler_t, variable_state, false)
            doco class_def.functions.push_back(function)
        ;
        elif any(next.token, {TId, TType})
            if next.name == class_def.id
                let function = function_construct(compiler_t, Public_State, true)
                function.return_value = Some(Variable(EMPTY, class_def.id, None<string>(), Private_State))
                doco class_def.functions.push_back(function)
            ;
            let vnb = construct_args(compiler_t, Some(next.name))
            vnb.variable.variable_state = variable_state
            doco class_def.variables.push_back(vnb.variable)
        ;
        elif any(next.token, {TEof, TSemiColon, TClass}) do break
        switch next.token
        case TPrivate dobr variable_state = Private_State
        case TProtected dobr variable_state = Protected_State
        case TPublic dobr variable_state = Public_State
        default do break
        ;
    ;
    class_validate(class_def, compiler_t)
    compiler_t->add_class(class_def)
    return class_def
;


