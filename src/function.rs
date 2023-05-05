use crate::{
    condition,
    enums::{Token, VariableState},
    expression, foreach,
    message::display_err_message,
    selects,
    matches,
    structs::{Compiler, Expression, Function, Variable},
    switch, template,
    utils::get_next_or_exit,
    variable,
};

pub fn construct(
    compiler: &mut Compiler,
    variable_state: VariableState,
    constructor: bool,
) -> Function {
    let mut function = Function::new(variable_state);
    if !constructor {
        let func_id = get_next_or_exit(compiler.next(), "[FunctionError]: No Function Id");
        let new_id = match func_id.token {
            Token::Id => func_id.name.to_owned(),
            Token::And => "operator".to_owned() + func_id.name.as_str(),
            Token::Sum => "operator".to_owned() + func_id.name.as_str(),
            Token::Sub => "operator".to_owned() + func_id.name.as_str(),
            Token::Equality => "operator".to_owned() + func_id.name.as_str(),
            Token::NonEquality => "operator".to_owned() + func_id.name.as_str(),
            Token::LBrack => "operator[]".to_owned(),
            _ => "".to_owned(),
        };
        if new_id == "" {
            display_err_message(format!("Expected id or operator got: {}", func_id.name).as_str())
        }
        function.id = new_id;
    }
    match compiler.peek() {
        Some(p) => match p.token {
            Token::LessThan => function.template = template::construct(compiler),
            _ => {}
        },
        None => display_err_message(
            format!("Error when trying to parse function: {}", function.id).as_str(),
        ),
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
        match compiler.peek() {
            Some(p) => {
                if p.token.is_do() {
                    function.return_value = Some(Variable::return_void())
                } else {
                    function.return_value = Some(variable::get_type(compiler));
                }
            }
            _ => {}
        }
    }
    // Set Inner Function stuff
    loop {
        let x = get_next_or_exit(
            compiler.next(),
            format!("Function is not closed [{}]", function.id).as_str(),
        );
        match x.token {
            Token::Foreach => function
                .expressions
                .push(foreach::construct(compiler, true)),
            Token::For => function
                .expressions
                .push(foreach::construct(compiler, false)),
            Token::Condition => function
                .expressions
                .push(condition::construct(compiler, x.name)),
            Token::Switch => function.expressions.push(switch::construct(compiler)),
            Token::Select => function.expressions.push(selects::construct(compiler)),
            Token::Match => function.expressions.push(matches::construct(compiler, None, false)),
            Token::SemiColon => break,
            Token::Function => break,
            Token::EOF => break,
            Token::NewLine => continue,
            _ => {
                function
                    .expressions
                    .push(expression::construct(compiler, x.to_owned()));
                if x.token.is_do() {
                    break;
                }
            }
        }
    }
    if function.id == String::from("main") {
        function.expressions.push(Expression {
            e_condition: None,
            e_for: None,
            e_select: None,
            e_match: None,
            line: Some(String::from("return 0")),
        });
    }
    validate(&function, compiler);
    compiler.add_fn(function.to_owned());
    return function;
}

fn validate(function: &Function, compiler: &Compiler) {
    // Check Duplicate Functions
    if compiler.contains_function(&function.id) {
        for f in compiler.program.functions.iter() {
            if f.arguments.len() != function.arguments.len() {
                return;
            }
            let mut i = 0;
            while i < f.arguments.len() {
                if f.arguments[i].v_type != function.arguments[i].v_type {
                    return;
                }
                i += 1;
            }
        }
        display_err_message(format!("Duplicate instances Function of: {}", function.id).as_str());
    }
}
