use crate::structs::Expression;

#[derive(Clone, Debug)]
pub struct For {
    pub iterator: String,
    pub until: String,
    pub lines: Vec<Expression>,
}

impl For {
    pub fn new() -> For {
        For {
            iterator: String::new(),
            until: String::new(),
            lines: Vec::new(),
        }
    }
}
