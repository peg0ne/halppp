#[derive(Debug, Copy, Clone)]
pub enum Token {
    Id,
    Number,
    Function,
    Class,
    Global,
    MacroDefinition,
    Get,
    Include,
    Struct,
    Public,
    Private,
    Protected,
    CoolArrow,
    Int,
    String,
    Char,
    Extend,
    Return,
    LParen,
    RParen,
    SemiColon,
    Comma,
    Sum,
    Sub,
    ForwardSlash,
    Asterix,
}

impl Token {
    pub fn from(s: String) -> Token {
        match s.as_str() {
            "fn" => Token::Function,
            "class" => Token::Class,
            "glob" => Token::Global,
            "def" => Token::MacroDefinition,
            "get" => Token::Get,
            "inc" => Token::Include,
            "struct" => Token::Struct,
            "pub" => Token::Public,
            "private" => Token::Private,
            "protected" => Token::Protected,
            "=>" => Token::CoolArrow,
            "int" => Token::Int,
            "string" => Token::String,
            "str" => Token::String,
            "char" => Token::Char,
            "extend" => Token::Extend,
            "return" => Token::Return,
            "(" => Token::LParen,
            ")" => Token::RParen,
            ";" => Token::SemiColon,
            "," => Token::Comma,
            "+" => Token::Sum,
            "-" => Token::Sub,
            "/" => Token::ForwardSlash,
            "*" => Token::Asterix,
            _ => Token::Id,
        }
    }

    pub fn is_base(self: &Token) -> bool {
        match self {
            Token::Class => true,
            Token::Global => true,
            Token::Function => true,
            Token::Struct => true,
            Token::MacroDefinition => true,
            Token::Get => true,
            Token::Include => true,
            _ => false,
        }
    }
}
