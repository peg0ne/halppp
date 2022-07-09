use crate::{
    enums::Token,
    expression, foreach,
    structs::{Compiler, Condition, Expression, ConditionalExpression},
    utils::get_next_or_exit,
};

pub fn construct(compiler: &mut Compiler, condition_type: String) -> Expression {
    let mut condition_def = if condition_type != "elif" {
        Condition::new(condition_type)
    } else {
        Condition::new(String::from("else if"))
    };
    let mut expression = ConditionalExpression::new();
    loop {
        let x = get_next_or_exit(compiler.next(), "[Condition] Condition is not closed");
        if x.token.is_do() {
            condition_def.expressions.push(expression);
            condition_def.lines.push(expression::construct(compiler, x));
            return Expression {
                e_condition: Some(condition_def),
                e_for: None,
                line: None,
            }
        }
        if x.token.is_conditional_sep() {
            expression.continuation = x.name;
            condition_def.expressions.push(expression);
            expression = ConditionalExpression::new();
            continue;
        }
        if x.token.is_conditional() {
            expression.operator = x.name;
            continue;
        }
        match x.token {
            Token::NewLine => {
                condition_def.expressions.push(expression);
                break;
            },
            _ => {
                if expression.operator.len() == 0 {
                    expression.value1.push_str(x.name.as_str());
                    expression.value1.push_str(" ");
                } else {
                    expression.value2.push_str(x.name.as_str());
                    expression.value2.push_str(" ");
                }
                continue;
            }
        }
    }
    loop {
        let x = get_next_or_exit(compiler.next(), "[Condition] Condition is not closed");
        match x.token {
            Token::Condition => {
                condition_def.lines.push(construct(compiler, x.name));
                continue;
            }
            Token::For => {
                condition_def.lines.push(foreach::construct(compiler));
                continue;
            }
            Token::SemiColon => break,
            Token::EOF => break,
            Token::NewLine => continue,
            _ => {
                condition_def
                    .lines
                    .push(expression::construct(compiler, x));
                continue;
            }
        }
    }
    Expression {
        e_condition: Some(condition_def),
        e_for: None,
        line: None,
    }
}
