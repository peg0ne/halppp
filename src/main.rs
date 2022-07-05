mod ast;
mod class;
mod condition;
mod enums;
mod expression;
mod fileutil;
mod foreach;
mod function;
mod imports;
mod message;
mod structs;
mod utils;
mod variable;
mod template;

use crate::{
    enums::{Token, VariableState},
    fileutil::{get_content, get_file_path, write_program},
    message::display_err_message,
    structs::{Compiler, Include, Program, Use},
    utils::get_next_or_exit,
};

fn main() {
    let file_path: String = get_file_path();
    let content: String = get_content(&file_path);
    let ast = ast::create(&content);
    let mut output = String::new();

    let mut compiler = Compiler {
        program: Program {
            global: Vec::new(),
            structs: Vec::new(),
            functions: Vec::new(),
            classes: Vec::new(),
            includes: Vec::new(),
            usings: Vec::new(),
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
            Token::Struct => {
                let mut class = class::construct(&mut compiler);
                class.is_struct = true;
                output.push_str(class.to_cpp().as_str());
                compiler.add_class(class);
            }
            Token::Class => {
                let class = class::construct(&mut compiler);
                output.push_str(class.to_cpp().as_str());
                compiler.add_class(class);
            }
            Token::Function => {
                let function = function::construct(&mut compiler, VariableState::Public, false);
                output.push_str(function.to_cpp(false).as_str());
                compiler.add_fn(function);
            }
            Token::Include => {
                let incs = imports::imports_creation(&mut compiler, next);
                for i in incs.iter() {
                    output.push_str(Include::from(i.to_owned()).to_cpp().as_str());
                }
            }
            Token::Use => {
                let uses = imports::imports_creation(&mut compiler, next);
                for i in uses.iter() {
                    output.push_str(Use::from(i.to_owned()).to_cpp().as_str());
                }
            }
            Token::Get => {
                imports::imports_creation(&mut compiler, next);
            }
            Token::NewLine => {}
            Token::EOF => break,
            _ => {
                display_err_message(format!("Token not handled: {:?}", next.token).as_str());
            }
        }
    }
    write_program(output)
}
