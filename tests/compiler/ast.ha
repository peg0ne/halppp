fn try_add_token string id, vector<AstToken> *ast => string
    if id.size() > 0
        ast->push_back(AstToken(id))
        return EMPTY
    ;
    return id
;

fn is_char_token char ch => bool
    string s(1,ch)
    switch Token_t(s).t
        case TId: doremi false
        default: doremi true
    ;
;

fn is_char_number char ch => bool
    string s(1,ch)
    switch Token_t(s).t
        case TNumber: doremi true
        default: doremi false
    ;
;

fn try_get_dbl Peekable<char> *peekable, char ch => Option<string>
    let peek = peekable->peek()
    if peek.is_some() && peek.value_or(' ') == ch
        string dbl(1, ch)
        dbl += dbl
        peekable->next()
        return Some(dbl)
    ;
    return None<string>()
;

fn get_matching Peekable<char> *peekable, char ch => string
    string matching(1, ch)
    while true
        let c = peekable->next()
        if c.is_none() doremi matching
        string matchbuf(1, c.value_or(' '))
        matching += matchbuf
        if c.value_or(' ') == ch do break
    ;
    return matching
;

fn collect_num Peekable<char> *peekable, char ch => string
    string num(1, ch)
    while true
        let peeked = peekable->peek().value_or(' ')
        if !is_char_number(peeked) && peeked != '.' doremi num
        peekable->next()
        string numbuf(1, peeked)
        num += numbuf
    ;
;

fn ast_create string content => vector<AstToken>
    vector<char> vec = {}
    for i until content.size()
        vec.push_back(content[i])
    ;
    let peekable = Peekable<char>(vec)
    string id = EMPTY
    vector<AstToken> ast = {}
    while true
        let c_opt = peekable.next()
        if c_opt.is_none() do break
        let c = c_opt.value_or(' ')
        if any(c, {CHAR_QUOTE, CHAR_SINGLE})
            let matched = get_matching(&peekable, c)
            id = try_add_token(id, &ast)
            try_add_token(matched, &ast)
            continue
        ;
        if is_char_number(c)
            let num = collect_num(&peekable, c)
            id = try_add_token(id, &ast)
            try_add_token(num, &ast)
            continue
        ;
        if is_char_token(c)
            let dbl_less = id != "<" && c == '<'
            let dbl_more = id != ">" && c == '>'
            let dbl_eq = id != "=" && c == '='
            if dbl_less || dbl_more || dbl_eq
                let dbl = try_get_dbl(&peekable, c)
                if dbl.is_some()
                    id = try_add_token(id, &ast)
                    try_add_token(dbl.value_or(EMPTY), &ast)
                    continue
                ;
            ;
        ;
        if is_char_token(c)
            id = try_add_token(id, &ast)
            let next = peekable.peek().value_or(' ')
            let is_cool = c == '=' && next == '>'
            let is_non_eq = c == '!' && next == '='
            if is_cool
                peekable.next()
                ast.push_back(AstToken("=>"))
                continue
            ;
            elif is_non_eq
                peekable.next()
                ast.push_back(AstToken("!="))
                continue
            ;
            ast.push_back(AstToken(c))
            continue
        ;
        print(c)
        if any(c, {' ', '\t', '\n'})
            id = try_add_token(id, &ast)
            if c == '\n' do ast.push_back(AstToken("\n"))
            continue
        ;
        string ch(1, c)
        id += ch
    ;
    //Push extra sets of EOF to ensure it wont break badly
    ast.push_back(AstToken("EOF"))
    ast.push_back(AstToken("EOF"))
    ast.push_back(AstToken("EOF"))
    ast.push_back(AstToken("EOF"))
    ast.push_back(AstToken("EOF"))
    ast.push_back(AstToken("EOF"))
    return ast
;
