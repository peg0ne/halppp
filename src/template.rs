use crate::{
    enums::Token,
    message::display_err_message,
    structs::Compiler,
    utils::get_next_or_exit,
};

pub fn construct(compiler: &mut Compiler) -> Vec<String> {
    let mut templates: Vec<String> = Vec::new();
    loop {
        let next = get_next_or_exit(compiler.next(), "[Template]: Template declaration invalid");
        match next.token {
            Token::Id => templates.push(next.name),
            Token::Comma => continue,
            Token::LessThan => continue,
            Token::MoreThan => break,
            _ => display_err_message(format!("[Template]: Token not allowed: [{}]", next.name).as_str())
        }
    }
    return templates;
}
