fn construct Compiler compiler, bool is_struct => Class
    let class_def = Class()
    class_def.is_struct = is_struct
    class_def.id = get_id_or_exit(compiler.next(), "[ClassError] Invalid Class Declaration")
    // Set Inheritance Or Template
    let next = get_next_or_exit(compiler.next(), "[ClassError] Invalid class definition of: " + class_def.id)
    switch next.token
        case LessThan:
            class_def.template = template::construct(compiler)
            next = get_next_or_exit(compiler.next(), "[ClassError] Invalid class definition of: " + class_def.id))
            switch next.token
                case CoolArrow:
                    class_def.inherit = Some(get_id_or_exit(compiler.next(), "[ClassError] Invalid Inheritor Token\nExpected Id for inheritance for class: " + class_def.id)
                    break
            ;
            break
        case CoolArrow:
            class_def.inherit = Some(get_id_or_exit(compiler.next(), "[ClassError] Invalid Inheritor Token\nExpected Id for inheritance for class: " + class_def.id)
            break
    ;
    //Construct inner Class values
    let variable_state = !is_struct ? Private_State : Public_State
    let can_continue = true
    while can_continue
        let next = get_next_or_exit(compiler.next(), "[ClassError] Class is not closed " + class_def.id)
        switch next.token
            case SemiColon: dobr can_continue = false
            case Class: dobr can_continue = false
            case Private: dobr variable_state = Private_State
            case Protected: dobr variable_state = Protected_State
            case Public: dobr variable_state = Public_State
            case Function:
                let function = function::construct(compiler, variable_state, false)
                dobr class_def.functions.push_back(function)
            case Id:
                if next.name == class_def.id
                    let function = function::construct(compiler, VariableState::Public, true)
                    function.return_value = Some(Variable(EMPTY, class_def.id, None<string>(), Private_State))
                    class_def.functions.push_back(function);
                    continue;
                ;
                let (mut variable, _) = variable::construct_args(compiler, Some(next.name))
                variable.variable_state = variable_state
                dobr class_def.variables.push_back(variable)
            case Type:
                let (mut variable, _) = variable::construct_args(compiler, Some(next.name))
                variable.variable_state = variable_state
                dobr class_def.variables.push_back(variable)
        ;
    ;
    validate(class_def, compiler)
    compiler.add_class(class_def)
    return class_def
;

fn validate Class class_def, Compiler compiler =>
    // Check Duplicate Classes
    if compiler.contains_class(class_def.id)
        display_err_message("Duplicate instances of: " + class_def.id)
    ;
    // Check Inheritance
    if !compiler.contains_class(class_def.inherit.value_or(EMPTY))
        display_err_message("Invalid Inheritance of: " + class_def.id + ", Inherits: " + class_def.inherit.value_or(EMPTY))
    ;
;
