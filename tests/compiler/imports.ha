fn imports_construct Compiler compiler_t => vector<string>
    vector<string> imports = {}
    get_arrow_or_exit(compiler_t.next(), "[Import]: Missing [=>] in declaration")
    string id = EMPTY
    return imports
;

fn imports_creation Compiler compiler_t, AstToken next => vector<string>
    let import = imports_construct(compiler_t)
    return import
;
