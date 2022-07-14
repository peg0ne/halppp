fn imports_construct Compiler *compiler_t => vector<string>
    get_arrow_or_exit(compiler_t->next(), "[Import]: Missing [=>] in declaration")
    return imports_construct_impl(compiler_t)
;
fn imports_construct_impl Compiler *compiler_t => vector<string>
    vector<string> imports = {}
    string id = EMPTY
    loop
        let next = get_next_or_exit(compiler_t->next(), "[Import]: Import declaration invalid")
        if any(next.token, {TEof, TNewLine, TComma, TRBrack})
            if id.size() > 0 && !imports_check_duplicate(imports, id) do imports.push_back(id)
            id = EMPTY
        ;
        elif next.token == TLBrack
            let combined = imports_construct_impl(compiler_t)
            for i until combined.size()
                let base = id
                base += combined.at(i)
                imports.push_back(base)
            ;
            id = EMPTY
        ;
        elif next.t.is_base() do display_err_message("[Import]: Token not allowed: " + next.name)
        else do id += next.name
        if any(next.token, {TEof, TNewLine, TRBrack}) do break
    ;
    return imports
;

fn imports_creation Compiler *compiler_t, AstToken next => vector<string>
    let import = imports_construct(compiler_t)
    let import_return = import
    let found = false
    let contains = false
    for i until import.size()
        let imp = import.at(i)
        switch next.token
            case TUse: do contains = compiler_t->contains_use(imp)
                if contains
                    display_hint_message("[Use]: Duplicate entry of: " + token_to_string(next.token))
                    found = true
                ;
                break
            case TInclude: do contains = compiler_t->contains_inc(imp)
                if contains
                    display_hint_message("[Include]: Duplicate entry of: " + token_to_string(next.token))
                    found = true
                ;
                break
            case TGet: do break
            default: dobr display_err_message("[" + token_to_string(next.token) + "]: Unhandled import")
        ;
    ;
    if !found
        switch next.token
            case TUse: dobr compiler_t->add_use(import)
            case TInclude: dobr compiler_t->add_inc(import)
            case TGet: do break
            default: dobr display_err_message("[" + token_to_string(next.token) + "]: Unhandled import")
        ;
    ;
    return import_return
;

fn imports_check_duplicate vector<string> imports, string id => bool
    for i until imports.size()
        if imports.at(i) == id
            display_hint_message("[Import]: Token duplicate in entry " + id)
            return true
        ;
    ;
    return false
;