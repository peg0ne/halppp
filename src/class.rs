use crate::{
    enums::{Token, VariableState},
    function,
    message::display_err_message,
    structs::{Class, Compiler, Variable},
    utils::{get_id_or_exit, get_next_or_exit},
    variable,
    template,
};

pub fn construct(compiler: &mut Compiler, is_struct: bool) -> Class {
    let mut class = Class::new();
    class.is_struct = is_struct;
    class.id = get_id_or_exit(compiler.next(), "[ClassError] Invalid Class Declaration");
    // Set Inheritance Or Template
    let mut next = get_next_or_exit(
        compiler.next(),
        format!("[ClassError] Invalid class definition of: [{}]", class.id).as_str(),
    );
    match next.token {
        Token::LessThan => {
            class.template = template::construct(compiler);
            next = get_next_or_exit(
                compiler.next(),
                format!("[ClassError] Invalid class definition of: [{}]", class.id).as_str(),
            );
            match next.token {
                Token::CoolArrow => {
                    class.inherit = Some(get_id_or_exit(
                        compiler.next(),
                        format!(
                            "[ClassError] Invalid Inheritor Token\nExpected Id for inheritance for class: [{}]",
                            class.id
                        ).as_str(),
                    ));
                }
                _ => {}
            }
        }
        Token::CoolArrow => {
            class.inherit = Some(get_id_or_exit(
                compiler.next(),
                format!(
                    "[ClassError] Invalid Inheritor Token\nExpected Id for inheritance for class: [{}]",
                    class.id
                ).as_str(),
            ));
        }
        _ => {}
    }
    //Construct inner Class values
    let mut variable_state = if !is_struct { VariableState::Private } else { VariableState::Public };
    loop {
        let next = get_next_or_exit(
            compiler.next(),
            format!("[ClassError] Class is not closed [{}]", class.id).as_str(),
        );
        match next.token {
            Token::SemiColon => break,
            Token::Class => break,
            Token::Private => variable_state = VariableState::Private,
            Token::Protected => variable_state = VariableState::Protected,
            Token::Public => variable_state = VariableState::Public,
            Token::Function => {
                let function = function::construct(compiler, variable_state, false);
                class.functions.push(function);
            }
            Token::Id => {
                if next.name == class.id {
                    let mut function = function::construct(compiler, VariableState::Public, true);
                    function.return_value = Some(
                        Variable::from(String::from(""),
                        class.id.to_owned(),
                        None,
                        VariableState::Private
                    ));
                    class.functions.push(function);
                    continue;
                } 
                let (mut variable, _) = variable::construct_args(compiler, Some(next.name));
                variable.variable_state = variable_state;
                class.variables.push(variable)
            }
            Token::Type => {
                let (mut variable, _) = variable::construct_args(compiler, Some(next.name));
                variable.variable_state = variable_state;
                class.variables.push(variable)
            },
            _ => {}
        }
    }
    validate(&class, compiler);
    compiler.add_class(class.to_owned());
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
