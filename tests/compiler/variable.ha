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
    if !found_setter do get_eq_or_exit(compiler_t->next(), VAR_ERR_SET)
    loop
        let next = get_next_or_exit(compiler_t->next(), VAR_ERR_VAL)
        if next.token == Token::NewLine do break
        value += next.name
    ;
    return value.size() == 0 ? None<string>() : Some(value)
;


fn get_type Compiler *compiler_t => Variable
    let next = get_next_or_exit(compiler_t->next(), VAR_ERR_NON)
    let variable = Variable(true)
    if any(next.token, {Token::Id, Token::Type}) do variable.v_type = next.name
    elif next.token != Token::NewLine do display_err_message(VAR_ERR_TYP + to_string(next.token))
    let tried = try_get(compiler_t->peek(), Token::LessThan)
    if tried
        if !variable.has_id()
            display_err_message(VAR_ERR_TEM + variable.v_type)
        ;
        next = get_next_or_exit(compiler_t->next(), VAR_ERR_INV)
        variable.v_type += next.name
        loop
            next = get_next_or_exit(compiler_t->next(), VAR_ERR_INV)
            variable.v_type += next.name
            if next.token == Token::MoreThan do break
        ;
    ;
    tried = try_get(compiler_t->peek(), Token::Asterix)
    if tried do variable.v_type += get_or_exit(compiler_t->next(), Token::Asterix, VAR_ERR_NON)
    return variable
;

fn construct_args Compiler *compiler_t => VariableNBool doremi construct_args(compiler_t, None<string>())
fn construct_args Compiler *compiler_t, Option<string> type_name => VariableNBool
    let variable = Variable()
    if type_name.is_some() do variable.v_type = type_name.value_or(VOID)
    let is_end = false
    loop
        let next = get_next_or_exit(compiler_t->next(), VAR_ERR_INV)
        if any(next.token, {Token::NewLine, Token::CoolArrow}) dobr is_end = true
        if next.token == Token::Equals dobr variable.v_value = get_value(compiler_t, true)
        elif next.token == Token::Comma do break
        elif next.token == Token::Asterix
            if !variable.has_type() do display_err_message(VAR_ERR_POI + variable.v_type)
            variable.v_type += next.name
        ;
        elif next.token == Token::LessThan
            if !variable.has_id() && !variable.has_type() do display_err_message(VAR_ERR_TEM + variable.v_type)
            variable.v_type += next.name
            loop
                next = get_next_or_exit(compiler_t->next(), VAR_ERR_INV)
                variable.v_type += next.name
                if next.token == Token::MoreThan do break
            ;
        ;
        else
            if !variable.has_type() doco variable.v_type = next.name
            if !variable.has_id() doco variable.id = next.name
            display_err_message(VAR_ERR_COM + variable.id)
        ;
    ;
    if !variable.has_minimum() && !is_end do display_err_message(VAR_ERR_INC + variable.id)
    return VariableNBool(variable, is_end)
;
