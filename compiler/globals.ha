fn global_construct Compiler *compiler_t => Global
    let global = Global()
    let variables = get_variables(compiler_t)
    foreach i in variables do try_add_variable(compiler_t, &global, i)
    compiler_t->add_glob(global)
    return global
;

fn get_variables Compiler *compiler_t => vector<Variable>
    vector<Variable> variables = {}
    let variable = Variable()
    loop
        let x = get_next_or_exit(compiler_t, "[Global]: Unexpected end of global")
        switch x.token
            case Token::Eof
            case Token::SemiColon doremi variables
            case Token::NewLine
                variables.push_back(variable)
                variable = Variable()
                break
            default
                if !variable.has_type() dobr variable.v_type = x.name
                elif !variable.has_id() dobr variable.id = x.name
                display_err_message("[Global]: Variable is already finished", compiler_t->to_err_message())
        ;
    ;
;
fn try_add_variable Compiler *compiler_t, Global *global, Variable variable =>
    if !variable.has_minimum() do return
    foreach v in global->variables
        if v.v_type == variable.v_type
            display_err_message("[Global]: Multiple declarations of same value", compiler_t->to_err_message())
        ;
    ;
    if compiler_t->has_glob(variable.v_type)
        display_err_message("[Global]: Multiple declarations of same value", compiler_t->to_err_message())
    ;
    global->variables.push_back(variable)
;

