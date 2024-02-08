struct FpFn
    string f_p = ""
    string f_n = ""
    FpFn => do return
    FpFn string f_p, string f_n =>
        this->f_p = f_p
        this->f_n = f_n
    ;
;
fn next_or_exit Compiler *compiler_t, string s => AstToken
    let next = compiler_t->next()
    if next.is_none() do error(s, compiler_t->recap())
    return next.value_or(AstToken())
;
fn try_get Compiler *compiler_t, Token token => bool
    let peek = compiler_t->peek()
    if peek.is_none() doremi false
    return peek.value_or(AstToken()).token == token
;
fn get_or_exit Compiler *compiler_t, Token token, string s => string
    let next = compiler_t->next()
    if next.is_none() || next.value_or(AstToken()).token != token do error(s, compiler_t->recap())
    return next.value_or(AstToken()).name
;
fn id_or_exit Compiler *compiler_t, string s => string doremi get_or_exit(compiler_t, Token::Id, s)
fn eq_or_exit Compiler *compiler_t, string s => string doremi get_or_exit(compiler_t, Token::Equals, s)
fn arrow_or_exit Compiler *compiler_t, string s => string doremi get_or_exit(compiler_t, Token::CoolArrow, s)
fn folder_and_name string file_path => FpFn
    let file_name = ""
    let reversed = ""
    let folder_path = file_path
    loop
        if folder_path.size() == 0 do break
        let ch = folder_path.back()
        folder_path.pop_back()
        if ch == '/' dobr folder_path.push_back('/')
        file_name.push_back(ch)
    ;
    while file_name.size() > 0
        reversed.push_back(file_name.back())
        file_name.pop_back()
    ;
    file_name = reversed
    return FpFn(folder_path, file_name)
;
fn temp_compiler string emulated_str => Compiler
    let ast = ast_create(emulated_str)
    let program = Program()
    return Compiler(&program, ast, 0)
;
