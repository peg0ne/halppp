struct AstToken
    string name = EMPTY
    Token token = Token::Id
    Token_t t = Token_t("\n")
    AstToken => do return
    AstToken string id =>
        this->name = id
        this->t = Token_t(name)
        this->token = t.t
    ;
    AstToken char ch =>
        let buf = string(1,ch)
        this->name = buf
        this->t = Token_t(name)
        this->token = t.t
    ;
    fn to_string => string doremi "[" + name + "]: Token: " + t.as_str()
    fn is_classy => bool doremi t.is_classy()
    fn is_id => bool doremi t.is_id()
    fn is_nl => bool doremi t.is_nl()
    fn is_bool => bool doremi t.is_bool()
    fn is_num => bool doremi t.is_num()
    fn is_float => bool doremi t.is_float()
    fn is_char => bool doremi t.is_char()
    fn is_string => bool doremi t.is_string()
    fn is_terminator => bool doremi t.is_terminator()
    fn is_base => bool doremi t.is_base()
    fn is_do => bool doremi t.is_do()
    fn is_adv_conditional => bool doremi t.is_adv_conditional()
    fn is_conditional => bool doremi t.is_conditional()
    fn is_conditional_sep => bool doremi t.is_conditional_sep()
    fn valid_case => bool doremi t.valid_case()
;