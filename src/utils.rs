use crate::{
    message::display_err_message,
};

pub fn err_return_none<T>(s: &str) -> Option<T> {
    display_err_message(s);
    return None
}