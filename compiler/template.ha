fn template_construct Compiler *compiler_t => vector<string>
    vector<string> templates = {}
    let pre_text = ""
    let is_comma = true
    loop
        let next = next_or_exit(compiler_t, "[Template]: Template declaration invalid")
        if next.is_id()
            if is_comma
                templates.push_back(pre_text + next.name)
                pre_text = ""
                is_comma = false
                continue
            ;
            error($"[Template]: Expected ',' got: {next.name}", compiler_t->recap())
        ;
        elif next.token == Token::TriplePeriod
            if is_comma doco pre_text = next.name
            error($"[Template]: Expected ',' got: {next.name}", compiler_t->recap())
        ;
        elif next.token == Token::Comma doco is_comma = true
        elif next.token == Token::MoreThan do break
        error($"[Template]: Unecpected token: {next.name}", compiler_t->recap())
    ;
    return templates
;