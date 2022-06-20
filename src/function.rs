use crate::{
    enums::{token::Token, variable_state::VariableState},
    message::display_err_message,
    structs::{compiler::Compiler, function::Function, variable::Variable},
    utils::get_next_or_exit,
};

pub fn construct(compiler: &mut Compiler, variable_state: VariableState) -> Function {
    //Create Function
    let mut function = Function {
        id: String::new(),
        arguments: vec![],
        return_value: None,
        variable_state: variable_state,
    };
    // Set Function Id
    let mut next = get_next_or_exit(compiler.ast.next(), "invalid function definition");
    match next.token {
        Token::Id => function.id = next.name,
        _ => display_err_message(format!("Expected id got: {:?}", next.token).as_str()),
    }
    // Set Arguments
    let mut variable = Variable::new();
    loop {
        next = get_next_or_exit(
            compiler.ast.next(),
            format!("Invalid function definition of: {}", function.id).as_str(),
        );
        match next.token {
            Token::CoolArrow => {
                if variable.has_minimum() {
                    function.arguments.push(variable.to_owned());
                }
                break;
            }
            Token::NewLine => continue,
            Token::Comma => {
                if !variable.has_minimum() {
                    display_err_message(format!("Invalid variable declaration in arguments: [VARIABLE DECLARATION INVALID] {:?}", variable).as_str());
                }

                function.arguments.push(variable.to_owned());
                variable = Variable::new();
            }
            _ => {
                if !variable.has_type() {
                    variable.v_type = next.name;
                } else if !variable.has_id() {
                    variable.id = next.name;
                } else {
                    display_err_message(format!("Invalid variable declaration in arguments: [VARIABLE ALREADY DECLARED] {:?}", variable).as_str());
                }
            }
        }
    }
    // Set Return Value
    next = get_next_or_exit(compiler.ast.next(), "Invalid Function Return Value");
    variable = Variable::return_void();
    match next.token {
        Token::Id => {
            variable.v_type = next.name;
        }
        Token::Type => {
            variable.v_type = next.name;
        }
        Token::NewLine => {}
        _ => display_err_message(
            format!("Expected return value type got: {:?}", next.token).as_str(),
        ),
    }
    function.return_value = Some(variable);
    // Set Inner Function stuff
    loop {
        let x = get_next_or_exit(
            compiler.ast.next(),
            format!("Function is not closed [{}]", function.id).as_str(),
        );
        match x.token {
            Token::SemiColon => break,
            Token::Function => break,
            Token::EOF => break,
            _ => {}
        }
    }
    validate(&function, compiler);
    return function;
}

fn validate(function: &Function, compiler: &Compiler) {
    // Check Duplicate Functions
    if compiler.contains_function(&function.id) {
        display_err_message(format!("Duplicate instances Function of: {}", function.id).as_str());
    }
}
