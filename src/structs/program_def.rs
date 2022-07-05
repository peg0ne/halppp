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

impl Program {
    pub fn to_owned(self: &Program) -> Program {
        Program {
            global: self.global.to_owned(),
            structs: self.structs.to_owned(),
            functions: self.functions.to_owned(),
            classes: self.classes.to_owned(),
            includes: self.includes.to_owned(),
            usings: self.usings.to_owned(),
        }
    }
}
