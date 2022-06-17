use crate::tokens::Token;

pub fn create(content: &String) -> Vec<(String, Token)> {
    let mut peekable = content.chars().peekable();
    let mut id = String::from("");
    let mut ast: Vec<(String, Token)> = Vec::new();
    while peekable.peek().is_some() {
        let c = peekable.next().unwrap();
        if c == ' ' || c == '\n' || c == '\t' {
            if id.len() > 0 {
                ast.push((id.to_owned(), Token::from(id.to_owned())));
                id = String::new();
            }
            continue;            
        }
        id.push(c);
    }
    return ast;
}