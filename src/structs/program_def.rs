use crate::structs::{Class, Function, Global, Struct};

#[derive(Debug)]
pub struct Program {
    pub global: Vec<Global>,
    pub structs: Vec<Struct>,
    pub functions: Vec<Function>,
    pub classes: Vec<Class>,
}
