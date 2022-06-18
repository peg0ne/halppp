use crate::{message::display_err_message, Token};

pub fn err_return_none<T>(s: &str) -> Option<T> {
    display_err_message(s);
    return None;
}

pub fn err_return_false(s: &str) -> bool {
    display_err_message(s);
    return false;
}

pub fn get_next_or_exit(next: Option<&(String, Token)>, s: &str) -> (String, Token) {
    match next {
        None => {
            display_err_message(s);
            return (String::from(""), Token::Id);
        }
        Some(n) => return (n.0.to_owned(), n.1),
    };
}
