use crate::{
    condition,
    enums::Token,
    expression,
    switch,
    foreach,
    structs::{Compiler, Expression, Select},
    utils::{get_id_or_exit, get_next_or_exit, get_or_exit}, matches,
};

pub fn construct(compiler: &mut Compiler) -> Expression {
    let mut select = Select::new();
    select.value_name = get_id_or_exit(compiler.next(), "[Select] is not closed");
    get_or_exit(compiler.next(), Token::From, "[Select] Missing from keyword");
    select.optional_value = compiler.next().unwrap().name.to_owned();
    loop {
        let x = get_next_or_exit(compiler.next(), "[Select] is not closed");
        if x.token.is_do() {
            select.lines.push(expression::construct(compiler, x));
            return Expression {
                e_condition: None,
                e_for: None,
                e_select: Some(select),
                e_match: None,
                line: None,
            }
        }
        match x.token {
            Token::NewLine => break,
            _ => select.optional_value.push_str(x.name.as_str()),
        }
    }
    loop {
        let x = get_next_or_exit(compiler.next(), "[Select] is not closed");
        match x.token {
            Token::Condition => select.lines.push(condition::construct(compiler, x.name)),
            Token::Foreach => select.lines.push(foreach::construct(compiler, true)),
            Token::For => select.lines.push(foreach::construct(compiler, false)),
            Token::Switch => select.lines.push(switch::construct(compiler)),
            Token::Select => select.lines.push(construct(compiler)),
            Token::Match => select.lines.push(matches::construct(compiler, None, false)),
            Token::SemiColon => break,
            Token::EOF => break,
            Token::NewLine => continue,
            _ => select.lines.push(expression::construct(compiler, x)),
        }
    }
    Expression {
        e_condition: None,
        e_for: None,
        e_select: Some(select),
        e_match: None,
        line: None,
    }
}
