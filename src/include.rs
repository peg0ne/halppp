use crate::{
    enums::Token,
    message::{display_err_message, display_hint_message},
    structs::Compiler,
    utils::get_next_or_exit,
};

pub fn construct(compiler: &mut Compiler) -> Vec<String> {
    let mut includes = Vec::new();
    let arrow = get_next_or_exit(
        compiler.next(),
        "[IncludeError]: Missing [=>] in declaration",
    );
    match arrow.token {
        Token::CoolArrow => {}
        _ => display_err_message("[IncludeError]: Missing [=>] in declaration"),
    }
    loop {
        let next = get_next_or_exit(
            compiler.next(),
            "[IncludeError]: Include declaration invalid",
        );
        match next.token {
            Token::NewLine => break,
            Token::EOF => break,
            Token::Comma => continue,
            _ => {
                if next.token.is_base() {
                    display_err_message(
                        format!("[IncludeError]: Token not allowed: [{}]", next.name).as_str(),
                    );
                }
                includes.push(next.name);
            }
        }
    }
    return includes;
}
