use crate::structs::{Class, Function, Global, Include, Struct, Use};

#[derive(Debug)]
pub struct Program {
    pub global: Vec<Global>,
    pub structs: Vec<Struct>,
    pub functions: Vec<Function>,
    pub classes: Vec<Class>,
    pub includes: Vec<Include>,
    pub usings: Vec<Use>,
}
