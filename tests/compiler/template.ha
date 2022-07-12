fn template_construct Compiler *compiler_t => vector<string>
    vector<string> templates = {}
    let can_continue = true
    while can_continue
        let next = get_next_or_exit(compiler_t->next(), "[Template]: Template declaration invalid")
        switch next.token
            case TId: dobr templates.push_back(next.name)
            case TComma: do break
            case TLessThan: do break
            case TMoreThan: dobr can_continue = false
            default: dobr display_err_message("[Template]: Token not allowed: " + next.name)
        ;
    ;
    return templates
;
