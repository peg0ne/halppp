fn create string content => vector<AstToken>
    let peekable = Peekable<char>(content)
    let id = EMPTY
    vector<AstToken> ast = {}
    while true
        let c_opt = peekable.next()
        if c.is_none() do break
        let c = c_opt.value_or(' ')
        if any(c, {'"', '\''})
            let matched = get_matching(peekable, c)
            id = try_add_token(id, ast)
            doco try_add_token(matched, ast)
        ;
        if is_char_number(c)
            let num = collect_num(peekable, c)
            id = try_add_token(id, ast)
            doco try_add_token(num, ast)
        ;
        if is_char_token(c)
            let dbl_less = id != "<" && c == '<'
            let dbl_more = id != ">" && c == '>'
            let dbl_eq = id != "=" && c == '='
            if dbl_less || dbl_more || dbl_eq
                let dbl = try_get_dbl(peekable, c)
                if dbl.is_some()
                    id = try_add_token(id, ast)
                    doco try_add_token(dbl.value_or(EMPTY), ast)
                ;
            ;
        ;
        if is_char_token(c)
            id = try_add_token(id, ast)
            let next = peekable.peek().value_or(' ')
            let is_cool = c == '=' && next == '>'
            let is_non_eq = c == '!' && next == '='
            if is_cool
                peekable.next()
                doco ast.push_back(AstToken("=>"))
            ;
            elif is_non_eq
                peekable.next()
                doco ast.push_back(AstToken("!="))
            ;
            doco ast.push_back(AstToken(c))
        ;
        if any(c, {' ', '\t', '\n'})
            id = try_add_token(id, &ast);
            if c == '\n' do ast.push_back(AstToken("\n"))
            continue
        ;
        id += c
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

fn try_add_token string id, vector<AstToken> ast => string
    if id.size() > 0
        ast.push(AstToken(id))
        return EMPTY
    ;
    return id
;

fn is_char_token char ch => bool
    switch Token(ch)
        case Id: doremi false
        default: doremi true
    ;
;

fn is_char_number char ch => bool
    switch Token(ch)
        case Number: doremi true
        default: doremi false
    ;
;

fn try_get_dbl Peekable<char> peekable, char ch => Option<string>
    let peek = peekable.peek()
    if peek.is_some() && peek.value_or(' ') == ch
        let dbl = c + c
        peekable.next()
        return Some(dbl)
    ;
    None<string>()
;

fn get_matching Peekable<char> peekable, char ch => string
    let matching = to_string(ch)
    while true
        let c = peekable.next()
        if c.is_none() doremi matching
        matching += c.value_or(' ')
        if c == ch do break
    ;
    return matching
;

fn collect_num Peekable<char> peekable, char ch => string
    let num = to_string(ch)
    while true
        let peeked = peekable.peek().value_or(' ')
        if !is_char_number(peeked) && peeked != '.' doremi num
        peekable.next()
        num += peeked
    ;
;