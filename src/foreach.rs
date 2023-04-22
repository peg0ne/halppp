use crate::{
    condition, expression, switch, selects,
    enums::Token,
    structs::{Compiler, Expression, For},
    utils::{get_id_or_exit, get_next_or_exit, get_or_exit},
};

pub fn construct(compiler: &mut Compiler, is_foreach: bool) -> Expression {
    let mut for_def = For::new(is_foreach);
    let mid_check = if is_foreach {Token::In} else {Token::Until};
    for_def.iterator = get_id_or_exit(compiler.next(), "[For] For loop is not closed");
    if is_foreach {
        if compiler.peek().unwrap().token.to_owned() == Token::Comma {
            compiler.next();
            for_def.named_variable = Some(get_id_or_exit(compiler.next(), "[For] Requires identifier"));
        }
    }
    get_or_exit(compiler.next(), mid_check, format!("[For] Missing {:?} keyword", mid_check).as_str());
    for_def.until = compiler.next().unwrap().name.to_owned();
    loop {
        let x = get_next_or_exit(compiler.next(), "[For] For loop is not closed");
        if x.token.is_do() {
            for_def.lines.push(expression::construct(compiler, x));
            return Expression {
                e_condition: None,
                e_for: Some(for_def),
                e_select: None,
                line: None,
            }
        }
        match x.token {
            Token::NewLine => break,
            _ => for_def.until.push_str(x.name.as_str()),
        }
    }
    loop {
        let x = get_next_or_exit(compiler.next(), "[For] For loop is not closed");
        match x.token {
            Token::Condition => for_def.lines.push(condition::construct(compiler, x.name)),
            Token::Foreach => for_def.lines.push(construct(compiler, true)),
            Token::For => for_def.lines.push(construct(compiler, false)),
            Token::Switch => for_def.lines.push(switch::construct(compiler)),
            Token::Select => for_def.lines.push(selects::construct(compiler)),
            Token::SemiColon => break,
            Token::EOF => break,
            Token::NewLine => continue,
            _ => for_def.lines.push(expression::construct(compiler, x)),
        }
    }
    Expression {
        e_condition: None,
        e_for: Some(for_def),
        e_select: None,
        line: None,
    }
}