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
    if next.is_none() do error(s, compiler_t->recap())
    let got = next.value_or(AstToken())
    if got.token != token
        if token == Token::Id do s += keyword_note(got)
        error(s, compiler_t->recap())
    ;
    return got.name
;
// ` (`def` is a keyword)` when a word was lexed as a keyword where a name was expected
fn keyword_note AstToken t => string
    if t.token == Token::Id || t.token == Token::Type || t.name.size() == 0 doremi EMPTY
    foreach c in t.name
        if !isalpha(c) && c != '_' doremi EMPTY
    ;
    return $" (`{t.name}` is a keyword and can't be used as a name)"
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
        if any(ch, {'/', '\\'}) dobr folder_path.push_back(ch)
        file_name.push_back(ch)
    ;
    while file_name.size() > 0
        reversed.push_back(file_name.back())
        file_name.pop_back()
    ;
    file_name = reversed
    return FpFn(folder_path, file_name)
;
// Concatenate a token onto generated code without letting operators merge:
// `a - -1` must not become `a--1`, nor `a + +b` become `a++b`
fn join_token string code, string token => string
    if code.size() == 0 || token.size() == 0 doremi code + token
    let last = code.back()
    let first = token.front()
    if last == first && any(last, {'-', '+'}) doremi code + " " + token
    return code + token
;
fn temp_compiler string emulated_str => Compiler
    let ast = ast_create(emulated_str)
    // Shared scratch program: must outlive the returned Compiler
    raw static Program program;
    return Compiler(&program, ast, 0)
;

// A block reached the end of the file without its closing ;
fn unclosed_error Compiler *compiler_t, string what, int line =>
    error($"{what} starting on line {line} is not closed: end its block with ;", compiler_t->recap())
;
