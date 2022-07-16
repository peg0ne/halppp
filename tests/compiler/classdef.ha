fn class_validate Class class_def, Compiler *compiler_t =>
    // Check Duplicate Classes
    let contains = compiler_t->contains_class(class_def.id) 
    if contains do display_err_message("Duplicate instances of: " + class_def.id)
    // Check Inheritance
    contains = compiler_t->contains_class(class_def.inherit.value_or(EMPTY))
    if class_def.inherit.is_some() && !contains
        display_err_message("Invalid Inheritance of: " + class_def.id + ", Inherits: " + class_def.inherit.value_or(EMPTY))
    ;
;

fn class_construct Compiler *compiler_t, bool is_struct => Class
    let class_def = Class()
    class_def.is_struct = is_struct
    class_def.id = get_id_or_exit(compiler_t->next(), "[ClassError] Invalid Class Declaration")
    // Set Inheritance Or Template
    let next = get_next_or_exit(compiler_t->next(), "[ClassError] Invalid class definition of: " + class_def.id)
    if next.token == TLessThan
        class_def.templates = template_construct(compiler_t)
        next = get_next_or_exit(compiler_t->next(), "[ClassError] Invalid class definition of: " + class_def.id)
    ;
    if next.token == TCoolArrow do class_def.inherit = Some(get_id_or_exit(compiler_t->next(), "[ClassError] Invalid Inheritor Token\nExpected Id for inheritance for class: " + class_def.id))
    //Construct inner Class values
    let variable_state = !is_struct ? Private_State : Public_State
    loop
        let next = get_next_or_exit(compiler_t->next(), "[ClassError] Class is not closed " + class_def.id)
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


