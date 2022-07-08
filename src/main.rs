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
    fileutil::{get_content, get_file_path, write_program, compile_program},
    message::{display_err_message, display_hint_message},
    structs::{Compiler, Include, Program, Use, CompilerPath},
    utils::{get_next_or_exit, get_id_or_exit, get_arrow_or_exit},
};

fn main() {
    let should_remove_cpp: bool = false;
    let paths = CompilerPath::from(get_file_path());
    let mut p = Program::new();
    let (output, arguments) = compile_main(&paths, &mut p);
    write_program(output, &paths);
    compile_program(&paths, arguments, should_remove_cpp);
}

fn compile_main(paths: &CompilerPath, p: &mut Program) -> (String, Vec<String>) {compile(paths, p, true)}
fn compile(paths: &CompilerPath, p: &mut Program, is_main: bool) -> (String, Vec<String>) {
    println!("compiling: {}", paths.current);
    let content: String = get_content(&paths);
    let ast = ast::create(&content);
    let mut output = String::new();
    let mut compiler = Compiler {
        program: p,
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
                    let get_path = CompilerPath::from(format!("{}{}.ha", paths.folder_path, i));
                    let (file_out, arguments) = compile(&get_path, compiler.program, false);
                    output.push_str(file_out.as_str());
                    compiler.add_args(arguments);
                }
            }
            Token::Compiler => {
                get_arrow_or_exit(compiler.next(), format!("[Compiler] Missing start of compiler intent [=>]: {:?}", next.token).as_str());
                let arg = get_id_or_exit(compiler.next(), format!("[Compiler] Missing value of compiler intent [Token::Id]: {:?}", next.token).as_str());
                compiler.add_arg(&arg);
            }
            Token::NewLine => {}
            Token::EOF => break,
            _ => display_err_message(format!("Token not handled: {:?}", next.token).as_str()),
        }
    }
    validate_compiled(&mut compiler, is_main);   
    (output, compiler.arguments)
}

fn validate_compiled(compiler: &mut Compiler, is_main: bool) {
    let mut has_main = false;
    for f in compiler.program.functions.iter_mut() {
        if f.id == "main" { has_main = true; }
    }
    if !has_main && is_main { display_hint_message("Main function is not present!"); }
    if has_main && !is_main { display_hint_message("Main function not in main file"); }
}
