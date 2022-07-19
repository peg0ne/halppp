use crate::{
    enums::Token,
    message::display_err_message,
    structs::{Compiler, Global, Variable},
    utils::get_next_or_exit,
};

pub fn construct(compiler: &mut Compiler) -> Global {
    let mut global = Global::new();
    let mut variable = Variable::new();
    loop {
        let x = get_next_or_exit(compiler.next(), "[Global]: Unexpected end of global");
        match x.token {
            Token::SemiColon => {
                try_add_variable(compiler, &mut global, &variable);
                break;
            },
            Token::EOF => {
                try_add_variable(compiler, &mut global, &variable);
                break;
            },
            Token::NewLine => {
                try_add_variable(compiler, &mut global, &variable);
                variable = Variable::new();
                continue;
            }
            _ => {}
        }
        if !variable.has_type() {
            variable.v_type = x.name;
        } else if !variable.has_id() {
            variable.id = x.name;
        } else {
            display_err_message("[Global]: Variable is already finished")
        }
    }
    compiler.add_glob(&global);
    global
}

fn try_add_variable(compiler: &mut Compiler, global: &mut Global, variable: &Variable) {
    if !variable.has_minimum() {
        return;
    } 
    for g in global.variables.iter() {
        if g.v_type == variable.v_type {
            display_err_message("[Global]: Multiple declarations of same value");
        }
    }
    if compiler.contains_glob(&variable.v_type) {
        display_err_message("[Global]: Multiple declarations of same value");
    }
    global.variables.push(variable.to_owned());
}