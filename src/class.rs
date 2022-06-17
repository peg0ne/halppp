use std::{iter::Peekable, slice::Iter};

use crate::{structs::Class, utils::err_return_none, Token};

pub fn construct(
    mut ast: Peekable<Iter<(String, Token)>>,
) -> Option<(Class, Peekable<Iter<(String, Token)>>)> {
    let mut class = Class {
        id: String::new(),
        inherit: None,
        functions: Vec::new(),
        variables: Vec::new(),
    };
    if ast.peek().is_none() {
        return err_return_none("Invalid class definition");
    }
    let mut next = ast.next().unwrap();
    if class.id.len() == 0 {
        match next.1 {
            Token::Id => class.id = next.0.to_owned(),
            _ => {
                return err_return_none::<(Class, Peekable<Iter<(String, Token)>>)>(
                    format!("Expected id got: {:?}", next.1).as_str(),
                );
            }
        }
    }
    if ast.peek().is_none() {
        return err_return_none(format!("Invalid class definition of: {}", class.id).as_str());
    }
    next = ast.next().unwrap();
    match next.1 {
        Token::CoolArrow => {
            if ast.peek().is_none() {
                return err_return_none(
                    format!("Invalid class definition of: {}", class.id).as_str(),
                );
            }
            next = ast.next().unwrap();
            match next.1 {
                Token::Id => class.inherit = Some(next.0.to_owned()),
                _ => {
                    return err_return_none::<(Class, Peekable<Iter<(String, Token)>>)>(
                        format!(
                            "Expected Id for inheritance for [{}] got: {:?}",
                            class.id, next.1
                        )
                        .as_str(),
                    );
                }
            }
        }
        _ => {}
    }
    loop {
        if ast.peek().is_none() {
            return err_return_none(format!("Class is not closed [{}]", class.id).as_str());
        }
        let x = ast.next().unwrap();
        match x.1 {
            Token::SemiColon => break,
            Token::Class => break,
            _ => {}
        }
    }
    return Some((class, ast));
}
