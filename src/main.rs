mod ast;
mod class;
mod fileutil;
mod function;
mod message;
mod structs;
mod tokens;
mod utils;

use crate::{
    fileutil::{get_content, get_file_path},
    message::display_err_message,
    structs::Program,
    tokens::Token,
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

    while peekable_ast.peek().is_some() {
        match peekable_ast.next() {
            None => return,
            Some(next) => {
                if !next.1.is_base() {
                    display_err_message(
                        format!("Token not allowed in base: {}, Type: {:?}", next.0, next.1)
                            .as_str(),
                    );
                }
                match next.1 {
                    Token::Class => {
                        let (class, ast) = class::construct(peekable_ast);
                        peekable_ast = ast;
                        class::validate(&class, &program);
                        println!("Class created \n- {:?}\n", &class);
                        program.classes.push(class);
                    }
                    Token::Function => {
                        let (function, ast) = function::construct(peekable_ast);
                        peekable_ast = ast;
                        function::validate(&function, &program);
                        println!("Function created \n- {:?}\n", &function);
                        program.functions.push(function);
                    }
                    Token::NewLine => {}
                    Token::EOF => break,
                    _ => display_err_message(format!("Token not handled: {:?}", next.1).as_str()),
                }
            }
        }
    }
}
