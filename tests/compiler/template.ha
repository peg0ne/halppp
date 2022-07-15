fn template_construct Compiler *compiler_t => vector<string>
    vector<string> templates = {}
    loop
        let next = get_next_or_exit(compiler_t->next(), "[Template]: Template declaration invalid")
        if next.token == TId doco templates.push_back(next.name)
        elif any(next.token, {TComma, TLessThan}) do continue
        elif next.token == TMoreThan do break
        display_err_message("[Template]: Token not allowed: " + next.name)
    ;
    return templates
;
