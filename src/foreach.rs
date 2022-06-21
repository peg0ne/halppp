use crate::{
    condition,
    enums::Token,
    structs::{Compiler, For},
    utils::{get_id_or_exit, get_next_or_exit},
};

pub fn construct(compiler: &mut Compiler) -> For {
    let mut for_def = For::new();
    for_def.iterator = get_id_or_exit(compiler.next(), "[For] For loop is not closed");
    get_next_or_exit(compiler.next(), "idk");
    for_def.until = compiler.next().unwrap().name.to_owned();
    loop {
        let x = get_next_or_exit(compiler.next(), "[For] For loop is not closed");
        match x.token {
            Token::Condition => {
                condition::construct(compiler);
                continue;
            }
            Token::For => {
                construct(compiler);
                continue;
            }
            Token::SemiColon => break,
            Token::EOF => break,
            _ => {}
        }
    }
    println!("{:?}", for_def);
    return for_def;
}
