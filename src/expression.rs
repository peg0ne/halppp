use crate::{
    enums::{Token, VariableState},
    structs::{Compiler, Expression, AstToken, Variable},
    utils::{get_next_or_exit, get_id_or_exit, get_or_exit, try_get}, matches, message::display_err_message, foreach, condition, switch, selects,
};

pub fn construct(compiler: &mut Compiler, first: AstToken) -> Expression {
    let mut doing = String::new();
    let mut expression = match first.token {
        Token::Do => String::from("\n"),
        Token::Doremi => String::from("\nreturn "),
        Token::Dore => {
            doing = String::from(";\nreturn ");
            String::from("\n")
        },
        Token::Dobr => {
            doing = String::from(";\nbreak ");
            String::from("\n")
        },
        Token::Doco => {
            doing = String::from(";\ncontinue ");
            String::from("\n")
        },
        Token::Return => String::from("return "),
        Token::Let => return get_let_expr(compiler),
        Token::MoreThan => return get_lambda_expr(compiler),
        _ => String::from(first.name),
    };
    loop {
        let x = get_next_or_exit(
            compiler.next(),
            "[Expression] Expression ended unexpectedly",
        );
        match x.token {
            Token::EOF => break,
            Token::NewLine => break,
            Token::Do => expression.push_str("\n"),
            Token::Dore => {
                expression.push_str("\n");
                doing = String::from(";\nreturn ");
            },
            Token::Dobr => {
                expression.push_str("\n");
                doing = String::from(";\nbreak ");
            },
            Token::Doco => {
                expression.push_str("\n");
                doing = String::from(";\ncontinue ");
            },
            Token::Doremi => expression.push_str("\nreturn "),
            Token::Let => expression.push_str("auto"),
            Token::Number => {
                expression.push_str(" ");
                expression.push_str(x.name.as_str());
            }
            Token::Id => {
                expression.push_str(" ");
                expression.push_str(x.name.as_str());
            }
            Token::Return => expression.push_str("return "),
            _ => {
                expression.push_str(x.name.as_str());
            }
        }
    }
    expression.push_str(doing.as_str());
    Expression {
        e_condition: None,
        e_for: None,
        e_select: None,
        e_match: None,
        e_variable: None,
        line: Some(expression),
    }
}

fn get_let_expr(compiler: &mut Compiler) -> Expression {
    let id = get_id_or_exit(compiler.next(), "[Let] Required id after let");
    get_or_exit(compiler.next(), Token::Equals, "[Let] Required equals after id");
    let mut value = String::new();
    if try_get(compiler.peek(), Token::Match) {
        compiler.next();
        return matches::construct(compiler, Some(id), true);
    }
    loop {
        let x = get_next_or_exit(compiler.next(), "[Let] Expected token got nothing");
        match x.token {
            Token::EOF => break,
            Token::NewLine => {
                let is_member = match compiler.peek() {
                    Some(t) => t.name.starts_with("."),
                    _ => false
                };
                if !is_member {break};
            }
            _ => value += x.name.as_str()
        }
        if x.token == Token::New { value += " " }
    }
    let token = Token::from(value.to_owned());
    let variable_type = if token.is_bool() {
        "bool ".to_owned() 
    } else if token.is_num() {
        "int ".to_owned()
    } else if token.is_char() {
        "char ".to_owned()
    } else if token.is_string() {
        "string ".to_owned()
    } else {
        "auto ".to_owned()
    };
    
    let v = Variable::from(id, variable_type, Some(value), VariableState::Private);
    Expression {
        e_condition: None,
        e_for: None,
        e_select: None,
        e_match: None,
        e_variable: Some(v),
        line: None,
    }
}

fn get_lambda_expr(compiler: &mut Compiler) -> Expression {
    let id = get_id_or_exit(compiler.next(), "[Lambda] Required id after >");
    let mut base = String::new();
    let mut has_return = false;
    let mut parameters: Vec<String> = Vec::new();
    let args;
    loop {
        let mut x = get_next_or_exit(compiler.next(), "[Lambda] Incomplete lambda");
        if x.token == Token::Id && x.name.starts_with("(") {
            args = x.name;
            break;
        }
        match x.token {
            Token::Id => parameters.push(x.name),
            _ => display_err_message("[Lambda] Incorrect parameter value")
        }
        x = get_next_or_exit(compiler.next(), "[Lambda] Incomplete lambda");
        if x.token == Token::Id && x.name.starts_with("(") {
            args = x.name;
            break;
        }
        if x.token == Token::Comma { parameters.push(",".to_owned()); }
        display_err_message("[Lambda] Comma missing");
    }
    base += "[";
    for p in parameters.iter() { base += p; }
    base += format!("]{} {{", args).as_str();
    let mut x = get_next_or_exit(compiler.next(), "[Lambda] Incomplete lambda");
    if x.token.is_do() {
        has_return = x.token == Token::Doremi;
        let expr = construct(compiler, x);
        base += expr.to_cpp(2).as_str()
    }
    else if x.token == Token::NewLine {
        loop {
            x = get_next_or_exit(compiler.next(), "[Lambda] Incomplete lambda");
            match x.token {
                Token::SemiColon => break,
                Token::Return => has_return = true,
                Token::NewLine => continue,
                _ => {}
            }
            let expression = match x.token {
                Token::Foreach => foreach::construct(compiler, true).to_cpp(2),
                Token::For => foreach::construct(compiler, false).to_cpp(2),
                Token::Condition => condition::construct(compiler, x.name).to_cpp(2),
                Token::Switch => switch::construct(compiler).to_cpp(2),
                Token::Select => selects::construct(compiler).to_cpp(2),
                Token::Match => matches::construct(compiler, None, false).to_cpp(2),
                _ => construct(compiler, x).to_cpp(2)
            };
            base += expression.as_str();
        }
    }
    if !has_return { base += "return true"; }
    base += "}";
    let v = Variable::from(id, "auto".to_owned(), Some(base), VariableState::Private);
    Expression {
        e_condition: None,
        e_for: None,
        e_select: None,
        e_match: None,
        e_variable: Some(v),
        line: None,
    }
}
