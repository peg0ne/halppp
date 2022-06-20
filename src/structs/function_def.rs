use crate::{enums::VariableState, structs::Variable};

#[derive(Clone, Debug)]
pub struct Function {
    pub id: String,
    pub arguments: Vec<Variable>,
    pub return_value: Option<Variable>,
    pub variable_state: VariableState,
}

impl Function {
    pub fn new(state: VariableState) -> Function {
        Function {
            id: String::new(),
            arguments: vec![],
            return_value: None,
            variable_state: state,
        }
    }
    pub fn to_py(self: &Function, in_class: bool) -> String {
        let mut function = String::new();
        let spacing = if in_class { "    " } else { "" };
        function.push_str(format!("{}def {}(", spacing, self.id).as_str());
        let mut i = 0;
        loop {
            if i + 1 > self.arguments.len() {
                break;
            }
            function.push_str(
                format!("{}: {}", self.arguments[i].id, self.arguments[i].v_type).as_str(),
            );
            if i + 1 != self.arguments.len() {
                function.push_str(", ");
            }
            i += 1;
        }
        function.push_str("):\n");
        function
    }
    pub fn to_cpp(self: &Function, in_class: bool) -> String {
        let mut function = String::new();
        let spacing = if in_class { "    " } else { "" };
        match &self.return_value {
            None => function.push_str(format!("{}void {}(", spacing, self.id).as_str()),
            Some(v) => function.push_str(format!("{}{} {}(", spacing, v.v_type, self.id).as_str()),
        }
        let mut i = 0;
        loop {
            if i + 1 > self.arguments.len() {
                break;
            }
            function.push_str(
                format!("{} {}", self.arguments[i].v_type, self.arguments[i].id).as_str(),
            );
            if i + 1 != self.arguments.len() {
                function.push_str(", ");
            }
            i += 1;
        }
        function.push_str(") {\n");
        function.push_str(format!("{}}}\n", spacing).as_str());
        function
    }
}
