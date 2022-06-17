mod ast;
mod class;
mod fileutil;
mod message;
mod structs;
mod tokens;
mod utils;

use crate::{
    ast::create,
    class::construct,
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
    let file_path: Option<String> = get_file_path();
    if file_path.is_none() {
        return;
    }

    let content_opt: Option<String> = get_content(&file_path.unwrap());
    if content_opt.is_none() {
        return;
    }
    let content = content_opt.unwrap();
    let ast = create(&content);
    let mut peekable_ast = ast.iter().peekable();
    while peekable_ast.peek().is_some() {
        let x = peekable_ast.next().unwrap();
        if !x.1.is_base() {
            display_err_message(
                format!("Token not allowed in base: {}, Type: {:?}", x.0, x.1).as_str(),
            );
            return;
        }

        println!("TOKEN: {}, TYPE: {:?}", x.0, x.1);
        match x.1 {
            Token::Class => {
                let class_opt = construct(peekable_ast);
                if class_opt.is_none() {
                    return;
                }
                let class_out = class_opt.unwrap();
                let class = class_out.0;
                peekable_ast = class_out.1;
                println!("{:?}", class);
                let inheritance_opt = class.inherit.to_owned();
                if inheritance_opt.is_some() {
                    let a = inheritance_opt.unwrap();
                    if program.classes.len() == 0 {
                        display_err_message(
                            format!("Invalid Inheritance of: {}, Inherits: {:?}", class.id, a)
                                .as_str(),
                        );
                        return;
                    }
                    for c in program.classes.iter() {
                        if c.id == a {
                            continue;
                        } else {
                            display_err_message(
                                format!("Invalid Inheritance of: {}, Inherits: {:?}", class.id, a)
                                    .as_str(),
                            );
                            return;
                        }
                    }
                }
                program.classes.push(class);
            }
            _ => {
                display_err_message(format!("Token not handled: {:?}", x.1).as_str());
                return;
            }
        }
    }
}
