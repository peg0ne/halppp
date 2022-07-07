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

use std::{process::Command, fs, str};
use crate::{
    enums::{Token, VariableState},
    fileutil::{get_content, get_file_path, write_program},
    message::{display_err_message, display_hint_message},
    structs::{Compiler, Include, Program, Use},
    utils::get_next_or_exit,
};

fn main() {
    let file_path: String = get_file_path();
    let mut file_name: String = String::new();
    let mut folder_path: String = file_path.to_owned();
    loop {
        let i: i32 = folder_path.len() as i32;
        if i == 0 { break; }
        match folder_path.pop() {
            Some(p) => {
                if p == '/' {
                    folder_path.push('/');
                    break;
                }
                file_name.push(p);
            }
            _ => {}
        }
    }
    let mut reversed = String::new();
    while file_name.len() > 0 {
        reversed.push(file_name.pop().unwrap());
    }
    file_name = reversed;
    let p = Program {
        global: Vec::new(),
        structs: Vec::new(),
        functions: Vec::new(),
        classes: Vec::new(),
        includes: Vec::new(),
        usings: Vec::new(),
    };
    let (output, arguments) = compile(file_name.to_owned(), folder_path.to_owned(), p, true);
    write_program(output, file_name.to_owned(), folder_path.to_owned());
    let mut base_cmd = format!("{} -o {}", file_path.replace(".ha",".cpp"), file_path.replace(".ha", ""));
    if arguments.len() > 0 {
        base_cmd = format!("{} {}", base_cmd, arguments.join(" "));
    }
    let cmd: Vec<&str> = base_cmd.split(" ").collect();
    let cmd_output = Command::new("g++")
                            .args(cmd)
                            .output()
                            .expect("Failed to compile!");
    let s = match str::from_utf8(&cmd_output.stderr) {
        Ok(v) => v,
        Err(e) => panic!("Invalid UTF-8 sequence: {}", e),
    };
    println!("compilation completed\n\x1b[93m{}\x1b[0m", s);
    fs::remove_file(file_path.replace(".ha", ".cpp"));
}

fn compile(file_path: String, folder_path: String, p: Program, is_main: bool) -> (String,Vec<String>) {
    println!("compiling: {}{}", folder_path,file_path);
    let content: String = get_content(&file_path, &folder_path);
    let ast = ast::create(&content);
    let mut output = String::new();

    let mut compiler = Compiler {
        program: Program {
            global: p.global,
            structs: p.structs,
            functions: p.functions,
            classes: p.classes,
            includes: p.includes,
            usings: p.usings,
        },
        ast: ast.iter().peekable(),
        arguments: Vec::new()
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
                let gets = imports::imports_creation(&mut compiler, next);
                for i in gets.iter() {
                    let mut getting = i.to_owned();
                    getting.push_str(".ha");
                    let mut file_name: String = String::new();
                    let mut folder_path: String = folder_path.to_owned();
                    folder_path.push_str(getting.as_str());
                    loop {
                        let i: i32 = folder_path.len() as i32;
                        if i == 0 { break; }
                        match folder_path.pop() {
                            Some(p) => {
                                if p == '/' {
                                    folder_path.push('/');
                                    break;
                                }
                                file_name.push(p);
                            }
                            _ => {}
                        }
                    }
                    let mut reversed = String::new();
                    while file_name.len() > 0 {
                        reversed.push(file_name.pop().unwrap());
                    }
                    file_name = reversed;
                    let (file_out, arguments) = compile(file_name, folder_path.to_owned(), compiler.program.to_owned(), false);
                    output.push_str(file_out.as_str());
                    for arg in arguments.iter() {
                        compiler.arguments.push(arg.to_owned());
                    }
                }
            }
            Token::Compiler => {
                match compiler.next() {
                    None => display_err_message(format!("[Compiler] Missing start of compiler intent [=>]: {:?}", next.token).as_str()),
                    Some(p) => {
                        match p.token {
                            Token::CoolArrow => {}
                            _ => display_err_message(format!("[Compiler] Missing start of compiler intent [=>]: {:?}", next.token).as_str()),
                        }
                    }
                }
                match compiler.next() {
                    None => {
                        display_err_message(format!("[Compiler] Missing start of compiler intent [=>]: {:?}", next.token).as_str());
                    }
                    Some(p) => {
                        match p.token {
                            Token::Id => compiler.arguments.push(p.name.to_owned().replace("\"","")),
                            _ => display_err_message(format!("[Compiler] Missing value of compiler intent [Token::Id]: {:?}", next.token).as_str()),
                        }
                    }
                }
            }
            Token::NewLine => {}
            Token::EOF => break,
            _ => {
                display_err_message(format!("Token not handled: {:?}", next.token).as_str());
            }
        }
    }
    validate_compiled(&mut compiler, is_main);   
    return (output, compiler.arguments);
}

fn validate_compiled(compiler: &mut Compiler, is_main: bool) {
    let mut has_main = false;
    for f in compiler.program.functions.iter_mut() {
        if f.id == "main" { has_main = true; }
    }
    if !has_main && is_main { display_hint_message("Main function is not present!"); }
    if has_main && !is_main { display_hint_message("Main function not in main file"); }
}
