use crate::structs::{AstToken, Class, Function, Program};
use std::{iter::Peekable, slice::Iter};

pub struct Compiler<'a> {
    pub program: Program,
    pub ast: Peekable<Iter<'a, AstToken>>,
}

impl<'a> Compiler<'a> {
    pub fn next(self: &mut Compiler<'a>) -> Option<&'a AstToken> {
        self.ast.next()
    }
    pub fn peek(self: &mut Compiler<'a>) -> Option<&&AstToken> {
        self.ast.peek()
    }
    pub fn add_class(self: &mut Compiler<'a>, class: Class) {
        self.program.classes.push(class);
    }
    pub fn add_fn(self: &mut Compiler<'a>, function: Function) {
        self.program.functions.push(function);
    }
    pub fn contains_class(self: &Compiler<'a>, id: &String) -> bool {
        for c in self.program.classes.iter() {
            if c.id == id.to_string() {
                return true;
            }
        }
        false
    }
    pub fn contains_function(self: &Compiler<'a>, id: &String) -> bool {
        for f in self.program.functions.iter() {
            if f.id == id.to_string() {
                return true;
            }
        }
        false
    }
}
