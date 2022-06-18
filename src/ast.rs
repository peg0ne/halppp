use crate::tokens::Token;

pub fn create(content: &String) -> Vec<(String, Token)> {
    let mut peekable = content.chars().peekable();
    let mut id = String::from("");
    let mut ast: Vec<(String, Token)> = Vec::new();
    while peekable.peek().is_some() {
        let c = peekable.next().unwrap();
        match Token::from(c.to_string()) {
            Token::Id => {}
            _ => {
                if id.len() > 0 {
                    ast.push((id.to_owned(), Token::from(id.to_owned())));
                    id = String::new();
                }
                ast.push((String::from(c), Token::from(c.to_string())));
                continue;
            }
        }
        if c == ' ' || c == '\t' || c == '\n' {
            if id.len() > 0 {
                ast.push((id.to_owned(), Token::from(id.to_owned())));
                id = String::new();
            }
            if c == '\n' {
                ast.push((String::from("\n"), Token::NewLine));
            }
            continue;
        }
        id.push(c);
    }
    ast.push((String::from("eof"), Token::EOF));
    return ast;
}
