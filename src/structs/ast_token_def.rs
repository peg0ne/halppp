use crate::enums::Token;

#[derive(Debug, Clone)]
pub struct AstToken {
    pub name: String,
    pub token: Token,
}

impl AstToken {
    pub fn new() -> AstToken {
        AstToken {
            name: String::from(""),
            token: Token::Id,
        }
    }
    pub fn from_id(id: String) -> AstToken {
        AstToken {
            name: id.to_owned(),
            token: Token::from(id.to_owned()),
        }
    }
    pub fn from_char(c: char) -> AstToken {
        AstToken {
            name: String::from(c),
            token: Token::from(c.to_string()),
        }
    }
    pub fn new_line() -> AstToken {
        AstToken {
            name: String::from("\n"),
            token: Token::NewLine,
        }
    }
    pub fn eof() -> AstToken {
        AstToken {
            name: String::from("eof"),
            token: Token::EOF,
        }
    }
}
