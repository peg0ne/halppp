use crate::structs::Expression;

#[derive(Clone, Debug)]
pub struct Select {
    pub optional_value: String,
    pub value_name: String,
    pub lines: Vec<Expression>,
}

impl Select {
    pub fn new() -> Select {
        Select {
            optional_value: String::new(),
            value_name: String::new(),
            lines: Vec::new(),
        }
    }
}