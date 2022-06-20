mod ast;
mod class;
mod enums;
mod fileutil;
mod function;
mod message;
mod structs;
mod utils;
mod variable;

use crate::{
    enums::{Token, VariableState},
    fileutil::{get_content, get_file_path, write_program},
    message::display_err_message,
    structs::{Compiler, Program},
    utils::get_next_or_exit,
};

fn main() {
    let file_path: String = get_file_path();
    let content: String = get_content(&file_path);
    let ast = ast::create(&content);
    // let mut output = String::new();

    let mut compiler = Compiler {
        program: Program {
            global: Vec::new(),
            structs: Vec::new(),
            functions: Vec::new(),
            classes: Vec::new(),
        },
        ast: ast.iter().peekable(),
    };

    loop {
        let next = get_next_or_exit(compiler.next(), "Compiler failed to do unexpected EOF");
        if !next.token.is_base() {
            display_err_message(
                format!(
                    "Token not allowed in base: {}, Type: {:?}",
                    next.name, next.token
                )
                .as_str(),
            );
        }
        match next.token {
            Token::Class => {
                let class = class::construct(&mut compiler);
                // output.push_str(class.to_py().as_str());
                compiler.add_class(class);
            }
            Token::Function => {
                let function = function::construct(&mut compiler, VariableState::Public);
                // output.push_str(function.to_py(false).as_str());
                compiler.add_fn(function);
            }
            Token::NewLine => {}
            Token::EOF => break,
            _ => display_err_message(format!("Token not handled: {:?}", next.token).as_str()),
        }
    }
    // write_program(output);
}
