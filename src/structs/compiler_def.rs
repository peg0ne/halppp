use crate::structs::{AstToken, Class, Function, Include, Program, Use};
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
    pub fn add_inc(self: &mut Compiler<'a>, include: Vec<String>) {
        for i in include.iter() {
            self.program.includes.push(Include::from(i.to_owned()));
        }
    }
    pub fn add_use(self: &mut Compiler<'a>, usings: Vec<String>) {
        for i in usings.iter() {
            self.program.usings.push(Use::from(i.to_owned()));
        }
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
    pub fn contains_inc(self: &Compiler<'a>, id: &String) -> bool {
        for f in self.program.includes.iter() {
            if f.include == id.to_owned() {
                return true;
            }
        }
        false
    }
    pub fn contains_use(self: &Compiler<'a>, id: &String) -> bool {
        for f in self.program.usings.iter() {
            if f.using == id.to_owned() {
                return true;
            }
        }
        false
    }
}
