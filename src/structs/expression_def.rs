use crate::structs::{Condition, For};

#[derive(Clone, Debug)]
pub struct Expression {
    pub e_condition: Option<Condition>,
    pub e_for: Option<For>,
    pub line: Option<String>,
}

impl Expression {
    pub fn new() -> Expression {
        Expression {
            e_condition: None,
            e_for: None,
            line: None,
        }
    }
}
