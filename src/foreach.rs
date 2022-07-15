use crate::{
    condition,
    enums::Token,
    expression,
    switch,
    structs::{Compiler, Expression, For},
    utils::{get_id_or_exit, get_next_or_exit, get_or_exit},
};

pub fn construct(compiler: &mut Compiler) -> Expression {
    let mut for_def = For::new();
    for_def.iterator = get_id_or_exit(compiler.next(), "[For] For loop is not closed");
    get_or_exit(compiler.next(), Token::Until, "[For] Missing until keyword");
    for_def.until = compiler.next().unwrap().name.to_owned();
    loop {
        let x = get_next_or_exit(compiler.next(), "[For] For loop is not closed");
        if x.token.is_do() {
            for_def.lines.push(expression::construct(compiler, x));
            return Expression {
                e_condition: None,
                e_for: Some(for_def),
                line: None,
            }
        }
        match x.token {
            Token::NewLine => break,
            _ => for_def.until.push_str(x.name.as_str()),
        }
    }
    loop {
        let x = get_next_or_exit(compiler.next(), "[For] For loop is not closed");
        match x.token {
            Token::Condition => {
                for_def.lines.push(condition::construct(compiler, x.name));
                continue;
            }
            Token::For => {
                for_def.lines.push(construct(compiler));
                continue;
            }
            Token::Switch => {
                for_def.lines.push(switch::construct(compiler));
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
