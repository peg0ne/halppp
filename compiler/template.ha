fn template_construct Compiler *compiler_t => vector<string>
    vector<string> templates = {}
    string pre_text = EMPTY
    let is_comma = true
    loop
        let next = get_next_or_exit(compiler_t, "[Template]: Template declaration invalid")
        if next.is_id()
            if is_comma
                templates.push_back(pre_text + next.name)
                pre_text = EMPTY
                is_comma = false
                continue
            ;
            display_err_message("[Template]: Expected ',' got: " + next.name, compiler_t->to_err_message())
        ;
        elif next.token == Token::TriplePeriod
            if is_comma doco pre_text = next.name
            display_err_message("[Template]: Expected ',' got: " + next.name, compiler_t->to_err_message())
        ;
        elif next.token == Token::Comma doco is_comma = true
        elif next.token == Token::MoreThan do break
        display_err_message("[Template]: Unecpected token: " + next.name, compiler_t->to_err_message())
    ;
    return templates
;