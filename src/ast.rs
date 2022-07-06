use crate::{enums::Token, structs::AstToken};

pub fn create(content: &String) -> Vec<AstToken> {
    let mut peekable = content.chars().peekable();
    let mut id = String::from("");
    let mut ast: Vec<AstToken> = Vec::new();
    loop {
        let mut c = match peekable.next() {
            None => break,
            Some(c) => c,
        };
        if c == '"' {
            id = try_add_token(id, &mut ast);
            id.push(c);
            loop {
                let c = match peekable.next() {
                    None => break,
                    Some(c) => c,
                };
                id.push(c);
                if c == '"' { break; }
            }
            continue;
        }
        if c == '\'' {
            id = try_add_token(id, &mut ast);
            id.push(c);
            loop {
                let c = match peekable.next() {
                    None => break,
                    Some(c) => c,
                };
                id.push(c);
                if c == '\'' { break; }
            }
            continue;
        }
        if is_char_number(c) {
            let part_of_num = match peekable.peek() {
                Some(p) => p.to_owned() == '.' || is_char_number(p.to_owned()),
                None => false,
            };
            if part_of_num {
                id.push(c);
                loop {
                    let num = match peekable.next() {
                        None => break,
                        Some(c) => c,
                    };
                    if !is_char_number(num) && num != '.' {
                        c = num;
                        id = try_add_token(id, &mut ast);
                        break;
                    }
                    id.push(num)
                }
            }
        }
        if is_char_token(c) && id != "<" && c == '<' {
            let next = peekable.peek().unwrap_or(&' '); 
            let is_dbl = next == &'<';
            if is_dbl {
                id = try_add_token(id, &mut ast);
                id.push(c);
                c = match peekable.next() {
                    None => break,
                    Some(c) => c,
                };
                id.push(c);
                id = try_add_token(id, &mut ast);
                continue;
            }
        }
        if is_char_token(c) && id != ">" && c == '>' {
            let next = peekable.peek().unwrap_or(&' '); 
            let is_dbl = next == &'>';
            if is_dbl {
                id = try_add_token(id, &mut ast);
                id.push(c);
                c = match peekable.next() {
                    None => break,
                    Some(c) => c,
                };
                id.push(c);
                id = try_add_token(id, &mut ast);
                continue;
            }
        }
        if is_char_token(c) && id != "=" {
            let next = peekable.peek().unwrap_or(&' ');
            let is_cool = c == '=' && next == &'>';
            let is_equality = c == '=' && next == &'=';
            if !is_cool && !is_equality {
                id = try_add_token(id, &mut ast);
                ast.push(AstToken::from_char(c));
                continue;
            }
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

fn is_char_number(c: char) -> bool {
    match Token::from(c.to_string()) {
        Token::Number => true,
        _ => false,
    }
}