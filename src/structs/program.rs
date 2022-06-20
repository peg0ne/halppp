use crate::structs::{class::Class, function::Function, global::Global, struct_def::Struct};

#[derive(Debug)]
pub struct Program {
    pub global: Vec<Global>,
    pub structs: Vec<Struct>,
    pub functions: Vec<Function>,
    pub classes: Vec<Class>,
}
