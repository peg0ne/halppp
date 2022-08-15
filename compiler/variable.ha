struct VariableNBool
    Variable variable = Variable()
    bool is_end = false
    VariableNBool Variable v, bool is_end =>
        this->variable = v
        this->is_end = is_end
    ;
;

fn get_value Compiler *compiler_t, bool found_setter => Option<string> doremi get_value(compiler_t, found_setter, false)
fn get_value Compiler *compiler_t, bool found_setter, bool in_args => Option<string>
    string value = EMPTY
    if !found_setter do get_eq_or_exit(compiler_t, VAR_ERR_SET)
    loop
        let next = get_next_or_exit(compiler_t, VAR_ERR_VAL)
        if next.is_nl() do break
        if in_args && any(next.token, {Token::Comma, Token::CoolArrow}) do break
        value += next.name
        if next.token == Token::New do value += " "
    ;
    return value.size() == 0 ? None<string>() : Some(value)
;


fn get_type Compiler *compiler_t => Variable
    let next = get_next_or_exit(compiler_t, VAR_ERR_NON)
    let variable = Variable(true)
    if any(next.token, {Token::Id, Token::Type}) do variable.v_type = next.name
    elif next.token != Token::NewLine do display_err_message(VAR_ERR_TYP + to_string(next.token), compiler_t->to_err_message())
    let tried = try_get(compiler_t, Token::LessThan)
    if tried
        if !variable.has_id()
            display_err_message(VAR_ERR_TEM + variable.v_type, compiler_t->to_err_message())
        ;
        next = get_next_or_exit(compiler_t, VAR_ERR_INV)
        variable.v_type += next.name
        loop
            next = get_next_or_exit(compiler_t, VAR_ERR_INV)
            variable.v_type += next.name
            if next.token == Token::MoreThan do break
        ;
    ;
    tried = try_get(compiler_t, Token::Asterix)
    if tried do variable.v_type += get_or_exit(compiler_t, Token::Asterix, VAR_ERR_NON)
    return variable
;

fn construct_args Compiler *compiler_t => VariableNBool doremi construct_args(compiler_t, None<string>(), false)
fn construct_args Compiler *compiler_t, bool is_func => VariableNBool doremi construct_args(compiler_t, None<string>(), is_func)
fn construct_args Compiler *compiler_t, Option<string> type_name => VariableNBool doremi construct_args(compiler_t, type_name, false)
fn construct_args Compiler *compiler_t, Option<string> type_name, bool is_func => VariableNBool
    let variable = Variable()
    select t from type_name do variable.v_type = t
    let is_end = false
    loop
        let next = get_next_or_exit(compiler_t, VAR_ERR_INV)
        if any(next.token, {Token::NewLine, Token::CoolArrow}) dobr is_end = true
        if next.token == Token::Equals
            variable.v_value = get_value(compiler_t, true, is_func)
            if is_func
                select prev from compiler_t->prev()
                    is_end = prev.token == Token::CoolArrow
                ;
                compiler_t->next()
            ;
            break
        ;
        elif next.token == Token::Comma do break
        elif next.token == Token::Asterix
            if !variable.has_type() do display_err_message(VAR_ERR_POI + variable.v_type, compiler_t->to_err_message())
            variable.v_type += next.name
        ;
        elif next.token == Token::LessThan
            if !variable.has_id() && !variable.has_type() do display_err_message(VAR_ERR_TEM + variable.v_type, compiler_t->to_err_message())
            variable.v_type += next.name
            loop
                next = get_next_or_exit(compiler_t, VAR_ERR_INV)
                variable.v_type += next.name
                if next.token == Token::MoreThan do break
            ;
        ;
        else
            if !variable.has_type() doco variable.v_type = next.name
            if !variable.has_id() doco variable.id = next.name
            display_err_message(VAR_ERR_COM, compiler_t->to_err_message())
        ;
    ;
    if !variable.has_minimum() && !is_end do display_err_message(VAR_ERR_INC + variable.id, compiler_t->to_err_message())
    return VariableNBool(variable, is_end)
;


