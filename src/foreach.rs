use crate::{
    condition,
    enums::Token,
    expression,
    structs::{Compiler, Expression, For},
    utils::{get_id_or_exit, get_next_or_exit},
};

pub fn construct(compiler: &mut Compiler) -> Expression {
    let mut for_def = For::new();
    for_def.iterator = get_id_or_exit(compiler.next(), "[For] For loop is not closed");
    get_next_or_exit(compiler.next(), "idk");
    for_def.until = compiler.next().unwrap().name.to_owned();
    loop {
        let x = get_next_or_exit(compiler.next(), "[For] For loop is not closed");
        match x.token {
            Token::Condition => {
                for_def.lines.push(condition::construct(compiler));
                continue;
            }
            Token::For => {
                for_def.lines.push(construct(compiler));
                continue;
            }
            Token::SemiColon => break,
            Token::EOF => break,
            Token::NewLine => continue,
            _ => {
                for_def
                    .lines
                    .push(expression::construct(compiler, x));
                continue;
            }
        }
    }
    // println!("{:?}", for_def);
    Expression {
        e_condition: None,
        e_for: Some(for_def),
        line: None,
    }
}
