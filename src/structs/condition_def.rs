use crate::structs::Expression;

#[derive(Clone, Debug)]
pub struct Condition {
    pub expressions: Vec<ConditionalExpression>,
    pub conditioner: String,
    pub lines: Vec<Expression>,
}

#[derive(Clone, Debug)]
pub struct ConditionalExpression {
    pub value1: String,
    pub value2: String,
    pub operator: String,
    pub continuation: String,
}

impl Condition {
    pub fn new(conditioner: String) -> Condition {
        Condition {
            expressions: Vec::new(),
            conditioner: conditioner,
            lines: Vec::new(),
        }
    }
    pub fn to_cpp(self: &Condition, indentation: i32) -> String {
        let mut condition = if self.conditioner == "else" { 
            String::from("    else {\n")
        } else {
            format!("    {}(", self.conditioner)
        };
        for i in self.expressions.iter() {
            condition.push_str(format!("{} {} {} {}",
            i.value1,
            i.operator,
            i.value2,
            i.continuation).as_str());
        }
        if self.conditioner != "else" {
            condition.push_str(") {\n");
        }
        for line in self.lines.iter() {
            condition.push_str(line.to_cpp(indentation + 1).as_str());
        }
        condition.push_str("    }\n");
        condition
    }
}

impl ConditionalExpression {
    pub fn new() -> ConditionalExpression {
        ConditionalExpression {
            value1: String::new(),
            value2: String::new(),
            operator: String::new(),
            continuation: String::new(),
        }
    }
}
