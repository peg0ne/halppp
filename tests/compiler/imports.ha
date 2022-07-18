fn imports_construct Compiler *compiler_t => vector<string>
    get_arrow_or_exit(compiler_t->next(), "[Import]: Missing [=>] in declaration")
    return imports_construct_impl(compiler_t)
;
fn imports_construct_impl Compiler *compiler_t => vector<string>
    vector<string> imports = {}
    string id = EMPTY
    loop
        let next = get_next_or_exit(compiler_t->next(), "[Import]: Import declaration invalid")
        if any(next.token, {Token::Eof, Token::NewLine, Token::Comma, Token::RBrack})
            if id.size() > 0 && !imports_check_duplicate(imports, id) do imports.push_back(id)
            id = EMPTY
        ;
        elif next.token == Token::LBrack
            let combined = imports_construct_impl(compiler_t)
            for i until combined.size()
                let base = id
                base += combined.at(i)
                imports.push_back(base)
            ;
            id = EMPTY
        ;
        elif next.is_base() do display_err_message("[Import]: Token not allowed: " + next.name)
        else do id += next.name
        if any(next.token, {Token::Eof, Token::NewLine, Token::RBrack}) do break
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
        if next.token == Token::Use
            contains = compiler_t->has_use(imp)
            if contains
                display_hint_message("[Use]: Duplicate entry of: " + to_string(next.token))
                found = true
            ;
            continue
        ;
        elif next.token == Token::Include
            contains = compiler_t->has_inc(imp)
            if contains
                display_hint_message("[Include]: Duplicate entry of: " + to_string(next.token))
                found = true
            ;
            continue
        ;
        elif next.token == Token::Get do continue
        display_err_message("[" + to_string(next.token) + "]: Unhandled import")
    ;
    if !found
        if next.token == Token::Use do compiler_t->add_use(import)
        elif next.token == Token::Include do compiler_t->add_inc(import)
        elif next.token == Token::Get do return import_return
        else do display_err_message("[" + to_string(next.token) + "]: Unhandled import")
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