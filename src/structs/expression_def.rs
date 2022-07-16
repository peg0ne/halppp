use crate::structs::{Condition, For};

#[derive(Clone, Debug)]
pub struct Expression {
    pub e_condition: Option<Condition>,
    pub e_for: Option<For>,
    pub line: Option<String>,
}

impl Expression {
    pub fn to_cpp(self: &Expression, indentation: i32) -> String {
        let mut expression = String::new();
        let spacing = "    ";
        match self.e_condition.as_ref() {
            Some(condition) => return condition.to_cpp(indentation),
            _ => {}
        }
        match self.e_for.as_ref() {
            Some(for_e) => {
                let formatted = format!(
                    "{}for(int {} = 0; {} < {}; {}++) {{\n",
                    spacing, for_e.iterator, for_e.iterator, for_e.until, for_e.iterator
                );
                expression.push_str(formatted.as_str());
                for line in for_e.lines.iter() {
                    expression.push_str(line.to_cpp(indentation + 1).as_str());
                }
                expression.push_str(format!("{}}}\n", spacing).as_str());
                return expression;
            }
            _ => {}
        }
        if self.line.is_some() {
            let line = self.line.as_ref().unwrap();
            if line.len() != 0 {
                expression.push_str(line);
                if !line.starts_with("case") {
                    expression.push_str(";");
                }
            }
            expression.push_str("\n")
        }
        expression
    }
}
