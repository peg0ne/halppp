fn template_construct Compiler *compiler_t => vector<string> doremi template_construct(compiler_t, false)
fn template_construct Compiler *compiler_t, bool add_all => vector<string>
    vector<string> templates = {}
    let depth = 0
    loop
        let next = get_next_or_exit(compiler_t, "[Template]: Template declaration invalid")
        if next.is_id() doco templates.push_back(next.name)
        elif next.token == Token::Type doco templates.push_back(next.name)
        elif any(next.token, {Token::Comma, Token::LessThan})
            if add_all do templates.push_back(next.name)
            if next.token == Token::LessThan do depth++
            continue
        ;
        elif next.token == Token::MoreThan
            if add_all do templates.push_back(next.name)
            depth--
            if depth <= 0 do break
            continue
        ;
        elif next.token == Token::DblMoreThan
            if add_all do templates.push_back(next.name)
            depth -= 2
            if depth <= 0 do break
            continue
        ;
        elif next.token == Token::AllMoreThan
            if add_all do templates.push_back(next.name)
            depth -= 3
            if depth <= 0 do break
            continue
        ;
        elif next.token == Token::Member
            for i until 2 do get_or_exit(compiler_t, Token::Member, "[Template] Expected ...Args")
            let id = get_id_or_exit(compiler_t, "[Template] Expected Id")
            templates.push_back("..." + id)
            continue
        ;
        elif next.token == Token::Asterix doco templates.push_back(next.name)
        display_err_message("[Template]: Token not allowed: " + next.name, compiler_t->to_err_message())
    ;
    return templates
;