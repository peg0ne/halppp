use crate::{enums::Token, message::display_err_message, structs::AstToken};

pub fn GetNextOrExit(next: Option<&AstToken>, s: &str) -> AstToken {
    match next {
        None => {
            display_err_message(s);
            return AstToken::new();
        }
        Some(n) => return n.to_owned(),
    };
}

pub fn TryGet(peek: Option<&&AstToken>, token: Token) -> bool {
    if peek.is_none() {return false}
    return peek.unwrap().token == token;
}

pub fn GetOrExit(next: Option<&AstToken>, token: Token, s: &str) -> String {
    if next.is_none() || next.unwrap().token != token {
        display_err_message(s);
        return String::new();
    }
    return next.unwrap().name.to_owned();
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
