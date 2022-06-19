use std::{iter::Peekable, slice::Iter};

use crate::{
    message::display_err_message,
    structs::{Function, Program, Variable, VariableState},
    utils::get_next_or_exit,
    Token,
};

pub fn construct(
    mut ast: Peekable<Iter<(String, Token)>>,
    variable_state: VariableState,
) -> (Function, Peekable<Iter<(String, Token)>>) {
    //Create Function
    let mut function = Function {
        id: String::new(),
        arguments: vec![],
        return_value: None,
        variable_state: variable_state,
    };
    // Set Function Id
    let mut next = get_next_or_exit(ast.next(), "invalid function definition");
    match next.1 {
        Token::Id => function.id = next.0.to_owned(),
        _ => display_err_message(format!("Expected id got: {:?}", next.1).as_str()),
    }
    // Set Arguments
    let mut variable = Variable {
        id: String::new(),
        v_type: String::new(),
        v_value: None,
        variable_state: VariableState::Private,
    };
    loop {
        next = get_next_or_exit(
            ast.next(),
            format!("Invalid function definition of: {}", function.id).as_str(),
        );
        match next.1 {
            Token::CoolArrow => {
                if !variable.has_minimum() {
                    break;
                }

                function.arguments.push(variable.to_owned());
                variable.v_type = String::new();
                variable.id = String::new();
                break;
            }
            Token::NewLine => continue,
            Token::Comma => {
                if !variable.has_minimum() {
                    display_err_message(format!("Invalid variable declaration in arguments: [VARIABLE DECLARATION INVALID] {:?}", variable).as_str());
                }

                function.arguments.push(variable.to_owned());
                variable.v_type = String::new();
                variable.id = String::new();
            }
            _ => {
                if !variable.has_type() {
                    variable.v_type = next.0;
                } else if !variable.has_id() {
                    variable.id = next.0;
                } else {
                    display_err_message(format!("Invalid variable declaration in arguments: [VARIABLE ALREADY DECLARED] {:?}", variable).as_str());
                }
            }
        }
    }
    // Set Return Value
    next = get_next_or_exit(ast.next(), "Invalid Function Return Value");
    variable = Variable {
        id: String::from("return_value"),
        v_type: String::from("void"),
        v_value: None,
        variable_state: VariableState::Private,
    };
    match next.1 {
        Token::Id => {
            variable.v_type = next.0;
        }
        Token::Type => {
            variable.v_type = next.0;
        }
        Token::NewLine => {}
        _ => display_err_message(format!("Expected return value type got: {:?}", next.1).as_str()),
    }
    function.return_value = Some(variable);
    // Set Inner Function stuff
    loop {
        let x = get_next_or_exit(
            ast.next(),
            format!("Function is not closed [{}]", function.id).as_str(),
        );
        match x.1 {
            Token::SemiColon => break,
            Token::Function => break,
            Token::EOF => break,
            _ => {}
        }
    }
    return (function, ast);
}

pub fn validate(function: &Function, program: &Program) {
    // Check Duplicate Functions
    for f in program.functions.iter() {
        if f.id == function.id {
            display_err_message(
                format!(
                    "Duplicate instances of: {}, Inherits: {}",
                    function.id, f.id
                )
                .as_str(),
            );
        }
    }
}
