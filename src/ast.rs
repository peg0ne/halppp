use crate::{enums::token::Token, structs::ast_token::AstToken};

pub fn create(content: &String) -> Vec<AstToken> {
    let mut peekable = content.chars().peekable();
    let mut id = String::from("");
    let mut ast: Vec<AstToken> = Vec::new();
    while peekable.peek().is_some() {
        let c = peekable.next().unwrap();
        match Token::from(c.to_string()) {
            Token::Id => {}
            _ => {
                if id.len() > 0 {
                    let ast_token = AstToken {
                        name: id.to_owned(),
                        token: Token::from(id.to_owned()),
                    };
                    ast.push(ast_token);
                    id = String::new();
                }
                let ast_token = AstToken {
                    name: String::from(c),
                    token: Token::from(c.to_string()),
                };
                ast.push(ast_token);
                continue;
            }
        }
        if c == ' ' || c == '\t' || c == '\n' {
            if id.len() > 0 {
                let ast_token = AstToken {
                    name: id.to_owned(),
                    token: Token::from(id.to_owned()),
                };
                ast.push(ast_token);
                id = String::new();
            }
            if c == '\n' {
                let ast_token = AstToken {
                    name: String::from("\n"),
                    token: Token::NewLine,
                };
                ast.push(ast_token);
            }
            continue;
        }
        id.push(c);
    }
    let ast_token = AstToken {
        name: String::from("eof"),
        token: Token::EOF,
    };
    ast.push(ast_token);
    return ast;
}
