use crate::{
    enums::Token,
    expression, foreach, switch, selects,
    structs::{Compiler, Condition, Expression, ConditionalExpression},
    utils::get_next_or_exit, matches,
};

pub fn construct(compiler: &mut Compiler, condition_type: String) -> Expression {
    let mut condition_def = if condition_type == "elif" {
        Condition::new(String::from("else if"))
    } else if condition_type == "loop" {
        Condition::new(String::from("while"))
    } else {
        Condition::new(condition_type.to_owned())
    };
    let mut expression = ConditionalExpression::new();
    if condition_type == "loop" {
        expression.value1 = String::from("true");
    }
    loop {
        let x = get_next_or_exit(compiler.next(), "[Condition] Condition is not closed");
        if x.token.is_do() {
            condition_def.expressions.push(expression);
            condition_def.lines.push(expression::construct(compiler, x));
            return Expression {
                e_condition: Some(condition_def),
                e_for: None,
                e_select: None,
                e_match: None,
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
            Token::Condition => condition_def.lines.push(construct(compiler, x.name)),
            Token::Foreach => condition_def.lines.push(foreach::construct(compiler, true)),
            Token::For => condition_def.lines.push(foreach::construct(compiler, false)),
            Token::Switch => condition_def.lines.push(switch::construct(compiler)),
            Token::Select => condition_def.lines.push(selects::construct(compiler)),
            Token::Match => condition_def.lines.push(matches::construct(compiler, None, false)),
            Token::SemiColon => break,
            Token::EOF => break,
            Token::NewLine => continue,
            _ => condition_def.lines.push(expression::construct(compiler, x)),
                
        }
    }
    Expression {
        e_condition: Some(condition_def),
        e_for: None,
        e_select: None,
        e_match: None,
        line: None,
    }
}
