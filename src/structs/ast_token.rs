use crate::enums::token::Token;

#[derive(Debug, Clone)]
pub struct AstToken {
    pub name: String,
    pub token: Token,
}
