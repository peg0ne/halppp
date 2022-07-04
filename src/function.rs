use crate::{
    condition,
    enums::{Token, VariableState},
    expression, foreach,
    message::display_err_message,
    structs::{Compiler, Function},
    utils::{get_id_or_exit, get_next_or_exit},
    variable,
};

pub fn construct(compiler: &mut Compiler, variable_state: VariableState) -> Function {
    let mut function = Function::new(variable_state);
    function.id = get_id_or_exit(compiler.next(), "[FunctionError]: No Function Id");
    loop {
        let (variable, is_end) = variable::construct_args(compiler);
        if !variable.has_minimum() {
            break;
        }
        function.arguments.push(variable.to_owned());
        if is_end {
            break;
        }
    }
    function.return_value = Some(variable::get_type(compiler));
    // Set Inner Function stuff
    loop {
        let x = get_next_or_exit(
            compiler.next(),
            format!("Function is not closed [{}]", function.id).as_str(),
        );
        match x.token {
            Token::For => function.expressions.push(foreach::construct(compiler)),
            Token::Condition => function.expressions.push(condition::construct(compiler)),
            Token::SemiColon => break,
            Token::Function => break,
            Token::EOF => break,
            Token::NewLine => continue,
            _ => function
                .expressions
                .push(expression::construct(compiler, x.name.as_str())),
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
