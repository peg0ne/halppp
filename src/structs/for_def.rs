use crate::structs::Expression;

#[derive(Clone, Debug)]
pub struct For {
    pub iterator: String,
    pub named_variable: Option<String>,
    pub until: String,
    pub lines: Vec<Expression>,
    pub is_foreach: bool,
}

impl For {
    pub fn new(is_foreach: bool) -> For {
        For {
            iterator: String::new(),
            named_variable: None,
            until: String::new(),
            lines: Vec::new(),
            is_foreach: is_foreach,
        }
    }
}