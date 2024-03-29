use crate::{
    enums::VariableState,
    structs::{Expression, Variable},
};

#[derive(Clone, Debug)]
pub struct Function {
    pub id: String,
    pub arguments: Vec<Variable>,
    pub return_value: Option<Variable>,
    pub variable_state: VariableState,
    pub expressions: Vec<Expression>,
    pub template: Vec<String>,
}

impl Function {
    pub fn new(state: VariableState) -> Function {
        Function {
            id: String::new(),
            arguments: vec![],
            return_value: None,
            variable_state: state,
            expressions: vec![],
            template: vec![],
        }
    }
    pub fn to_cpp_start(self: &Function, in_class: bool) -> String {
        let mut function = String::new();
        if self.template.len() > 0 {
            function.push_str("template <");
            if self.template[0].as_str().starts_with("C") {
                function.push_str("class ");
            } else {
                function.push_str("typename ");
            }
            let mut i = 0;
            while i < self.template.len() {
                function.push_str(self.template[i].as_str());
                if i + 1 < self.template.len() {
                    if self.template[i].as_str().starts_with("C") {
                        function.push_str(", class ");
                    } else {
                        function.push_str(", typename ");
                    }
                }
                i += 1;
            }
            function.push_str(">\n");
        }
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
            function.push_str(self.arguments[i].to_cpp("", "").as_str());
            if i + 1 != self.arguments.len() {
                function.push_str(", ");
            }
            i += 1;
        }
        function
    }
    pub fn to_cpp_h(self: &Function, in_class: bool) -> String {
        let mut function = self.to_cpp_start(in_class);
        function.push_str(");\n");
        function
    }
    pub fn to_cpp(self: &Function, in_class: bool) -> String {
        let mut function = self.to_cpp_start(in_class);
        function.push_str(") {\n");
        for expr in self.expressions.iter() {
            function.push_str(expr.to_cpp(1).as_str());
        }
        let spacing = if in_class { "    " } else { "" };
        function.push_str(format!("{}}}\n", spacing).as_str());
        function
    }
}
