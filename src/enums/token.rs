#[derive(Debug, Copy, Clone, PartialEq)]
pub enum Token {
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
    Class,
    Char,
    Colon,
    Comma,
    Comment,
    Compiler,
    Condition,
    CoolArrow,
    DblColon,
    DblLessThan,
    DblMoreThan,
    Do,
    Dobr,
    Doco,
    Dore,
    Doremi,
    EOF,
    Equality,
    Equals,
    Extend,
    False,
    From,
    For,
    Foreach,
    ForwardSlash,
    Function,
    Get,
    Global,
    Id,
    In,
    Include,
    LBrack,
    LessThan,
    LessThanOrEquals,
    Let,
    LParen,
    MacroDefinition,
    Match,
    MoreThan,
    MoreThanOrEquals,
    Named,
    New,
    NewLine,
    NonEquality,
    Number,
    Or,
    Private,
    Protected,
    Public,
    Pointer,
    RBrack,
    Return,
    RParen,
    Select,
    SemiColon,
    Struct,
    String,
    Sub,
    Sum,
    True,
    Type,
    Until,
    Use,
    Enum,
    Switch,
    Default,
    Case,
    Raw,
}

impl Token {
    pub fn from(s: String) -> Token {
        if s.starts_with("\"") {return Token::String;}
        if s.starts_with("'") {return Token::Char;}
        match s.as_str() {
            "-" => Token::Sub,
            "," => Token::Comma,
            ":" => Token::Colon,
            ";" => Token::SemiColon,
            "!=" => Token::NonEquality,
            "(" => Token::LParen,
            "!" => Token::Bang,
            ")" => Token::RParen,
            "[" => Token::LBrack,
            "]" => Token::RBrack,
            "*" => Token::Asterix,
            "/" => Token::ForwardSlash,
            "//" => Token::Comment,
            "new" => Token::New,
            "\n" => Token::NewLine,
            "&&" => Token::And,
            "+" => Token::Sum,
            "<" => Token::LessThan,
            "::" => Token::DblColon,
            "<<" => Token::DblLessThan,
            "<<<" => Token::AllLessThan,
            "<=" => Token::LessThanOrEquals,
            "=!=" => Token::AllNotEquals,
            "=" => Token::Equals,
            "=&=" => Token::AllEquals,
            "=<=" => Token::AllLessOrEquals,
            "==" => Token::Equality,
            "=>" => Token::CoolArrow,
            "=>=" => Token::AllMoreOrEquals,
            "=|=" => Token::AnyEquals,
            ">" => Token::MoreThan,
            ">=" => Token::MoreThanOrEquals,
            ">>" => Token::DblMoreThan,
            ">>>" => Token::AllMoreThan,
            "->" => Token::Pointer,
            "||" => Token::Or,
            "0" => Token::Number,
            "1" => Token::Number,
            "2" => Token::Number,
            "3" => Token::Number,
            "4" => Token::Number,
            "5" => Token::Number,
            "6" => Token::Number,
            "7" => Token::Number,
            "8" => Token::Number,
            "9" => Token::Number,
            "from" => Token::From,
            "char" => Token::Type,
            "case" => Token::Case,
            "default" => Token::Default,
            "class" => Token::Class,
            "compiler" => Token::Compiler,
            "def" => Token::MacroDefinition,
            "do" => Token::Do,
            "dobr" => Token::Dobr,
            "doco" => Token::Doco,
            "dore" => Token::Dore,
            "doremi" => Token::Doremi,
            "enum" => Token::Enum,
            "elif" => Token::Condition,
            "else" => Token::Condition,
            "extend" => Token::Extend,
            "false" => Token::False,
            "fn" => Token::Function,
            "for" => Token::For,
            "foreach" => Token::Foreach,
            "get" => Token::Get,
            "glob" => Token::Global,
            "if" => Token::Condition,
            "in" => Token::In,
            "inc" => Token::Include,
            "int" => Token::Type,
            "let" => Token::Let,
            "match" => Token::Match,
            "named" => Token::Named,
            "private" => Token::Private,
            "protected" => Token::Protected,
            "pub" => Token::Public,
            "return" => Token::Return,
            "select" => Token::Select,
            "string" => Token::Type,
            "struct" => Token::Struct,
            "switch" => Token::Switch,
            "true" => Token::True,
            "until" => Token::Until,
            "use" => Token::Use,
            "while" => Token::Condition,
            "loop" => Token::Condition,
            "raw" => Token::Raw,
            _ => Token::Id,
        }
    }

    pub fn is_bool(self: &Token) -> bool {
        match self {
            Token::False => true,
            Token::True => true,
            _ => false
        }
    }
    
    pub fn is_num(self: &Token) -> bool {
        match self {
            Token::Number => true,
            _ => false
        }
    }
    
    pub fn is_char(self: &Token) -> bool {
        match self {
            Token::Char => true,
            _ => false
        }
    }
    
    pub fn is_string(self: &Token) -> bool {
        match self {
            Token::String => true,
            _ => false
        }
    }

    pub fn is_base(self: &Token) -> bool {
        match self {
            Token::Class => true,
            Token::EOF => true,
            Token::Function => true,
            Token::Get => true,
            Token::Global => true,
            Token::Include => true,
            Token::MacroDefinition => true,
            Token::NewLine => true,
            Token::SemiColon => true,
            Token::Struct => true,
            Token::Use => true,
            Token::Compiler => true,
            Token::Enum => true,
            Token::Named => true,
            _ => false,
        }
    }

    pub fn is_do(self: &Token) -> bool {
        match self {
            Token::Do => true,
            Token::Dobr => true,
            Token::Doco => true,
            Token::Dore => true,
            Token::Doremi => true,
            _ => false,
        }
    }

    pub fn is_conditional(self: &Token) -> bool {
        match self {
            Token::Equality => true,
            Token::NonEquality => true,
            Token::MoreThanOrEquals => true,
            Token::LessThanOrEquals => true,
            Token::LessThan => true,
            Token::MoreThan => true,
            Token::AnyEquals => true,
            Token::AllEquals => true,
            Token::AllNotEquals => true,
            Token::AllLessThan => true,
            Token::AllMoreThan => true,
            Token::AllLessOrEquals => true,
            Token::AllMoreOrEquals => true,
            _ => false,
        }
    }

    pub fn is_conditional_sep(self: &Token) -> bool {
        match self {
            Token::And => true,
            Token::Or => true,
            _ => false,
        }
    }
}
