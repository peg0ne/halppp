mod ast;
mod class;
mod enums;
mod fileutil;
mod function;
mod message;
mod structs;
mod utils;

use crate::{
    enums::{token::Token, variable_state::VariableState},
    fileutil::{get_content, get_file_path, write_program},
    message::display_err_message,
    structs::program::Program,
};

fn main() {
    let mut program: Program = Program {
        global: Vec::new(),
        structs: Vec::new(),
        functions: Vec::new(),
        classes: Vec::new(),
    };
    let file_path: String = get_file_path();
    let content: String = get_content(&file_path);
    let ast = ast::create(&content);
    let mut peekable_ast = ast.iter().peekable();
    let mut output = String::from("#include <string>\nusing namespace std;\n");

    while peekable_ast.peek().is_some() {
        match peekable_ast.next() {
            None => return,
            Some(next) => {
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
                        let (class, ast) = class::construct(peekable_ast);
                        peekable_ast = ast;
                        class::validate(&class, &program);
                        println!("{}", class.to_cpp().as_str());
                        output.push_str(class.to_cpp().as_str());
                        program.classes.push(class);
                    }
                    Token::Function => {
                        let (function, ast) =
                            function::construct(peekable_ast, VariableState::Public);
                        peekable_ast = ast;
                        function::validate(&function, &program);
                        println!("{}", function.to_cpp(false).as_str());
                        output.push_str(function.to_cpp(false).as_str());
                        program.functions.push(function);
                    }
                    Token::NewLine => {}
                    Token::EOF => break,
                    _ => {
                        display_err_message(format!("Token not handled: {:?}", next.token).as_str())
                    }
                }
            }
        }
    }
    write_program(output)
}
