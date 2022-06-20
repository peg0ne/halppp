use crate::{enums::Token, message::display_err_message, structs::AstToken};

pub fn get_next_or_exit(next: Option<&AstToken>, s: &str) -> AstToken {
    match next {
        None => {
            display_err_message(s);
            return AstToken::new();
        }
        Some(n) => return n.to_owned(),
    };
}

pub fn get_id_or_exit(next: Option<&AstToken>, s: &str) -> String {
    match next {
        None => {
            display_err_message(s);
            return String::new();
        }
        Some(n) => match n.token {
            Token::Id => return n.name.to_owned(),
            _ => {
                display_err_message(s);
                return String::new();
            }
        },
    };
}
