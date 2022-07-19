use crate::{enums::Token, structs::AstToken};
use std::{iter::Peekable, str::Chars};

pub fn create(content: &String) -> Vec<AstToken> {
    let mut peekable = content.chars().peekable();
    let mut id = String::from("");
    let mut ast: Vec<AstToken> = Vec::new();
    loop {
        let c = match peekable.next() {
            None => break,
            Some(c) => c,
        };
        if c == '"' || c == '\'' {
            let string = collect_string(&mut peekable, c);
            id = try_add_token(id, &mut ast);
            try_add_token(string, &mut ast);
            continue;
        }
        if is_char_number(c) {
            let num = collect_num(&mut peekable, c);
            id = try_add_token(id, &mut ast);
            try_add_token(num, &mut ast);
            continue;
        }
        if is_char_token(c) {
            let dbl_less = id != "<" && c == '<';
            let dbl_more = id != ">" && c == '>';
            let dbl_col = id != ":" && c == ':';
            let dbl_eq = id != "=" && c == '=';
            let dbl_slash = id != "/" && c == '/';
            if dbl_less || dbl_more || dbl_eq || dbl_col{
                match try_get_dbl(&mut peekable, c) {
                    Some(s) => {
                        id = try_add_token(id, &mut ast);
                        try_add_token(s, &mut ast);
                        continue;
                    }
                    None => {}
                }
            }
            if dbl_slash {
                if try_get_dbl(&mut peekable, c).is_some() {
                    id = try_add_token(id, &mut ast);
                    loop {
                        let next = peekable.next().unwrap_or('\n');
                        if next == '\n' { 
                            ast.push(AstToken::from_char(next));
                            break;
                        }
                    }
                    continue;
                }
            }
        }
        if is_char_token(c) {
            id = try_add_token(id, &mut ast);
            let next = peekable.peek().unwrap_or(&' ');
            let is_cool = c == '=' && next == &'>';
            let is_non_eq = c == '!' && next == &'=';
            let is_pointer = c == '-' && next == &'>';
            if is_cool || is_non_eq || is_pointer {
                peekable.next();
            }
            if is_cool {
                ast.push(AstToken::from_id(String::from("=>")));
            } else if is_non_eq {
                ast.push(AstToken::from_id(String::from("!=")));
            } else if is_pointer {
                ast.push(AstToken::from_id(String::from("->")));
            } else {
                ast.push(AstToken::from_char(c));
            }
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

fn try_get_dbl(peekable: &mut Peekable<Chars>, c: char) -> Option<String> {
    let peek = peekable.peek();
    if peek.is_some() && peek.unwrap_or(&' ') == &c {
        let mut dbl = String::from(c);
        dbl.push(c);
        peekable.next();
        return Some(dbl);
    }
    None
}

fn collect_string(peekable: &mut Peekable<Chars>, ch: char) -> String {
    let mut escaped = false;
    let mut matching = String::from(ch);
    loop {
        let c = match peekable.next() {
            None => return matching,
            Some(c) => c,
        };
        matching.push(c);
        if c == ch && !escaped {
            break;
        }
        escaped = !escaped && c == '\\'
    }
    matching
}

fn collect_num(peekable: &mut Peekable<Chars>, c: char) -> String {
    let mut num = String::from(c);
    loop {
        let part_of_num = match peekable.peek() {
            Some(p) => p == &'.' || is_char_number(p.to_owned()),
            None => return num,
        };
        if part_of_num {
            let next = match peekable.next() {
                None => return num,
                Some(n_c) => n_c,
            };
            num.push(next);
            continue;
        }
        break;
    }
    num
}
