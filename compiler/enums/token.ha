enum Token
    AllEquals,
    AllLessOrEquals,
    AllLessThan,
    AllMoreOrEquals,
    AllMoreThan,
    AllNotEquals,
    And,
    AnyEquals,
    Asterix,
    Bang,
    Case,
    Char,
    Class,
    Colon,
    Comma,
    Comment,
    Compiler,
    Condition,
    CoolArrow,
    DblColon,
    DblLessThan,
    DblMoreThan,
    Default,
    Do,
    Dobr,
    Doco,
    Dore,
    Doremi,
    Enum,
    Eof,
    Equality,
    Equals,
    Extend,
    False,
    Float,
    For,
    Foreach,
    ForwardSlash,
    From,
    Function,
    Get,
    Global,
    Id,
    In,
    Include,
    LBlock,
    LBrack,
    LessThan,
    LessThanOrEquals,
    Let,
    LParen,
    MacroDefinition,
    MoreThan,
    MoreThanOrEquals,
    Named,
    NewLine,
    NonEquality,
    Number,
    Or,
    Pointer,
    Private,
    Protected,
    Public,
    RBlock,
    RBrack,
    Return,
    RParen,
    SemiColon,
    String,
    Struct,
    Sub,
    Sum,
    Switch,
    Select,
    True,
    Type,
    Until,
    Use,
    UNKNOWN,
;

struct Token_t
    Token t = Token::Id
    Token_t string s =>
        let S = String(s)
        if S.starts_with(QUOTE) dore t = Token::String
        elif S.starts_with("'") dore t = Token::Char
        elif s == TOKEN_ALLEQUALS dore t = Token::AllEquals
        elif s == TOKEN_ALLLESSOREQUALS dore t = Token::AllLessOrEquals
        elif s == TOKEN_ALLLESSTHAN dore t = Token::AllLessThan
        elif s == TOKEN_ALLMOREOREQUALS dore t = Token::AllMoreOrEquals
        elif s == TOKEN_ALLMORETHAN dore t = Token::AllMoreThan
        elif s == TOKEN_ALLNOTEQUALS dore t = Token::AllNotEquals
        elif s == TOKEN_AND dore t = Token::And
        elif s == TOKEN_ANYEQUALS dore t = Token::AnyEquals
        elif s == TOKEN_ASTERIX dore t = Token::Asterix
        elif s == TOKEN_BANG dore t = Token::Bang
        elif s == TOKEN_CASE dore t = Token::Case
        elif s == TOKEN_CLASS dore t = Token::Class
        elif s == TOKEN_COLON dore t = Token::Colon
        elif s == TOKEN_COMMA dore t = Token::Comma
        elif s == TOKEN_COMPILER dore t = Token::Compiler
        elif s == TOKEN_COOLARROW dore t = Token::CoolArrow
        elif s == TOKEN_DBLCOLON dore t = Token::DblColon
        elif s == TOKEN_DBLLESSTHAN dore t = Token::DblLessThan
        elif s == TOKEN_DBLMORETHAN dore t = Token::DblMoreThan
        elif s == TOKEN_DEFAULT dore t = Token::Default
        elif s == TOKEN_DO dore t = Token::Do
        elif s == TOKEN_DOBR dore t = Token::Dobr
        elif s == TOKEN_DOCO dore t = Token::Doco
        elif s == TOKEN_DORE dore t = Token::Dore
        elif s == TOKEN_DOREMI dore t = Token::Doremi
        elif s == TOKEN_ENUM dore t = Token::Enum
        elif s == TOKEN_EOF dore t = Token::Eof
        elif s == TOKEN_EQUALITY dore t = Token::Equality
        elif s == TOKEN_EQUALS dore t = Token::Equals
        elif s == TOKEN_EXTEND dore t = Token::Extend
        elif s == TOKEN_FALSE dore t = Token::False
        elif s == TOKEN_FOR dore t = Token::For
        elif s == TOKEN_FOREACH dore t = Token::Foreach
        elif s == TOKEN_FORWARDSLASH dore t = Token::ForwardSlash
        elif s == TOKEN_FROM dore t = Token::From
        elif s == TOKEN_FUNCTION dore t = Token::Function
        elif s == TOKEN_GET dore t = Token::Get
        elif s == TOKEN_GLOBAL dore t = Token::Global
        elif s == TOKEN_IN dore t = Token::In
        elif s == TOKEN_INCLUDE dore t = Token::Include
        elif s == TOKEN_LBLOCK dore t = Token::LBlock
        elif s == TOKEN_LBRACK dore t = Token::LBrack
        elif s == TOKEN_LESSTHAN dore t = Token::LessThan
        elif s == TOKEN_LESSTHANOREQUALS dore t = Token::LessThanOrEquals
        elif s == TOKEN_LET dore t = Token::Let
        elif s == TOKEN_LINE_COMMENT dore t = Token::Comment
        elif s == TOKEN_LPAREN dore t = Token::LParen
        elif s == TOKEN_MACRODEFINITION dore t = Token::MacroDefinition
        elif s == TOKEN_MORETHAN dore t = Token::MoreThan
        elif s == TOKEN_MORETHANOREQUALS dore t = Token::MoreThanOrEquals
        elif s == TOKEN_NAMED dore t = Token::Named
        elif s == TOKEN_NEWLINE dore t = Token::NewLine
        elif s == TOKEN_NONEQUALITY dore t = Token::NonEquality
        elif s == TOKEN_OR dore t = Token::Or
        elif s == TOKEN_POINTER dore t = Token::Pointer
        elif s == TOKEN_PRIVATE dore t = Token::Private
        elif s == TOKEN_PROTECTED dore t = Token::Protected
        elif s == TOKEN_PUBLIC dore t = Token::Public
        elif s == TOKEN_RBLOCK dore t = Token::RBlock
        elif s == TOKEN_RBRACK dore t = Token::RBrack
        elif s == TOKEN_RETURN dore t = Token::Return
        elif s == TOKEN_RPAREN dore t = Token::RParen
        elif s == TOKEN_SEMICOLON dore t = Token::SemiColon
        elif s == TOKEN_SELECT dore t = Token::Select
        elif s == TOKEN_STRUCT dore t = Token::Struct
        elif s == TOKEN_SUB dore t = Token::Sub
        elif s == TOKEN_SUM dore t = Token::Sum
        elif s == TOKEN_SWITCH dore t = Token::Switch
        elif s == TOKEN_TRUE dore t = Token::True
        elif s == TOKEN_UNTIL dore t = Token::Until
        elif s == TOKEN_USE dore t = Token::Use
        elif any(s, {TOKEN_WHILE, TOKEN_LOOP}) dore t = Token::Condition
        elif any(s, {TOKEN_IFS, TOKEN_ELIF, TOKEN_ELSE}) dore t = Token::Condition
        elif any(s, {TOKEN_ZERO, TOKEN_ONE, TOKEN_TWO}) dore t = Token::Number
        elif any(s, {TOKEN_THREE, TOKEN_FOUR, TOKEN_FIVE}) dore t = Token::Number
        elif any(s, {TOKEN_SIX, TOKEN_SEVEN, TOKEN_EIGHT, TOKEN_NINE}) dore t = Token::Number
        elif any(s, {TOKEN_INT, TOKEN_STR, TOKEN_STRING}) dore t = Token::Type
        t = Token::Id
    ;
    fn is_id => bool doremi t == Token::Id
    fn is_nl => bool doremi t == Token::NewLine
    fn is_bool => bool doremi any(t, {Token::False, Token::True})
    fn is_num => bool doremi t == Token::Number
    fn is_float => bool doremi t == Token::Float
    fn is_char => bool doremi t == Token::Char
    fn is_string => bool doremi t == Token::String
    fn is_classy => bool doremi any(t, {Token::Class, Token::Struct})
    fn is_terminator => bool doremi any(t, {Token::SemiColon, Token::Eof})
    fn is_base => bool
        switch t
        case Token::Class
        case Token::Compiler
        case Token::Enum 
        case Token::Eof
        case Token::Function
        case Token::Get
        case Token::Global
        case Token::Include
        case Token::MacroDefinition
        case Token::Named
        case Token::NewLine
        case Token::SemiColon
        case Token::Struct
        case Token::Use doremi true
        default doremi false
        ;
    ;
    fn is_do => bool
        switch t
        case Token::Do
        case Token::Dobr
        case Token::Doco
        case Token::Dore
        case Token::Doremi doremi true
        default doremi false
        ;
    ;
    fn is_conditional => bool
        switch t
        case Token::AllEquals
        case Token::AllLessOrEquals
        case Token::AllLessThan
        case Token::AllMoreOrEquals 
        case Token::AllMoreThan
        case Token::AllNotEquals
        case Token::AnyEquals
        case Token::Equality
        case Token::LessThan
        case Token::LessThanOrEquals
        case Token::MoreThan
        case Token::MoreThanOrEquals
        case Token::NonEquality doremi true
        default doremi false
        ;
    ;
    fn is_conditional_sep => bool doremi any(t, {Token::And, Token::Or})
    fn valid_case => bool doremi any(t, {Token::Id, Token::Number, Token::Char})
    fn as_str => string doremi to_string(t)
;