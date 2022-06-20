use crate::{enums::token::Token, message::display_err_message, structs::ast_token::AstToken};

pub fn err_return_none<T>(s: &str) -> Option<T> {
    display_err_message(s);
    return None;
}

pub fn err_return_false(s: &str) -> bool {
    display_err_message(s);
    return false;
}

pub fn get_next_or_exit(next: Option<&AstToken>, s: &str) -> AstToken {
    match next {
        None => {
            display_err_message(s);
            return AstToken {
                name: String::from(""),
                token: Token::Id,
            };
        }
        Some(n) => return n.to_owned(),
    };
}
