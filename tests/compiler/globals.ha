fn global_construct Compiler *compiler_t => Global
    let global = Global()
    let variable = Variable()
    get_arrow_or_exit(compiler_t->next(), "[Global]: Requires => after glob keyword")
    loop
        let x = get_next_or_exit(compiler_t->next(), "[Global]: Unexpected end of global")
        if any(x.token, {TSemiColon, TEof}) dobr try_add_variable(compiler_t, &global, variable)
        if x.token == TNewLine
            try_add_variable(compiler_t, &global, variable)
            doco variable = Variable()
        ;
        if !variable.has_type() do variable.v_type = x.name
        elif !variable.has_id() do variable.id = x.name
        else do display_err_message("[Global]: Variable is already finished")
    ;
    compiler_t->add_glob(global)
    return global
;

fn try_add_variable Compiler *compiler_t, Global *global, Variable variable =>
    if !variable.has_minimum() do return
    for i until global->variables.size() 
        let v = global->variables.at(i)
        if v.v_type == variable.v_type
            display_err_message("[Global]: Multiple declarations of same value")
        ;
    ;
    if compiler_t->has_glob(variable.v_type)
        display_err_message("[Global]: Multiple declarations of same value")
    ;
    global->variables.push_back(variable)
;