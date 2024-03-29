get => ast_helpers

fn ast_create string content => vector<AstToken>
    vector<char> vec = {}
    foreach i in content do vec.push_back(i)
    let peekable = Peekable<char>(vec)
    string id = EMPTY
    vector<AstToken> ast = {}
    loop
        try_append_raw(peekable, ast)
        if next_is_none(peekable) dobr try_add_token(id, ast, peekable)
        let c = peekable.next().value_or(' ')
        let last_known_index = peekable.index()
        select pair from try_get_pair(peekable, c)
            id = try_add_token(id, ast, peekable)
            doco try_add_token(pair, ast, peekable)
        ;
        select concat from try_get_concat(peekable, c)
            id = try_add_token(id, ast, peekable)
            doco try_add_token(concat, ast, peekable)
        ;
        select matching from try_get_matching(peekable, c)
            id = try_add_token(id, ast, peekable)
            doco try_add_token(matching, ast, peekable)
        ;
        select adv_condition from try_get_advanced_condition(peekable, id, c)
            id = try_add_token(adv_condition, ast, peekable)
            peekable.next()
            peekable.next()
            continue
        ;
        select num from try_get_num(peekable, c)
            id = try_add_token(id, ast, peekable)
            doco ast.push_back(num)
        ;
        string ch(1, c)
        if !is_both_token(id, c)
            id = try_add_token(id, ast, peekable)
            if peekable.index() != last_known_index do continue
            if !is_white_space(c) doco id += ch
        ;
        if is_both_token(id, c) && is_str_tokens(id + ch) doco id += ch
        elif is_char_token(c)
            id = try_add_token(id, ast, peekable)
            if peekable.index() != last_known_index do continue
            doco ast.push_back(AstToken(c))
        ;
        elif is_white_space(c)
            id = try_add_token(id, ast, peekable)
            if c == '\n' do ast.push_back(AstToken("\n"))
            continue
        ;
        id += ch
    ;
    // "Push extra sets of EOF to ensure it wont break badly"
    ast.push_back(AstToken("EOF"))
    ast.push_back(AstToken("EOF"))
    ast.push_back(AstToken("EOF"))
    ast.push_back(AstToken("EOF"))
    ast.push_back(AstToken("EOF"))
    ast.push_back(AstToken("EOF"))
    return ast
;

fn try_add_token string id, vector<AstToken> &ast, Peekable<char> &peekable => string
    if id.size() == 0 doremi id
    if id == "//"
        loop
            let next = peekable.next().value_or('\n')
            if next == '\n' do break
        ;
        id = "\n"
    ;
    ast.push_back(AstToken(id))
    return EMPTY
;

fn is_str_tokens string s => bool
    if s.size() == 0 doremi false
    foreach i in s
        if !is_char_token(i) doremi false
    ;
    return !Token_t(s).is_id()
;
fn is_char_token char ch => bool
    string s(1,ch)
    return !Token_t(s).is_id()
;
fn is_char_number_t char ch => bool
    string s(1,ch)
    return Token_t(s).is_num()
;
fn try_get_dbl Peekable<char> *peekable, char ch => Option<string>
    let peek = peekable->peek()
    if peek.is_none() || peek.value_or(' ') != ch doremi None<string>()
    peekable->next()
    string dbl(1, ch)
    return Some(dbl + dbl)
;

fn get_pair Peekable<char> *peekable, char ch, char endch => string
    let escaped = false
    string matching(1, ch)
    loop
        let c_opt = peekable->next()
        if c_opt.is_none() doremi matching
        let c = c_opt.value_or(' ')
        if c == '$' && peekable->peek().value_or(' ') == '"'
            matching += get_concat(peekable)
            continue
        ;
        string matchbuf(1, c)
        if c == '\'' doco matching += get_matching(peekable, '\'')
        elif c == '"' doco matching += get_matching(peekable, '"')
        elif c == ch doco matching += get_pair(peekable, ch, endch)
        matching += matchbuf
        if c == endch doremi matching
    ;
;

fn get_matching Peekable<char> *peekable, char ch => string
    let escaped = false
    string matching(1, ch)
    loop
        let c_opt = peekable->next()
        if c_opt.is_none() doremi matching
        let c = c_opt.value_or(' ')
        string matchbuf(1, c)
        matching += matchbuf
        if c == ch && !escaped doremi matching
        escaped = !escaped && c == '\\'
    ;
;

fn get_concat Peekable<char> *peekable => string
    peekable->next()
    string concat = "\""
    let escaped = false
    loop
        let c_opt = peekable->next()
        if c_opt.is_none() doremi concat
        let c = c_opt.value_or(' ')
        if c == '{' && !escaped
            concat += "\" + to_string("
        ;
        elif c == '}' && !escaped
            concat += ") + \""
        ;
        else do concat += c
        if c == '"' && !escaped doremi concat
        escaped = !escaped && c == '\\'
    ;
;

fn collect_num Peekable<char> *peekable, char ch => AstToken
    string num(1, ch)
    let is_float = false
    let token = AstToken()
    loop
        let peeked = peekable->peek().value_or(' ')
        if !is_char_number_t(peeked) && peeked != '.'
            token.name = num
            token.token = is_float ? Token::Float : Token::Number 
            token.t = Token_t("0")
            token.t.t = is_float ? Token::Float : Token::Number
            return token
        ;
        if peeked == '.' do is_float = true
        peekable->next()
        string numbuf(1, peeked)
        num += numbuf
    ;
;

fn try_collect_raw Peekable<char> *peekable => string
    let raw_str = ""
    loop
        let c_opt = peekable->next()
        select c from c_opt
            raw_str += c
            if c == '\n' doremi raw_str
            continue
        ;
        return raw_str
    ;
;
