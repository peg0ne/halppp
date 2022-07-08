use crate::{
    enums::Token,
    expression, foreach,
    structs::{Compiler, Condition, Expression},
    utils::get_next_or_exit,
};

pub fn construct(compiler: &mut Compiler, condition_type: String) -> Expression {
    let mut condition_def = Condition::new(condition_type);
    loop {
        let x = get_next_or_exit(compiler.next(), "[Condition] Condition is not closed");
        if x.token.is_do() {
            condition_def.lines.push(expression::construct(compiler, x));
            return Expression {
                e_condition: Some(condition_def),
                e_for: None,
                line: None,
            }
        }
        match x.token {
            Token::NewLine => break,
            _ => {
                condition_def.value1.push_str(x.name.as_str());
                condition_def.value1.push_str(" ");
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
    // println!("{:?}", condition_def);
    Expression {
        e_condition: Some(condition_def),
        e_for: None,
        line: None,
    }
}