struct VariableNBool
    Variable variable = Variable()
    bool is_end = false
    VariableNBool Variable v, bool is_end =>
        this->variable = v
        this->is_end = is_end
    ;
;

fn get_value Compiler *compiler_t, bool found_setter => Option<string>
    string value = EMPTY
    let next = AstToken("NONE")
    let can_continue = true
    if !found_setter do get_eq_or_exit(compiler_t->next(), "[Variable]: Invalid value setter")
    while can_continue
        next = get_next_or_exit(compiler_t->next(), "[Variable]: Invalid value")
        switch next.token
            case TNewLine: do can_continue = false
                if value.size() == 0 doremi None<string>()
                return Some(value)
            default: dobr value += next.name
        ;
    ;
    return None<string>();
;


fn get_type Compiler *compiler_t => Variable
    let next = get_next_or_exit(compiler_t->next(), "[Variable]: Invalid Function Return Value")
    let variable = Variable(true)
    switch next.token
        case TId: dobr variable.v_type = next.name
        case TType: dobr variable.v_type = next.name
        case TNewLine: do break
        default: dobr display_err_message("[Variable]: Expected return value type got:\n" + token_to_string(next.token))
    ;
    let tried = try_get(compiler_t->peek(), TLessThan)
    if tried
        if !variable.has_id()
            display_err_message("[Variable]: Variable declaration cannot have template without id:\n" + variable.v_type)
        ;
        next = get_next_or_exit(compiler_t->next(), "[Variable]: Invalid Declaration")
        variable.v_type += next.name
        let can_continue = true
        while can_continue
            next = get_next_or_exit(compiler_t->next(), "[Variable]: Invalid Declaration")
            switch next.token
                case TMoreThan: do can_continue = false
                default: dobr variable.v_type += next.name
            ;
        ;
    ;
    return variable
;

fn construct_args Compiler *compiler_t, Option<string> type_name => VariableNBool
    let variable = Variable()
    if type_name.is_some() do variable.v_type = type_name.value_or("void")
    let is_end = false
    let can_continue = true
    while can_continue
        let next = get_next_or_exit(compiler_t->next(), "[Variable]: Invalid Declaration")
        switch next.token
            case TNewLine: do can_continue = false
            case TCoolArrow: do can_continue = false
                dobr is_end = true
            case TEquals: do can_continue = false
                dobr variable.v_value = get_value(compiler_t, true)
            case TComma: dobr can_continue = false
            case TAsterix: do can_continue = true
                if !variable.has_type()
                    display_err_message("[Variable]: Pointer infront of type not allowed:\n" + variable.v_type)
                ;
                dobr variable.v_type += next.name
            case TLessThan: do can_continue = true
                if !variable.has_id() && !variable.has_type()
                    display_err_message("[Variable]: Variable declaration cannot have template without id and type:\n" + variable.v_type)
                ;
                variable.v_type += "<"
                while true
                    next = get_next_or_exit(compiler_t->next(), "[Variable]: Invalid Declaration")
                    if next.token == TMoreThan
                        variable.v_type += ">"
                        break
                    ;
                    variable.v_type += next.name
                ;
                break
            default: do can_continue = true
                if !variable.has_type() dobr variable.v_type = next.name
                if !variable.has_id() dobr variable.id = next.name
                display_err_message("[Variable]: Variable declaration already complete:\n" + variable.id)
                break
        ;
    ;
    if !variable.has_minimum() && !is_end
        display_err_message("[Variable]: Variable declaration incomplete:\n" + variable.id)
    ;
    return VariableNBool(variable, is_end)
;
