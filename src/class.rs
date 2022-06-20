use crate::{
    enums::{token::Token, variable_state::VariableState},
    function,
    message::display_err_message,
    structs::{class::Class, compiler::Compiler, variable::Variable},
    utils::get_next_or_exit,
};

pub fn construct(compiler: &mut Compiler) -> Class {
    // Create Class
    let mut class = Class {
        id: String::new(),
        inherit: None,
        functions: Vec::new(),
        variables: Vec::new(),
    };
    // Set Class Id
    let mut next = get_next_or_exit(compiler.next(), "invalid class definition");
    match next.token {
        Token::Id => class.id = next.name,
        _ => display_err_message(format!("Expected id got: {:?}", next.token).as_str()),
    }
    // Set Inheritance
    next = get_next_or_exit(
        compiler.next(),
        format!("Invalid class definition of: {}", class.id).as_str(),
    );
    match next.token {
        Token::CoolArrow => {
            next = get_next_or_exit(
                compiler.next(),
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
            compiler.next(),
            format!("Class is not closed [{}]", class.id).as_str(),
        );
        match x.token {
            Token::SemiColon => break,
            Token::Class => break,
            Token::Private => variable_state = VariableState::Private,
            Token::Protected => variable_state = VariableState::Protected,
            Token::Public => variable_state = VariableState::Public,
            Token::Function => {
                let function = function::construct(compiler, variable_state);
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
                    compiler.next(),
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
    validate(&class, compiler);
    return class;
}

fn validate(class: &Class, compiler: &Compiler) {
    // Check Duplicate Classes
    if compiler.contains_class(&class.id) {
        display_err_message(format!("Duplicate instances of: {}", class.id).as_str());
    }
    // Check Inheritance
    match &class.inherit {
        None => {}
        Some(i) => {
            if !compiler.contains_class(i) {
                display_err_message(
                    format!("Invalid Inheritance of: {}, Inherits: {:?}", class.id, i).as_str(),
                );
            }
        }
    }
}
