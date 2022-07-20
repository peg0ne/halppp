use crate::{
    enums::Token,
    structs::{Compiler, Expression, AstToken},
    utils::get_next_or_exit,
};

pub fn construct(compiler: &mut Compiler, first: AstToken) -> Expression {
    let mut doing = String::new();
    let mut expression = match first.token {
        Token::Do => String::from("\n"),
        Token::Doremi => String::from("\nreturn "),
        Token::Dore => {
            doing = String::from(";\nreturn ");
            String::from("\n")
        },
        Token::Dobr => {
            doing = String::from(";\nbreak ");
            String::from("\n")
        },
        Token::Doco => {
            doing = String::from(";\ncontinue ");
            String::from("\n")
        },
        Token::Let => String::from("auto"),
        Token::Return => String::from("return "),
        _ => String::from(first.name),
    };
    loop {
        let x = get_next_or_exit(
            compiler.next(),
            "[Expression] Expression ended unexpectedly",
        );
        match x.token {
            Token::EOF => break,
            Token::NewLine => break,
            Token::Do => expression.push_str("\n"),
            Token::Dore => {
                expression.push_str("\n");
                doing = String::from(";\nreturn ");
            },
            Token::Dobr => {
                expression.push_str("\n");
                doing = String::from(";\nbreak ");
            },
            Token::Doco => {
                expression.push_str("\n");
                doing = String::from(";\ncontinue ");
            },
            Token::Doremi => expression.push_str("\nreturn "),
            Token::Let => expression.push_str("auto"),
            Token::Number => {
                expression.push_str(" ");
                expression.push_str(x.name.as_str());
            }
            Token::Id => {
                expression.push_str(" ");
                expression.push_str(x.name.as_str());
            }
            Token::Return => expression.push_str("return "),
            _ => {
                expression.push_str(x.name.as_str());
            }
        }
    }
    expression.push_str(doing.as_str());
    Expression {
        e_condition: None,
        e_for: None,
        e_select: None,
        line: Some(expression),
    }
}
