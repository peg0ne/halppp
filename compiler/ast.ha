fn ast_create string content => vector<AstToken>
    vector<char> vec = {}
    foreach i in content do vec.push_back(i)
    let peekable = Peekable<char>(vec)
    string id = EMPTY
    vector<AstToken> ast = {}
    loop
        let c_opt = peekable.next()
        let last_known_index = peekable.index()
        if c_opt.is_none() dobr try_add_token(id, &ast, &peekable)
        let c = c_opt.value_or(' ')
        if any(c, {CHAR_QUOTE, CHAR_SINGLE})
            let matched = get_matching(&peekable, c)
            id = try_add_token(id, &ast, &peekable)
            doco try_add_token(matched, &ast, &peekable)
        ;
        elif is_char_number(c)
            let num = collect_num(&peekable, c)
            id = try_add_token(id, &ast, &peekable)
            doco ast.push_back(num)
        ;
        string ch(1, c)
        let is_white_space = any(c, {'\n', ' ', '\t'})
        let is_both_token = is_str_tokens(id) == is_char_token(c)
        if !is_both_token
            id = try_add_token(id, &ast, &peekable)
            if peekable.index() != last_known_index do continue
            if !is_white_space doco id += ch
        ;
        if is_both_token && is_str_tokens(id + ch) doco id += ch
        elif is_char_token(c)
            id = try_add_token(id, &ast, &peekable)
            if peekable.index() != last_known_index do continue
            doco ast.push_back(AstToken(c))
        ;
        elif is_white_space
            id = try_add_token(id, &ast, &peekable)
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

fn try_add_token string id, vector<AstToken> *ast, Peekable<char> *peekable => string
    if id.size() == 0 doremi id
    if id == "//"
        loop
            let next = peekable->next().value_or('\n')
            if next == '\n' do break
        ;
        id = "\n"
    ;
    ast->push_back(AstToken(id))
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
fn is_char_number char ch => bool
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

fn collect_num Peekable<char> *peekable, char ch => AstToken
    string num(1, ch)
    let is_float = false
    let token = AstToken()
    loop
        let peeked = peekable->peek().value_or(' ')
        if !is_char_number(peeked) && peeked != '.'
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