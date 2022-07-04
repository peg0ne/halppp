use crate::{
    enums::Token,
    expression, foreach,
    structs::{Compiler, Condition, Expression},
    utils::{get_id_or_exit, get_next_or_exit},
};

pub fn construct(compiler: &mut Compiler) -> Expression {
    let mut condition_def = Condition::new();
    loop {
        let x = get_next_or_exit(compiler.next(), "[Condition] Condition is not closed");
        match x.token {
            Token::Condition => {
                condition_def.lines.push(construct(compiler));
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
                    .push(expression::construct(compiler, x.name.as_str()));
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
