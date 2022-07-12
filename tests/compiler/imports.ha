fn imports_check_duplicate vector<string> imports, string id => bool
    for i until imports.size()
        if imports.at(i) == id
            display_hint_message("[Import]: Token duplicate in entry " + id)
            return true
        ;
    ;
    return false
;

fn imports_construct Compiler *compiler_t => vector<string>
    vector<string> imports = {}
    get_arrow_or_exit(compiler_t->next(), "[Import]: Missing [=>] in declaration")
    string id = EMPTY
    let can_continue = true
    while can_continue
        let next = get_next_or_exit(compiler_t->next(), "[Import]: Import declaration invalid")
        switch next.token
            case TEof: do can_continue = false
            case TNewLine: do can_continue = false
                if !imports_check_duplicate(imports, id) do imports.push_back(id)
                break
            case TComma: do can_continue = true
                if !imports_check_duplicate(imports, id) do imports.push_back(id)
                id = EMPTY
                break;
            default: do can_continue = true
                if next.t.is_base() do display_err_message("[Import]: Token not allowed: " + next.name)
                id += next.name
                break
        ;
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
