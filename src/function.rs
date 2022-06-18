use std::{iter::Peekable, slice::Iter};

use crate::{
    message::display_err_message,
    structs::{Function, Program},
    utils::get_next_or_exit,
    Token,
};

pub fn construct(
    mut ast: Peekable<Iter<(String, Token)>>,
) -> (Function, Peekable<Iter<(String, Token)>>) {
    let mut function = Function {
        id: String::new(),
        arguments: vec![],
        return_value: None,
        is_public: false,
    };
    let mut next = get_next_or_exit(ast.next(), "invalid function definition");
    if function.id.len() == 0 {
        match next.1 {
            Token::Id => function.id = next.0.to_owned(),
            _ => display_err_message(format!("Expected id got: {:?}", next.1).as_str()),
        }
    }
    loop {
        next = get_next_or_exit(
            ast.next(),
            format!("Invalid function definition of: {}", function.id).as_str(),
        );
        match next.1 {
            Token::CoolArrow => {
                next = get_next_or_exit(
                    ast.next(),
                    format!("Invalid function definition of: {}", function.id).as_str(),
                );
                match next.1 {
                    Token::Id => function.return_value = Some(next.0.to_owned()),
                    _ => display_err_message(
                        format!(
                            "Expected Id for inheritance for [{}] got: {:?}",
                            function.id, next.1
                        )
                        .as_str(),
                    ),
                }
            }
            _ => break,
        }
    }
    loop {
        let x = get_next_or_exit(
            ast.next(),
            format!("Class is not closed [{}]", function.id).as_str(),
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
