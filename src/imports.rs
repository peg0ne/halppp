use crate::{
    enums::Token,
    message::{display_err_message, display_hint_message},
    structs::{AstToken, Compiler},
    utils::get_next_or_exit,
};

pub fn construct(compiler: &mut Compiler) -> Vec<String> {
    let mut imports: Vec<String> = Vec::new();
    let arrow = get_next_or_exit(compiler.next(), "[Import]: Missing [=>] in declaration");
    match arrow.token {
        Token::CoolArrow => {}
        _ => display_err_message("[Import]: Missing [=>] in declaration"),
    }
    loop {
        let next = get_next_or_exit(compiler.next(), "[Import]: Import declaration invalid");
        match next.token {
            Token::NewLine => break,
            Token::EOF => break,
            Token::Comma => continue,
            _ => {
                if next.token.is_base() {
                    display_err_message(
                        format!("[Import]: Token not allowed: [{}]", next.name).as_str(),
                    );
                }
                let mut found = false;
                for i in imports.iter() {
                    if i.to_owned() == next.name {
                        display_hint_message(
                            format!("[Import]: Token duplicate in entry {}", next.name).as_str(),
                        );
                        found = true;
                    }
                }
                if !found {
                    imports.push(next.name);
                }
            }
        }
    }
    return imports;
}

pub fn imports_creation(compiler: &mut Compiler, next: AstToken) -> Vec<String> {
    let import = construct(compiler);
    let import_return = import.to_owned();
    let mut found = false;
    for i in import.iter() {
        match next.token {
            Token::Use => {
                if compiler.contains_use(i) {
                    display_hint_message(
                        format!("[{:?}]: Duplicate entry of [{}]", next.token, i).as_str(),
                    );
                    found = true;
                }
            }
            Token::Include => {
                if compiler.contains_inc(i) {
                    display_hint_message(
                        format!("[{:?}]: Duplicate entry of [{}]", next.token, i).as_str(),
                    );
                    found = true;
                }
            }
            _ => display_err_message(format!("[{:?}]: Unhandled import", next.token).as_str()),
        }
    }
    if !found {
        match next.token {
            Token::Use => compiler.add_use(import),
            Token::Include => compiler.add_inc(import),
            _ => display_err_message(format!("[{:?}]: Unhandled import", next.token).as_str()),
        }
    }
    import_return
}
