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
mod enumerator;
mod switch;
mod globals;
mod selects;

use crate::{
    enums::{Token, VariableState},
    fileutil::{get_content, get_file_path, write_program, compile_program},
    message::{display_err_message, display_hint_message},
    structs::{Compiler, Include, Program, Use, CompilerPath, CompilerOutput},
    utils::{get_next_or_exit, get_id_or_exit, get_arrow_or_exit},
};

fn main() {
    let should_remove_cpp: bool = false;
    let paths = CompilerPath::from(get_file_path());
    let mut p = Program::new();
    let output = compile_main(&paths, &mut p);
    write_program(output.content(), &paths);
    compile_program(&paths, output.arguments, should_remove_cpp);
}

fn compile_main(paths: &CompilerPath, p: &mut Program) -> CompilerOutput {compile(paths, p, true)}
fn compile(paths: &CompilerPath, p: &mut Program, is_main: bool) -> CompilerOutput {
    println!("compiling: {}", paths.current);
    let content: String = get_content(&paths);
    let ast = ast::create(&content);
    let mut output = String::new();
    let mut includes = String::new();
    let mut headers = String::new();
    let mut fnheaders = String::new();
    let mut is_named = false;
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
            Token::Named => {
                if is_named {display_err_message("[Named] cannot have nested namespaces");}
                is_named = true;
                get_arrow_or_exit(compiler.next(), "[Named] missing => in declaration");
                let id = get_id_or_exit(compiler.next(), "[Named] cannot create namespace without Id");
                output.push_str(format!("namespace {}\n{{\n", id).as_str());
            }
            Token::Struct => {
                let class = class::construct(&mut compiler, true);
                output.push_str(class.to_cpp().as_str());
                headers.push_str(class.to_cpp_h().as_str());
            }
            Token::Class => {
                let class = class::construct(&mut compiler, false);
                output.push_str(class.to_cpp().as_str());
                headers.push_str(class.to_cpp_h().as_str());
            }
            Token::Function => {
                let function = function::construct(&mut compiler, VariableState::Public, false);
                output.push_str(function.to_cpp(false).as_str());
                fnheaders.push_str(function.to_cpp_h(false).as_str());
            }
            Token::Enum => {
                let enum_def = enumerator::construct(&mut compiler);
                output.push_str(enum_def.to_cpp().as_str());
                headers.push_str(enum_def.to_cpp_h().as_str());
            }
            Token::Global => {
                let globals = globals::construct(&mut compiler);
                headers.push_str(globals.to_cpp().as_str());
            }
            Token::Include => {
                let incs = imports::imports_creation(&mut compiler, next);
                for i in incs.iter() {
                    includes.push_str(Include::from(i.to_owned()).to_cpp().as_str());
                }
            }
            Token::Use => {
                let uses = imports::imports_creation(&mut compiler, next);
                for i in uses.iter() {
                    includes.push_str(Use::from(i.to_owned()).to_cpp().as_str());
                }
            }
            Token::Get => {
                let gets = imports::imports_creation(&mut compiler, next);
                for i in gets.iter() {
                    let get_path = CompilerPath::from(format!("{}{}.ha", paths.folder_path, i));
                    let get_out = compile(&get_path, compiler.program, false);
                    output.push_str(get_out.output.as_str());
                    includes.push_str(get_out.includes.as_str());
                    headers.push_str(get_out.headers.as_str());
                    fnheaders.push_str(get_out.fnheaders.as_str());
                    compiler.add_args(get_out.arguments);
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
    if is_named {output.push_str("\n}\n");}
    validate_compiled(&mut compiler, is_main);
    CompilerOutput::from(output, includes, headers, fnheaders, compiler.arguments)
}

fn validate_compiled(compiler: &mut Compiler, is_main: bool) {
    let mut has_main = false;
    for f in compiler.program.functions.iter_mut() {
        if f.id == "main" { has_main = true; }
    }
    if !has_main && is_main { display_hint_message("Main function is not present!"); }
    if has_main && !is_main { display_hint_message("Main function not in main file"); }
}
