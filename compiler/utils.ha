struct FpFn
    string f_p = EMPTY
    string f_n = EMPTY
    FpFn => do return
    FpFn string f_p, string f_n =>
        this->f_p = f_p
        this->f_n = f_n
    ;
;
fn get_next_or_exit Option<AstToken> next, string s => AstToken
    if next.is_none() do display_err_message(s)
    return next.value_or(AstToken())
;
fn try_get Option<AstToken> peek, Token token => bool
    if peek.is_none() doremi false
    return peek.value_or(AstToken()).token == token
;
fn get_or_exit Option<AstToken> next, Token token, string s => string
    if next.is_none() || next.value_or(AstToken()).token != token do display_err_message(s)
    return next.value_or(AstToken()).name
;
fn get_id_or_exit Option<AstToken> next, string s => string doremi get_or_exit(next, Token::Id, s)
fn get_arrow_or_exit Option<AstToken> next, string s => string doremi get_or_exit(next, Token::CoolArrow, s)
fn get_eq_or_exit Option<AstToken> next, string s => string doremi get_or_exit(next, Token::Equals, s)
fn get_folder_and_name string file_path => FpFn
    string file_name = EMPTY
    string reversed = EMPTY
    string folder_path = file_path
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
