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
        let next = get_next_or_exit(compiler.next(), "[VariableError]: Invalid Declaration");
        match next.token {
            Token::CoolArrow => {
                is_end = true;
                break;
            }
            Token::NewLine => {
                is_end = true;
                break;
            }
            Token::Comma => break,
            _ => {
                if !variable.has_type() {
                    variable.v_type = next.name;
                } else if !variable.has_id() {
                    variable.id = next.name;
                } else {
                    display_err_message(
                        format!(
                            "[VariableError]: Variable declaration already complete:\n{:?}",
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
                "[VariableError]: Variable declaration incomplete:\n{:?}",
                variable
            )
            .as_str(),
        );
    }
    (variable, is_end)
}

pub fn get_type(compiler: &mut Compiler) -> Variable {
    let next = get_next_or_exit(
        compiler.next(),
        "[VariableError]: Invalid Function Return Value",
    );
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
                "[VariableError]: Expected return value type got:\n{:?}",
                next.token
            )
            .as_str(),
        ),
    }
    return variable;
}
