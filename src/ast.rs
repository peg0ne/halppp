use crate::{enums::Token, structs::AstToken};

pub fn create(content: &String) -> Vec<AstToken> {
    let mut peekable = content.chars().peekable();
    let mut id = String::from("");
    let mut ast: Vec<AstToken> = Vec::new();
    loop {
        let c = match peekable.next() {
            None => break,
            Some(c) => c,
        };
        if is_char_token(c) {
            id = try_add_token(id, &mut ast);
            ast.push(AstToken::from_char(c));
            continue;
        }
        if c == ' ' || c == '\t' || c == '\n' {
            id = try_add_token(id, &mut ast);
            if c == '\n' {
                ast.push(AstToken::new_line());
            }
            continue;
        }
        id.push(c);
    }
    //Push extra sets of EOF to ensure it wont break badly
    ast.push(AstToken::eof());
    ast.push(AstToken::eof());
    ast.push(AstToken::eof());
    return ast;
}

fn try_add_token(id: String, ast: &mut Vec<AstToken>) -> String {
    if id.len() > 0 {
        ast.push(AstToken::from_id(id));
        return String::new();
    }
    id
}

fn is_char_token(c: char) -> bool {
    match Token::from(c.to_string()) {
        Token::Id => false,
        _ => true,
    }
}
