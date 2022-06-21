use crate::{
    enums::Token,
    foreach,
    structs::{Compiler, Condition},
    utils::{get_id_or_exit, get_next_or_exit},
};

pub fn construct(compiler: &mut Compiler) -> Condition {
    let mut condition_def = Condition::new();
    loop {
        let x = get_next_or_exit(compiler.next(), "[Condition] Condition is not closed");
        match x.token {
            Token::Condition => {
                construct(compiler);
                continue;
            }
            Token::For => {
                foreach::construct(compiler);
                continue;
            }
            Token::SemiColon => break,
            Token::EOF => break,
            _ => {}
        }
    }
    println!("{:?}", condition_def);
    return condition_def;
}
