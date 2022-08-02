fn template_construct Compiler *compiler_t => vector<string>
    vector<string> templates = {}
    loop
        let next = get_next_or_exit(compiler_t, "[Template]: Template declaration invalid")
        if next.is_id() doco templates.push_back(next.name)
        elif any(next.token, {Token::Comma, Token::LessThan}) do continue
        elif next.token == Token::MoreThan do break
        display_err_message("[Template]: Token not allowed: " + next.name, compiler_t->to_err_message())
    ;
    return templates
;


