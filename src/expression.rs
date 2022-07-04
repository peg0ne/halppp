use crate::{
    enums::Token,
    structs::{Compiler, Expression},
    utils::get_next_or_exit,
};

pub fn construct(compiler: &mut Compiler, first: &str) -> Expression {
    let mut expression = String::from(first);
    loop {
        let x = get_next_or_exit(
            compiler.next(),
            "[Expression] Expression ended unexpectedly",
        );
        match x.token {
            Token::EOF => break,
            Token::NewLine => break,
            _ => {
                expression.push_str(" ");
                expression.push_str(x.name.as_str());
            }
        }
    }
    Expression {
        e_condition: None,
        e_for: None,
        line: Some(expression),
    }
}
