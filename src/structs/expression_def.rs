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
    pub fn to_cpp(self: &Expression, indentation: i32) -> String {
        let mut expression = String::new();
        let spacing = "    ";
        if self.e_condition.is_some() {
            let condition = self.e_condition.as_ref().unwrap();
            let formatted = format!(
                "{}{}({}{}{}) {{\n",
                spacing,
                condition.conditioner,
                condition.value1,
                condition.operator,
                condition.value2
            );
            expression.push_str(formatted.as_str());
            for line in condition.lines.iter() {
                expression.push_str(line.to_cpp(indentation + 1).as_str());
            }
            expression.push_str(format!("{}}}\n", spacing).as_str());
        } else if self.e_for.is_some() {
            let for_def = self.e_for.as_ref().unwrap();
            let formatted = format!(
                "{}for(int {} = 0; {} < {}; i++) {{\n",
                spacing, for_def.iterator, for_def.iterator, for_def.until
            );
            expression.push_str(formatted.as_str());
            for line in for_def.lines.iter() {
                expression.push_str(line.to_cpp(indentation + 1).as_str());
            }
            expression.push_str(format!("{}}}\n", spacing).as_str());
        } else if self.line.is_some() {
            let line = self.line.as_ref().unwrap();
            if line.len() != 0 {
                expression.push_str(line);
                expression.push_str(";\n");
            }
        }
        expression
    }
}
