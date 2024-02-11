fn next_is_none Peekable<char> &peekable => bool
    return peekable.peek().is_none()
;

fn try_get_pair Peekable<char> &peekable, char c => Option<string>
    let pairs = ""
    switch c
    case '(' dobr pairs = get_pair(&peekable, '(', ')')
    case '{' dobr pairs = get_pair(&peekable, '{', '}')
    default do break
    ;
    return pairs != "" ? Some(pairs) : None<string>()
;

fn try_get_concat Peekable<char> &peekable, char c => Option<string>
    if c != '$' || peekable.peek().value_or(' ') != '"' doremi None<string>()
    return Some(get_concat(&peekable))
;

fn try_get_matching Peekable<char> &peekable, char c => Option<string>
    if none(c, {CHAR_QUOTE, CHAR_SINGLE}) doremi None<string>()
    return Some(get_matching(&peekable, c))
;

fn try_append_raw Peekable<char> &peekable, vector<AstToken> &ast =>
    if ast.size() <= 0 || ast[ast.size() - 1].token != Token::Raw do return
    ast[ast.size() - 1].name = try_collect_raw(&peekable)
    ast.push_back(AstToken("\n"))
;

fn try_get_num Peekable<char> &peekable, char c => Option<AstToken>
    if !is_char_number_t(c) doremi None<AstToken>()
    return collect_num(&peekable, c)
;

fn try_get_single_char_token Peekable<char> &peekable, char c => Option<AstToken>
    if !is_char_token(c) doremi None<AstToken>()
    return Some(AstToken(c))
;

fn try_get_white_space Peekable<char> &peekable, char c => Option<AstToken>
    if !is_white_space(c) doremi None<AstToken>()
    elif c == '\n' doremi Some(AstToken("\n"))
    else doremi Some(AstToken(" "))
;

fn is_white_space char c => bool doremi any(c, {'\n', ' ', '\t', '\r'})
fn is_both_token string id, char c => bool doremi is_str_tokens(id) == is_char_token(c)

fn try_get_advanced_condition Peekable<char> &peekable, string id, char c => Option<string>
    if id.size() != 0 || c != '=' doremi None<string>()
    if peekable.peek().is_none() doremi None<string>()
    if peekable.at(peekable.index() + 1).is_none() doremi None<string>()
    let second = peekable.peek().value_or(' ')
    let third = peekable.at(peekable.index() + 1).value_or(' ')
    let is_part_of_adv = any(second, {'&', '<', '!', '|', '>'})
    let is_end_of_adv = third == '='
    if !is_part_of_adv || !is_end_of_adv doremi None<string>()
    return Some(string(3, c + second + third))
;
