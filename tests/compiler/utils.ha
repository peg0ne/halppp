struct FpFn
    string f_p = EMPTY
    string f_n = EMPTY
    FpFn =>
    ;
    FpFn string f_p, string f_n =>
        f_p = f_p
        f_n = f_n
    ;
;

fn get_next_or_exit ClassOption<AstToken> next, string s => AstToken
    if next.is_none() do display_err_message(s)
    return next.value_or(AstToken())
;
fn try_get ClassOption<AstToken> peek, Token token => bool
    if peek.is_none() doremi false
    return peek.value_or(AstToken()).token == token
;
fn get_or_exit ClassOption<AstToken> next, Token token, string s => string
    if next.is_none() || next.value_or(AstToken()).token != token do display_err_message(s)
    return next.value_or(AstToken()).name
;
fn get_id_or_exit ClassOption<AstToken> next, string s => string doremi get_or_exit(next, TId, s)
fn get_arrow_or_exit ClassOption<AstToken> next, string s => string doremi get_or_exit(next, TCoolArrow, s)
fn get_eq_or_exit ClassOption<AstToken> next, string s => string doremi get_or_exit(next, TEquals, s)
fn get_folder_and_name string file_path => FpFn
    string file_name = EMPTY
    string folder_path = file_path
    while true
        let i = folder_path.size()
        if i == 0 do break
        let ch = folder_path.back()
        folder_path.pop_back()
        if ch == '/' dobr folder_path.push_back('/')
        file_name.push_back(ch)
    ;
    string reversed = EMPTY
    while file_name.size() > 0
        reversed.push_back(file_name.back())
        file_name.pop_back()
    ;
    file_name = reversed
    return FpFn(folder_path, file_name)
;
