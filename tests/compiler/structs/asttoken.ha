struct AstToken
    string name = EMPTY
    Token token = TId
    Token_t t = Token_t("\n")
    AstToken =>
    ;
    AstToken string id =>
        name = id
        t = Token_t(name)
        token = t.t
    ;
    AstToken char ch =>
        name = to_string(ch)
        t = Token_t(name)
        token = t.t
    ;
;
