use crate::{
    condition,
    enums::{Token, VariableState},
    expression, foreach,
    message::display_err_message,
    structs::{Compiler, Function, Variable, Expression},
    utils::{get_id_or_exit, get_next_or_exit},
    variable,
    template,
};

pub fn construct(compiler: &mut Compiler, variable_state: VariableState, constructor: bool) -> Function {
    let mut function = Function::new(variable_state);
    if !constructor {
        function.id = get_id_or_exit(compiler.next(), "[FunctionError]: No Function Id");
    }
    match compiler.peek() {
        Some(p) => {
            match p.token {
                Token::LessThan => function.template = template::construct(compiler),
                _ => {}
            }
        }
        None => {
            display_err_message(format!("Error when trying to parse function: {}", function.id).as_str());
        }
    }
    loop {
        let (variable, is_end) = variable::construct_args(compiler, None);
        if !variable.has_minimum() {
            break;
        }
        function.arguments.push(variable.to_owned());
        if is_end {
            break;
        }
    }
    if function.id == String::from("main") {
        function.arguments.push(Variable::from(
            String::from("argc"),
            String::from("int"),
            None,
            VariableState::Private,
        ));
        function.arguments.push(Variable::from(
            String::from("argv[]"),
            String::from("char*"),
            None,
            VariableState::Private,
        ));
        function.return_value = Some(Variable::from(
            String::from(""),
            String::from("int"),
            None,
            VariableState::Private,
        ));
    } else {
        function.return_value = Some(variable::get_type(compiler));
    }
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
            _ => {
                function.expressions.push(expression::construct(compiler, x.to_owned()));
                match x.token {
                    Token::Do => break,
                    Token::Dore => break,
                    Token::Doremi => break,
                    Token::Doco => break,
                    Token::Dobr => break,
                    _ => {}
                };
            }
        }
    }
    if function.id == String::from("main") {
        function.expressions.push(Expression {
            e_condition: None,
            e_for: None,
            line: Some(String::from("return 0")),
        });
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
