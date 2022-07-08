use crate::{
    enums::Token,
    message::{display_err_message, display_hint_message},
    structs::{AstToken, Compiler},
    utils::{get_next_or_exit, get_arrow_or_exit},
};

pub fn construct(compiler: &mut Compiler) -> Vec<String> {
    let mut imports: Vec<String> = Vec::new();
    get_arrow_or_exit(compiler.next(), "[Import]: Missing [=>] in declaration");
    let mut id = String::new();
    loop {
        let next = get_next_or_exit(compiler.next(), "[Import]: Import declaration invalid");
        match next.token {
            Token::NewLine => {
                let mut found = false;
                for i in imports.iter() {
                    if i.to_owned() == id {
                        display_hint_message(
                            format!("[Import]: Token duplicate in entry {}", id).as_str(),
                        );
                        found = true;
                    }
                }
                if !found {
                    imports.push(id);
                }
                break;
            },
            Token::EOF => {
                let mut found = false;
                for i in imports.iter() {
                    if i.to_owned() == id {
                        display_hint_message(
                            format!("[Import]: Token duplicate in entry {}", id).as_str(),
                        );
                        found = true;
                    }
                }
                if !found {
                    imports.push(id);
                }
                break;
            },
            Token::Comma => {
                let mut found = false;
                for i in imports.iter() {
                    if i.to_owned() == id {
                        display_hint_message(
                            format!("[Import]: Token duplicate in entry {}", id).as_str(),
                        );
                        found = true;
                    }
                }
                if !found {
                    imports.push(id);
                }
                id = String::new();
                continue;
            },
            _ => {
                if next.token.is_base() {
                    display_err_message(
                        format!("[Import]: Token not allowed: [{}]", next.name).as_str(),
                    );
                }
                id.push_str(next.name.as_str());
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
            Token::Get => {}
            _ => display_err_message(format!("[{:?}]: Unhandled import", next.token).as_str()),
        }
    }
    if !found {
        match next.token {
            Token::Use => compiler.add_use(import),
            Token::Include => compiler.add_inc(import),
            Token::Get => {},
            _ => display_err_message(format!("[{:?}]: Unhandled import", next.token).as_str()),
        }
    }
    import_return
}
