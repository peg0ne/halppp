use crate::{
    enums::Token,
    message::display_err_message,
    structs::{Compiler, Variable},
    utils::get_next_or_exit,
};

pub fn construct_args(compiler: &mut Compiler) -> (Variable, bool) {
    let mut variable = Variable::new();
    let mut is_end = false;
    loop {
        let next = get_next_or_exit(compiler.next(), "[Variable]: Invalid Declaration");
        match next.token {
            Token::CoolArrow => {
                is_end = true;
                break;
            }
            Token::NewLine => {
                is_end = true;
                break;
            }
            Token::Equals => variable.v_value = get_value(compiler),
            Token::Comma => break,
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

pub fn get_value(compiler: &mut Compiler) -> Option<String> {
    let mut value = String::new();
    let mut next = get_next_or_exit(compiler.next(), "[Variable]: Invalid value setter");
    match next.token {
        Token::Equals => {}
        _ => return None,
    }
    loop {
        next = get_next_or_exit(compiler.next(), "[Variable]: Invalid value setter");
        match next.token {
            Token::NewLine => return Some(value),
            _ => value.push_str(next.name.as_str()),
        }
    }
}

pub fn get_type(compiler: &mut Compiler) -> Variable {
    let next = get_next_or_exit(compiler.next(), "[Variable]: Invalid Function Return Value");
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
    return variable;
}
