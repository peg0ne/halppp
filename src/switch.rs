use crate::{
    expression, condition, foreach, selects,
    enums::Token,
    structs::{Compiler, Condition, Expression, ConditionalExpression},
    utils::{get_next_or_exit, try_get},
    message::display_err_message, matches,
};

pub fn construct(compiler: &mut Compiler) -> Expression {
    let mut condition_def = Condition::new(String::from("switch"));
    let mut expression = ConditionalExpression::new();
    loop {
        let x = get_next_or_exit(compiler.next(), "[Switch] Switch is not closed");
        if x.token.is_do() {
            display_err_message("[Switch] Switch statements cannot have a do parameter")
        }
        match x.token {
            Token::NewLine => {
                condition_def.expressions.push(expression);
                break;
            },
            _ => {
                expression.value1.push_str(x.name.as_str());
                expression.value1.push_str(" ");
            }
        }
    }
    loop {
        let x = get_next_or_exit(compiler.next(), "[Switch] Switch is not closed");
        match x.token {
            Token::Case => {
                let result = create_case(compiler, false);
                for i in result.iter() {
                    condition_def.lines.push(i.to_owned());
                }
                break;
            },
            Token::Default => {
                let result = create_case(compiler, true);
                for i in result.iter() {
                    condition_def.lines.push(i.to_owned());
                }
                break;
            },
            Token::SemiColon => break,
            Token::EOF => break,
            Token::NewLine => continue,
            _ => display_err_message(format!("[Switch] Token not allowed in switch {:?}", x.token).as_str()),
        }
    }
    Expression {
        e_condition: Some(condition_def),
        e_for: None,
        e_select: None,
        e_match: None,
        e_variable: None,
        line: None,
    }
}

fn create_case(compiler: &mut Compiler, is_default: bool) -> Vec<Expression> {
    let mut lines: Vec<Expression> = Vec::new();
    if !is_default {
        let next = get_next_or_exit(compiler.next(), "[Switch] Case has to be followed by an Id");
        let mut id = next.name;
        match next.token {
            Token::Id => {
                if !compiler.contains_enum(&id) {
                    display_err_message("[Switch] Enum member doesn't exist")
                }
                if try_get(compiler.peek(), Token::DblColon) {
                    id.push_str("::");
                    compiler.next();
                    let enum_name = get_next_or_exit(compiler.next(), "[Switch] Unexpected end");
                    id.push_str(enum_name.name.as_str());
                }
            }
            Token::Char => {}
            Token::Number => {}
            _ => display_err_message(format!("[Switch] Token not allowed in switch: {:?}", next.token).as_str()),
        }
        lines.push(Expression {
            e_condition: None,
            e_for: None,
            e_select: None,
            e_match: None,
            e_variable: None,
            line: Some(format!("case {}:\n", id))
        });
    }
    else {
        lines.push(Expression {
            e_condition: None,
            e_for: None,
            e_select: None,
            e_match: None,
            e_variable: None,
            line: Some(String::from("default:\n"))
        });
    }
    loop {
        let x = get_next_or_exit(compiler.next(), "[Switch] Case unfinished");
        match x.token {
            Token::Case => {
                let result = create_case(compiler, false);
                for i in result.iter() {
                    lines.push(i.to_owned());
                }
                return lines;
            },
            Token::Default => {
                let result = create_case(compiler, true);
                for i in result.iter() {
                    lines.push(i.to_owned());
                }
                return lines;
            },
            Token::SemiColon => return lines,
            Token::NewLine => {},
            Token::Foreach => lines.push(foreach::construct(compiler, true)),
            Token::For => lines.push(foreach::construct(compiler, false)),
            Token::Select => lines.push(selects::construct(compiler)),
            Token::Switch => lines.push(construct(compiler)),
            Token::Condition => lines.push(condition::construct(compiler, x.name)),
            Token::Match => lines.push(matches::construct(compiler, None, false)),
            _ => lines.push(expression::construct(compiler, x)),
        }
    }
}
