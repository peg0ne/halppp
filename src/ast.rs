use std::{iter::Peekable,str::Chars};
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
        if c == '"' || c == '\'' {
            let matched = get_matching(&mut peekable, c, c);
            id = try_add_token(id, &mut ast);
            try_add_token(matched, &mut ast);
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
        if is_char_token(c) {
            let dbl_less = id != "<" && c == '<';
            let dbl_more = id != ">" && c == '>';
            if dbl_less || dbl_more {
                match try_get_dbl(&mut peekable, c) {
                    Some(s) => {
                        id = try_add_token(id, &mut ast);
                        try_add_token(s, &mut ast);
                    }
                    None => {}
                }
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

fn try_get_dbl(peekable: &mut Peekable<Chars>, c: char) -> Option<String> {
    let peek = peekable.peek().unwrap_or(&' '); 
    if peek == &c {
        let mut dbl = String::from(c);
        dbl.push(c);
        Some(dbl);
    }
    None
}

fn get_matching(peekable: &mut Peekable<Chars>, c: char, m1: char) -> String {
    let mut matching = String::from(c);
    loop {
        let c = match peekable.next() {
            None => return matching,
            Some(c) => c,
        };
        matching.push(c);
        if c == m1 { break; }
    }
    matching
}