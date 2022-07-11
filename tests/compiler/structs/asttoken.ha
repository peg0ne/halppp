struct AstToken
    string name = ""
    Token t = Id
    AstToken =>
    ;
    AstToken string id =>
        name = id
        token = Token(name)
    ;
    AstToken char ch =>
        name = to_string(ch)
        token = Token(name)
    ;
;
