fn template_construct Compiler *compiler_t => vector<string>
    vector<string> templates = {}
    while true
        let next = get_next_or_exit(compiler_t->next(), "[Template]: Template declaration invalid")
        if next.token == TMoreThan do break
        if next.token == TId do templates.push_back(next.name)
        if any(next.token, {TComma, TLessThan, TId}) do continue
        display_err_message("[Template]: Token not allowed: " + next.name)
    ;
    return templates
;
