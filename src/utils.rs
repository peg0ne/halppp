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

pub fn get_arrow_or_exit(next: Option<&AstToken>, s: &str) {
    match next {
        None => display_err_message(s),
        Some(n) => match n.token {
            Token::CoolArrow => {},
            _ => display_err_message(s),
        },
    };
}

pub fn get_eq_or_exit(next: Option<&AstToken>, s: &str) {
    match next {
        None => display_err_message(s),
        Some(n) => match n.token {
            Token::Equals => {},
            _ => display_err_message(s),
        },
    };
}

pub fn try_get_lessthan(peek: Option<&&AstToken>) -> bool {
    match peek {
        None => false,
        Some(n) => match n.token {
            Token::LessThan => true,
            _ => false,
        },
    };
    false
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

pub fn get_folder_and_name(file_path: &String) -> (String, String) {
    let mut file_name: String = String::new();
    let mut folder_path: String = file_path.to_owned();
    loop {
        let i: i32 = folder_path.len() as i32;
        if i == 0 { break; }
        match folder_path.pop() {
            Some(p) => {
                if p == '/' {
                    folder_path.push('/');
                    break;
                }
                file_name.push(p);
            }
            _ => {}
        }
    }
    let mut reversed = String::new();
    while file_name.len() > 0 {
        reversed.push(file_name.pop().unwrap());
    }
    file_name = reversed;
    (folder_path, file_name)
}
