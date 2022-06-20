mod ast_token_def;
mod class_def;
mod compiler_def;
mod function_def;
mod global_def;
mod imports;
mod program_def;
mod struct_def;
mod variable_def;

pub use crate::structs::{
    ast_token_def::AstToken,
    class_def::Class,
    compiler_def::Compiler,
    function_def::Function,
    global_def::Global,
    imports::{Get, Include, Use},
    program_def::Program,
    struct_def::Struct,
    variable_def::Variable,
};
