use crate::{
    enums::Token,
    message::display_err_message,
    structs::{Compiler, Variable},
    utils::{GetNextOrExit, GetOrExit, TryGet},
};

pub fn construct_args(compiler: &mut Compiler, type_name: Option<String>) -> (Variable, bool) {
    let mut variable = Variable::new();
    if type_name.is_some() {variable.v_type = type_name.unwrap()}
    let mut is_end = false;
    loop {
        let mut next = GetNextOrExit(compiler.next(), "[Variable]: Invalid Declaration");
        match next.token {
            Token::CoolArrow => {
                is_end = true;
                break;
            }
            Token::NewLine => {
                is_end = true;
                break;
            }
            Token::Equals => {
                variable.v_value = get_value(compiler, true);
                break;
            },
            Token::Comma => break,
            Token::Asterix => {
                if !variable.has_type() {
                    display_err_message(
                        format!(
                            "[Variable]: Pointer infront of type not allowed:\n{:?}",
                            variable
                        )
                        .as_str(),
                    );
                }
                variable.v_type.push_str(next.name.as_str());
            }
            Token::LessThan => {
                if !variable.has_id() && !variable.has_type() {
                    display_err_message(
                        format!(
                            "[Variable]: Variable declaration cannot have template without id and type:\n{:?}",
                            variable
                        )
                        .as_str(),
                    );
                }
                variable.v_type.push_str("<");
                loop {
                    next = GetNextOrExit(compiler.next(), "[Variable]: Invalid Declaration");
                    match next.token {
                        Token::MoreThan => {
                            variable.v_type.push_str(">");
                            break;
                        }
                        _ => variable.v_type.push_str(next.name.as_str()),
                    }
                }
                continue;
            }
            _ => {
                if !variable.has_type() {
                    variable.v_type = next.name;
                } else if !variable.has_id() {
                    variable.id = next.name;
                } else {
                    display_err_message(
                        format!(
                            "[Variable]: Variable declaration already complete:\n{:?}",
                            variable
                        )
                        .as_str(),
                    );
                }
            }
        }
    }
    if !variable.has_minimum() && !is_end {
        display_err_message(
            format!(
                "[Variable]: Variable declaration incomplete:\n{:?}",
                variable
            )
            .as_str(),
        );
    }
    (variable, is_end)
}

pub fn get_value(compiler: &mut Compiler, found_setter: bool) -> Option<String> {
    let mut value = String::new();
    let mut next;
    if !found_setter { GetOrExit(compiler.next(), Token::Equals, "[Variable]: Invalid value setter"); }
    loop {
        next = GetNextOrExit(compiler.next(), "[Variable]: Invalid value");
        match next.token {
            Token::NewLine => {
                if value.len() == 0 { return None; }
                else { return Some(value); }
            },
            _ => value.push_str(next.name.as_str()),
        }
    }
}

pub fn get_type(compiler: &mut Compiler) -> Variable {
    let mut next = GetNextOrExit(compiler.next(), "[Variable]: Invalid Function Return Value");
    let mut variable = Variable::return_void();
    match next.token {
        Token::Id => {
            variable.v_type = next.name;
        }
        Token::Type => {
            variable.v_type = next.name;
        }
        Token::NewLine => {}
        _ => display_err_message(
            format!(
                "[Variable]: Expected return value type got:\n{:?}",
                next.token
            )
            .as_str(),
        ),
    }
    if TryGet(compiler.peek(), Token::LessThan) {
        if !variable.has_id() {
            display_err_message(
                format!(
                    "[Variable]: Variable declaration cannot have template without id:\n{:?}",
                    variable
                )
                .as_str(),
            );
        }
        next = GetNextOrExit(compiler.next(), "[Variable]: Invalid Declaration");
        variable.v_type.push_str(next.name.as_str());
        loop {
            next = GetNextOrExit(compiler.next(), "[Variable]: Invalid Declaration");
            match next.token {
                Token::MoreThan => {
                    variable.v_type.push_str(next.name.as_str());
                    break;
                }
                _ => variable.v_type.push_str(next.name.as_str()),
            }
        }
    }
    return variable;
}
