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
    Match,
    MoreThan,
    MoreThanOrEquals,
    New,
    Named,
    NewLine,
    NonEquality,
    Number,
    Or,
    Period,
    DoublePeriod,
    TriplePeriod,
    Pointer,
    Private,
    Protected,
    Public,
    RBlock,
    RBrack,
    Return,
    RParen,
    SemiColon,
    Static,
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
        elif any(s, {TOKEN_WHILE, TOKEN_LOOP}) dore t = Token::Condition
        elif any(s, {TOKEN_IFS, TOKEN_ELIF, TOKEN_ELSE}) dore t = Token::Condition
        elif any(s, {TOKEN_ZERO, TOKEN_ONE, TOKEN_TWO}) dore t = Token::Number
        elif any(s, {TOKEN_THREE, TOKEN_FOUR, TOKEN_FIVE}) dore t = Token::Number
        elif any(s, {TOKEN_SIX, TOKEN_SEVEN, TOKEN_EIGHT, TOKEN_NINE}) dore t = Token::Number
        elif any(s, {TOKEN_INT, TOKEN_STR, TOKEN_STRING}) dore t = Token::Type
        match s
            TOKEN_ALLEQUALS => dore t = Token::AllEquals
            TOKEN_ALLLESSOREQUALS => dore t = Token::AllLessOrEquals
            TOKEN_ALLLESSTHAN => dore t = Token::AllLessThan
            TOKEN_ALLMOREOREQUALS => dore t = Token::AllMoreOrEquals
            TOKEN_ALLMORETHAN => dore t = Token::AllMoreThan
            TOKEN_ALLNOTEQUALS => dore t = Token::AllNotEquals
            TOKEN_AND => dore t = Token::And
            TOKEN_ANYEQUALS => dore t = Token::AnyEquals
            TOKEN_ASTERIX => dore t = Token::Asterix
            TOKEN_BANG => dore t = Token::Bang
            TOKEN_CASE => dore t = Token::Case
            TOKEN_CLASS => dore t = Token::Class
            TOKEN_COLON => dore t = Token::Colon
            TOKEN_COMMA => dore t = Token::Comma
            TOKEN_COMPILER => dore t = Token::Compiler
            TOKEN_COOLARROW => dore t = Token::CoolArrow
            TOKEN_DBLCOLON => dore t = Token::DblColon
            TOKEN_DBLLESSTHAN => dore t = Token::DblLessThan
            TOKEN_DBLMORETHAN => dore t = Token::DblMoreThan
            TOKEN_DEFAULT => dore t = Token::Default
            TOKEN_DO => dore t = Token::Do
            TOKEN_DOBR => dore t = Token::Dobr
            TOKEN_DOCO => dore t = Token::Doco
            TOKEN_DORE => dore t = Token::Dore
            TOKEN_DOREMI => dore t = Token::Doremi
            TOKEN_ENUM => dore t = Token::Enum
            TOKEN_EOF => dore t = Token::Eof
            TOKEN_EQUALITY => dore t = Token::Equality
            TOKEN_EQUALS => dore t = Token::Equals
            TOKEN_EXTEND => dore t = Token::Extend
            TOKEN_FALSE => dore t = Token::False
            TOKEN_FOR => dore t = Token::For
            TOKEN_FOREACH => dore t = Token::Foreach
            TOKEN_FORWARDSLASH => dore t = Token::ForwardSlash
            TOKEN_FROM => dore t = Token::From
            TOKEN_FUNCTION => dore t = Token::Function
            TOKEN_GET => dore t = Token::Get
            TOKEN_GLOBAL => dore t = Token::Global
            TOKEN_IN => dore t = Token::In
            TOKEN_INCLUDE => dore t = Token::Include
            TOKEN_LBLOCK => dore t = Token::LBlock
            TOKEN_LBRACK => dore t = Token::LBrack
            TOKEN_LESSTHAN => dore t = Token::LessThan
            TOKEN_LESSTHANOREQUALS => dore t = Token::LessThanOrEquals
            TOKEN_LET => dore t = Token::Let
            TOKEN_LINE_COMMENT => dore t = Token::Comment
            TOKEN_LPAREN => dore t = Token::LParen
            TOKEN_MACRODEFINITION => dore t = Token::MacroDefinition
            TOKEN_MATCH => dore t = Token::Match
            TOKEN_MORETHAN => dore t = Token::MoreThan
            TOKEN_MORETHANOREQUALS => dore t = Token::MoreThanOrEquals
            TOKEN_NAMED => dore t = Token::Named
            TOKEN_NEW => dore t = Token::New
            TOKEN_NEWLINE => dore t = Token::NewLine
            TOKEN_NONEQUALITY => dore t = Token::NonEquality
            TOKEN_OR => dore t = Token::Or
            TOKEN_PERIOD => dore t = Token::Period
            TOKEN_DOUBLE_PERIOD => dore t = Token::DoublePeriod
            TOKEN_TRIPLE_PERIOD => dore t = Token::TriplePeriod
            TOKEN_POINTER => dore t = Token::Pointer
            TOKEN_PRIVATE => dore t = Token::Private
            TOKEN_PROTECTED => dore t = Token::Protected
            TOKEN_PUBLIC => dore t = Token::Public
            TOKEN_RBLOCK => dore t = Token::RBlock
            TOKEN_RBRACK => dore t = Token::RBrack
            TOKEN_RETURN => dore t = Token::Return
            TOKEN_RPAREN => dore t = Token::RParen
            TOKEN_SEMICOLON => dore t = Token::SemiColon
            TOKEN_SELECT => dore t = Token::Select
            TOKEN_STATIC => dore t = Token::Static
            TOKEN_STRUCT => dore t = Token::Struct
            TOKEN_SUB => dore t = Token::Sub
            TOKEN_SUM => dore t = Token::Sum
            TOKEN_SWITCH => dore t = Token::Switch
            TOKEN_TRUE => dore t = Token::True
            TOKEN_UNTIL => dore t = Token::Until
            TOKEN_USE => dore t = Token::Use
            _ => dore t = Token::Id
        ;
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
    fn is_adv_conditional => bool
        switch t
        case Token::AllEquals
        case Token::AllLessOrEquals
        case Token::AllLessThan
        case Token::AllMoreOrEquals 
        case Token::AllMoreThan
        case Token::AllNotEquals
        case Token::AnyEquals doremi true
        default doremi false
        ;
    ;
    fn is_conditional => bool
        switch t
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