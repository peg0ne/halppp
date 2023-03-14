enum JsonToken
    LBrace,
    RBrace,
    LBox,
    RBox,
    Colon,
    Comma,
    StringLiteral,
    NumberLiteral,
    BooleanLiteral,
;

struct JsonTokenized
    string literal
    JsonToken token
    JsonTokenized => do return
    JsonTokenized char literal, JsonToken token =>
        this->literal = string(1,literal)
        this->token = token
    ;
    JsonTokenized string literal, JsonToken token =>
        this->literal = literal
        this->token = token
    ;
    fn as_str => string doremi $"JsonTokenized(literal: \"{literal}\", type: \"{token}\")"
;