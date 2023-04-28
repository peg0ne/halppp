fn expression_construct Compiler *compiler_t, AstToken first, vector<Variable> local_scope => Expression
    string doing = EMPTY
    string expression = EMPTY
    if first.token == Token::Let doremi get_let_expr(compiler_t, local_scope)
    if first.token == Token::MoreThan doremi get_lambda_expr(compiler_t, local_scope)
    if first.token == Token::Type
        let name = first.name
        if try_get(compiler_t, Token::LessThan)
            let temps = template_construct(compiler_t, true)
            foreach t in temps do name += t
        ;
        return get_let_expr(compiler_t, local_scope, Some(name), true)
    ;
    switch first.token
        case Token::Doco dobr doing = ";\ncontinue "
        case Token::Dobr dobr doing = ";\nbreak "
        case Token::Dore do doing = ";\nreturn "
        case Token::Do dobr expression = "\n"
        case Token::Doremi dobr expression = "\nreturn "
        case Token::Return dobr expression = "return "
        default dobr expression = first.name
    ;
    if first.token == Token::Id
        let found = false
        if String(first.name).starts_with("{") do found = true
        if String(first.name).starts_with("(") do found = true
        else
            foreach v in local_scope
                if v.id == first.name do found = true
            ;
            if !found
                vector<string> c_stds = {
                    "remove", "delete", "continue", "vector",
                    "this", "break", "exit", "cin", "cout"
                }
                foreach stds in c_stds
                    if stds == first.name do found = true
                ;
            ;
        ;
        if !found do display_err_message("[Expression] Variable not declared: " + first.name, compiler_t->to_err_message())
    ;
    loop
        let x = get_next_or_exit(compiler_t, "[Expression] Expression ended unexpectedly")
        if x.token == Token::Eof dobr expression += doing
        if x.token == Token::NewLine
            let is_member = false
            select peeked from compiler_t->peek()
                let S = String(peeked.name)
                is_member = S.starts_with(".") || S.starts_with("->")
            ;
            if !is_member dobr expression += doing
        ;
        if any(x.token, {Token::Number, Token::Id}) do expression += " "
        if x.is_do() do expression += "\n"
        switch x.token
            case Token::Do do break
            case Token::Dore dobr doing = ";\nreturn "
            case Token::Dobr dobr doing = ";\nbreak "
            case Token::Doco dobr doing = ";\ncontinue "
            case Token::Doremi dobr expression += "return "
            case Token::Let dobr expression += "auto"
            case Token::Return dobr expression += "return "
            case Token::New dobr expression += "new "
            default dobr expression += x.name
        ;
    ;
    return Expression(expression)
;

fn get_let_expr Compiler *compiler_t, vector<Variable> local_scope => Expression doremi get_let_expr(compiler_t, local_scope, None<string>(), false)
fn get_let_expr Compiler *compiler_t, vector<Variable> local_scope, Option<string> type, bool is_type => Expression
    let id = get_id_or_exit(compiler_t, "[Let] Required id after let")
    if is_type && try_get(compiler_t, Token::NewLine)
        get_next_or_exit(compiler_t, "[Let] Expected Newline")
        select t from type doremi Expression(Variable(id, t))
    ;
    get_or_exit(compiler_t, Token::Equals,"[Let] Required equals after id")
    string variable_type = EMPTY
    string expression = EMPTY
    string value = EMPTY
    loop
        let x = get_next_or_exit(compiler_t, "LET exception")
        if x.token == Token::Eof do break
        if x.token == Token::NewLine
            let is_member = false
            select peeked from compiler_t->peek()
                is_member = String(peeked.name).starts_with(".")
            ;
            if !is_member do break
        ;
        value += x.name
        if x.token == Token::New do value += " "
    ;
    let token = Token_t(value)
    if token.is_bool() do variable_type = "bool "
    elif token.is_num() do variable_type = "int "
    elif token.is_float() do variable_type = "float "
    elif token.is_char() do variable_type = "char "
    elif token.is_string() do variable_type = "string "
    else do variable_type = "auto "
    select t from type do variable_type = t
    let v = Variable(id, variable_type, Some(value), VariableState::Private)
    expression += id + " = " + value
    return Expression(v)
;

fn get_lambda_expr Compiler *compiler_t, vector<Variable> local_scope => Expression
    let id = get_id_or_exit(compiler_t, "[Lambda] Required id after >")
    string base = ""
    let has_return = false
    vector<string> parameters = {}
    string args = ""
    loop
        let x = get_next_or_exit(compiler_t, "[Lambda] Incomplete lambda")
        if x.token == Token::Id && String(x.name).starts_with("(")
            args = x.name
            break
        ;
        switch x.token
        case Token::Id dobr parameters.push_back(x.name)
        default dobr display_err_message("[Lambda] Incorrect parameter value", compiler_t->to_err_message())
        ;
        x = get_next_or_exit(compiler_t, "[Lambda] Incomplete lambda")
        if x.token == Token::Id && String(x.name).starts_with("(")
            args = x.name
            break
        ;
        if x.token == Token::Comma doco parameters.push_back(",")
        display_err_message("[Lambda] Comma missing", compiler_t->to_err_message())
    ;
    base += "["
    foreach p in parameters do base += p
    base += "]"
    base += args
    base += "{"
    let x = get_next_or_exit(compiler_t, "[Lambda] Incomplete lambda")
    if x.is_do()
        has_return = x.token == Token::Doremi
        let expr = expression_construct(compiler_t, x, {})
        base += expr.to_cpp(2)
    ;
    elif x.token == Token::NewLine
        loop
            x = get_next_or_exit(compiler_t, "[Lambda] Incomplete lambda")
            if x.token == Token::SemiColon do break
            if x.token == Token::Return do has_return = true
            if x.is_nl() do continue
            switch x.token
            case Token::Foreach
            case Token::For dobr base += for_construct(compiler_t, x.token == Token::Foreach, {}).to_cpp(2)
            case Token::Condition dobr base += condition_construct(compiler_t, x.name, {}).to_cpp(2)
            case Token::Switch dobr base += switch_construct(compiler_t, {}).to_cpp(2)
            case Token::Select dobr base += select_construct(compiler_t, {}).to_cpp(2)
            default dobr base += expression_construct(compiler_t, x, {}).to_cpp(2)
            ;
        ;
    ;
    if !has_return do base += "return true;"
    base += "}"
    let v = Variable(id, "auto", Some(base), VariableState::Private)
    return Expression(v)
;