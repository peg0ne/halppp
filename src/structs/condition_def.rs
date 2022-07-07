use crate::structs::Expression;

#[derive(Clone, Debug)]
pub struct Condition {
    pub conditioner: String,
    pub value1: String,
    pub value2: String,
    pub operator: String,
    pub lines: Vec<Expression>,
}

impl Condition {
    pub fn new(conditioner: String) -> Condition {
        Condition {
            conditioner: conditioner,
            value1: String::new(),
            value2: String::new(),
            operator: String::new(),
            lines: Vec::new(),
        }
    }
}
