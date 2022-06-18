use std::{iter::Peekable, slice::Iter};

use crate::{
    message::display_err_message,
    structs::{Class, Program},
    utils::get_next_or_exit,
    Token,
};

pub fn construct(
    mut ast: Peekable<Iter<(String, Token)>>,
) -> (Class, Peekable<Iter<(String, Token)>>) {
    // Create Class
    let mut class = Class {
        id: String::new(),
        inherit: None,
        functions: Vec::new(),
        variables: Vec::new(),
    };
    // Set Class Id
    let mut next = get_next_or_exit(ast.next(), "invalid class definition");
    if class.id.len() == 0 {
        match next.1 {
            Token::Id => class.id = next.0.to_owned(),
            _ => display_err_message(format!("Expected id got: {:?}", next.1).as_str()),
        }
    }
    // Set Inheritance
    next = get_next_or_exit(
        ast.next(),
        format!("Invalid class definition of: {}", class.id).as_str(),
    );
    match next.1 {
        Token::CoolArrow => {
            next = get_next_or_exit(
                ast.next(),
                format!("Invalid class definition of: {}", class.id).as_str(),
            );
            match next.1 {
                Token::Id => class.inherit = Some(next.0.to_owned()),
                _ => display_err_message(
                    format!(
                        "Expected Id for inheritance for [{}] got: {:?}",
                        class.id, next.1
                    )
                    .as_str(),
                ),
            }
        }
        _ => {}
    }
    //Construct inner Class values
    loop {
        let x = get_next_or_exit(
            ast.next(),
            format!("Class is not closed [{}]", class.id).as_str(),
        );
        match x.1 {
            Token::SemiColon => break,
            Token::Class => break,
            Token::Private => {}   //Handle public variable creation
            Token::Protected => {} //Handle protected variable creation
            Token::Public => {}    //Handle public variable creation
            Token::Function => {}  //Handle function creation
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
