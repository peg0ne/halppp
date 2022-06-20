use std::{iter::Peekable, slice::Iter};

use crate::{
    enums::{token::Token, variable_state::VariableState},
    function,
    message::display_err_message,
    structs::{ast_token::AstToken, class::Class, program::Program, variable::Variable},
    utils::get_next_or_exit,
};

pub fn construct(mut ast: Peekable<Iter<AstToken>>) -> (Class, Peekable<Iter<AstToken>>) {
    // Create Class
    let mut class = Class {
        id: String::new(),
        inherit: None,
        functions: Vec::new(),
        variables: Vec::new(),
    };
    // Set Class Id
    let mut next = get_next_or_exit(ast.next(), "invalid class definition");
    match next.token {
        Token::Id => class.id = next.name,
        _ => display_err_message(format!("Expected id got: {:?}", next.token).as_str()),
    }
    // Set Inheritance
    next = get_next_or_exit(
        ast.next(),
        format!("Invalid class definition of: {}", class.id).as_str(),
    );
    match next.token {
        Token::CoolArrow => {
            next = get_next_or_exit(
                ast.next(),
                format!("Invalid class definition of: {}", class.id).as_str(),
            );
            match next.token {
                Token::Id => class.inherit = Some(next.name),
                _ => display_err_message(
                    format!(
                        "Expected Id for inheritance for [{}] got: {:?}",
                        class.id, next.token
                    )
                    .as_str(),
                ),
            }
        }
        Token::NewLine => {}
        _ => {}
    }
    //Construct inner Class values
    let mut variable_state = VariableState::Private;
    loop {
        let x = get_next_or_exit(
            ast.next(),
            format!("Class is not closed [{}]", class.id).as_str(),
        );
        match x.token {
            Token::SemiColon => break,
            Token::Class => break,
            Token::Private => variable_state = VariableState::Private,
            Token::Protected => variable_state = VariableState::Protected,
            Token::Public => variable_state = VariableState::Public,
            Token::Function => {
                let (function, ast_) = function::construct(ast, variable_state);
                ast = ast_;
                class.functions.push(function);
            }
            Token::Type => {
                let mut variable = Variable {
                    id: String::new(),
                    v_type: x.name,
                    v_value: None,
                    variable_state: variable_state,
                };
                let v = get_next_or_exit(
                    ast.next(),
                    format!("Invalid variable declaration in class [{}]", class.id).as_str(),
                );
                match v.token {
                    Token::Id => variable.id = v.name,
                    _ => {}
                }
                class.variables.push(variable);
            }
            _ => {}
        }
    }
    return (class, ast);
}

pub fn validate(class: &Class, program: &Program) {
    // Check Duplicate Classes
    for c in program.classes.iter() {
        if c.id == class.id {
            display_err_message(
                format!("Duplicate instances of: {}, Inherits: {}", class.id, c.id).as_str(),
            );
        }
    }
    // Check Inheritance
    match &class.inherit {
        None => {}
        Some(i) => {
            for c in program.classes.iter() {
                if c.id == i.to_string() {
                    return;
                }
            }
            display_err_message(
                format!("Invalid Inheritance of: {}, Inherits: {:?}", class.id, i).as_str(),
            );
        }
    }
}
