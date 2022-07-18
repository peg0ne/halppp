fn template_construct Compiler *compiler_t => vector<string>
    vector<string> templates = {}
    loop
        let next = get_next_or_exit(compiler_t->next(), "[Template]: Template declaration invalid")
        if next.token == Token::Id doco templates.push_back(next.name)
        elif any(next.token, {Token::Comma, Token::LessThan}) do continue
        elif next.token == Token::MoreThan do break
        display_err_message("[Template]: Token not allowed: " + next.name)
    ;
    return templates
;
