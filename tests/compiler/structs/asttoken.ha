struct AstToken
    string name = EMPTY
    Token token = TId
    Token_t t = Token_t("\n")
    AstToken =>
    ;
    AstToken string id =>
        this->name = id
        this->t = Token_t(name)
        this->token = t.t
    ;
    AstToken char ch =>
        string buf(1,ch)
        this->name = buf
        this->t = Token_t(name)
        this->token = t.t
    ;
    fn to_string => string doremi "[" + name + "]: Token: " + token_to_string(token)
;
