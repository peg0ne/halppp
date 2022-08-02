fn imports_construct Compiler *compiler_t => vector<string>
    get_arrow_or_exit(compiler_t, "[Import]: Missing [=>] in declaration")
    return imports_construct_impl(compiler_t)
;
fn imports_construct_impl Compiler *compiler_t => vector<string>
    vector<string> imports = {}
    string id = EMPTY
    loop
        let next = get_next_or_exit(compiler_t, "[Import]: Import declaration invalid")
        if any(next.token, {Token::Eof, Token::NewLine, Token::Comma, Token::RBrack})
            if id.size() > 0 && !imports_check_duplicate(imports, id) do imports.push_back(id)
            id = EMPTY
        ;
        elif next.token == Token::LBrack
            let combined = imports_construct_impl(compiler_t)
            foreach i in combined
                let base = id
                base += i
                imports.push_back(base)
            ;
            id = EMPTY
        ;
        elif next.is_base() do display_err_message("[Import]: Token not allowed: " + next.name, compiler_t->to_err_message())
        else do id += next.name
        if any(next.token, {Token::Eof, Token::NewLine, Token::RBrack}) do break
    ;
    return imports
;

fn imports_creation Compiler *compiler_t, AstToken next => vector<string>
    let import = imports_construct(compiler_t)
    vector<int> remove = {}
    let contains = false
    for i until import.size()
        let imp = import.at(i)
        switch next.token
        case Token::Use
            if compiler_t->has_use(imp)
                display_hint_message("[Use]: Duplicate entry of: " + imp)
                remove.push_back(i)
            ;
            break
        case Token::Include
            if compiler_t->has_inc(imp)
                display_hint_message("[Include]: Duplicate entry of: " + imp)
                remove.push_back(i)
            ;
            break
        case Token::Get
            if compiler_t->has_get(imp)
                display_hint_message("[Get]: Duplicate entry of: " + imp)
                remove.push_back(i)
            ;
            break
        default dobr display_err_message("[" + to_string(next.token) + "]: Unhandled import", compiler_t->to_err_message())
        ;
    ;
    vector<string> import_buf = {}
    for i until import.size()
        let found = false
        foreach j in remove
            if i == j do found = true
        ;
        if !found do import_buf.push_back(import.at(i))
    ;
    import = import_buf
    switch next.token
    case Token::Use dobr compiler_t->add_use(import)
    case Token::Include dobr compiler_t->add_inc(import)
    case Token::Get dobr compiler_t->add_get(import)
    default dobr display_err_message("[" + to_string(next.token) + "]: Unhandled import", compiler_t->to_err_message())
    ;
    return import
;

fn imports_check_duplicate vector<string> imports, string id => bool
    foreach imp in imports
        if imp == id
            display_hint_message("[Import]: Token duplicate in entry " + id)
            return true
        ;
    ;
    return false
;
