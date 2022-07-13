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
    if !found_setter do get_eq_or_exit(compiler_t->next(), "[Variable]: Invalid value setter")
    while true
        let next = get_next_or_exit(compiler_t->next(), "[Variable]: Invalid value")
        if next.token == TNewLine do break
        value += next.name
    ;
    return value.size() == 0 ? None<string>() : Some(value)
;


fn get_type Compiler *compiler_t => Variable
    let next = get_next_or_exit(compiler_t->next(), "[Variable]: Invalid Function Return Value")
    let variable = Variable(true)
    if any(next.token, {TId, TType}) do variable.v_type = next.name
    elif next.token != TNewLine do display_err_message("[Variable]: Expected return value type got:\n" + token_to_string(next.token))
    let tried = try_get(compiler_t->peek(), TLessThan)
    if tried
        if !variable.has_id() do display_err_message("[Variable]: Variable declaration cannot have template without id:\n" + variable.v_type)
        next = get_next_or_exit(compiler_t->next(), "[Variable]: Invalid Declaration")
        variable.v_type += next.name
        while true
            next = get_next_or_exit(compiler_t->next(), "[Variable]: Invalid Declaration")
            variable.v_type += next.name
            if next.token == TMoreThan do break
        ;
    ;
    tried = try_get(compiler_t->peek(), TAsterix)
    if tried do variable.v_type += get_or_exit(compiler_t->next(), TAsterix, "[Variable] Unexpected error")
    return variable
;

fn construct_args Compiler *compiler_t, Option<string> type_name => VariableNBool
    let variable = Variable()
    if type_name.is_some() do variable.v_type = type_name.value_or("void")
    let is_end = false
    while true
        let next = get_next_or_exit(compiler_t->next(), "[Variable]: Invalid Declaration")
        if any(next.token, {TNewLine, TCoolArrow}) dobr is_end = true
        if next.token == TEquals dobr variable.v_value = get_value(compiler_t, true)
        elif next.token == TComma do break
        elif next.token == TAsterix
            if !variable.has_type() do display_err_message("[Variable]: Pointer infront of type not allowed:\n" + variable.v_type)
            variable.v_type += next.name
        ;
        elif next.token == TLessThan
            if !variable.has_id() && !variable.has_type() do display_err_message("[Variable]: Variable declaration cannot have template without id and type:\n" + variable.v_type)
            variable.v_type += next.name
            while true
                next = get_next_or_exit(compiler_t->next(), "[Variable]: Invalid Declaration")
                variable.v_type += next.name
                if next.token == TMoreThan do break
            ;
        ;
        else
            if !variable.has_type() doco variable.v_type = next.name
            if !variable.has_id() doco variable.id = next.name
            display_err_message("[Variable]: Variable declaration already complete:\n" + variable.id)
        ;
    ;
    if !variable.has_minimum() && !is_end do display_err_message("[Variable]: Variable declaration incomplete:\n" + variable.id)
    return VariableNBool(variable, is_end)
;
