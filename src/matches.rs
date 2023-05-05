use crate::{
    expression,
    enums::Token,
    structs::{Compiler, Expression, Match},
    utils::{get_next_or_exit, try_get},
    message::display_err_message,
};

pub fn construct(compiler: &mut Compiler, id: Option<String>, is_let: bool) -> Expression {
    let mut match_def = Match::new(id, is_let);
    loop {
        let x = get_next_or_exit(compiler.next(), "[Match] Match is not closed");        
        match x.token {
            Token::NewLine => break,
            Token::EOF => display_err_message("[Match] Expected token got EOF"),
            _ => {
                if x.token.is_do() || x.token.is_base() {
                    display_err_message("[Match] Token not allowed in start of match expr");
                }
                match_def.matcher_expr.push_str(x.name.as_str())
            }
        }
    }
    loop {
        match_def.statements.push(match_statements(compiler));
        match_def.lines.push(match_lines(compiler));
        if try_get(compiler.peek(), Token::NewLine) {
            compiler.next();
        }
        if try_get(compiler.peek(), Token::SemiColon) {
            compiler.next();
            break;
        }
    }
    return Expression {
        e_condition: None,
        e_for: None,
        e_select: None,
        e_match: Some(match_def),
        e_variable: None,
        line: None
    };
}

fn match_statements(compiler: &mut Compiler) -> String {
    let mut statement = String::new();
    loop {
        let x = get_next_or_exit(compiler.next(), "[Match] Expected token got EOF");
        match x.token {
            Token::CoolArrow => break,
            Token::EOF => break,
            _ => statement.push_str(x.name.as_str())
        }
    }
    statement
}

fn match_lines(compiler: &mut Compiler) -> Vec<String> {
    let mut lines: Vec<String> = Vec::new();
    let mut x = get_next_or_exit(compiler.next(), "[Match] expected some expression");
    if x.token.is_do() {
        lines.push(expression::construct(compiler, x).to_cpp(2));
        return lines;
    }
    loop {
        match x.token {
            Token::SemiColon => break,
            Token::EOF => break,
            Token::NewLine => {
                x = get_next_or_exit(compiler.next(), "[Match] expected some expression");
                continue;
            }
            _ => lines.push(expression::construct(compiler, x).to_cpp(2))
        }
        x = get_next_or_exit(compiler.next(), "[Match] expected some expression");
    }
    lines
}