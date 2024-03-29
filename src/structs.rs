mod ast_token_def;
mod class_def;
mod compiler_def;
mod condition_def;
mod expression_def;
mod for_def;
mod function_def;
mod global_def;
mod imports;
mod program_def;
mod struct_def;
mod variable_def;
mod path_def;
mod enum_def;
mod compiler_output;
mod select_def;
mod match_def;

pub use crate::structs::{
    ast_token_def::AstToken,
    class_def::Class,
    compiler_def::Compiler,
    condition_def::{Condition, ConditionalExpression},
    expression_def::Expression,
    for_def::For,
    function_def::Function,
    global_def::Global,
    imports::{Get, Include, Use},
    program_def::Program,
    struct_def::Struct,
    variable_def::Variable,
    path_def::CompilerPath,
    enum_def::{Enum, EnumValue},
    compiler_output::CompilerOutput,
    select_def::Select,
    match_def::Match,
};
