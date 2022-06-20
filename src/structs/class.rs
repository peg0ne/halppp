use crate::{
    enums::variable_state::VariableState,
    structs::{function::Function, variable::Variable},
};

#[derive(Clone, Debug)]
pub struct Class {
    pub id: String,
    pub inherit: Option<String>,
    pub functions: Vec<Function>,
    pub variables: Vec<Variable>,
}

impl Class {
    pub fn to_py(self: &Class) -> String {
        let mut class = String::from(format!("class {}", self.id));
        match &self.inherit {
            None => class.push_str(":\n"),
            Some(a) => class.push_str(format!("({}):\n", a).as_str()),
        }
        for v in self.variables.iter() {
            class.push_str(format!("    {}: {}\n", v.id, v.v_type).as_str())
        }
        for f in self.functions.iter() {
            class.push_str(f.to_py(true).as_str());
        }
        class
    }
    pub fn to_cpp(self: &Class) -> String {
        let mut class = String::from(format!("class {}", self.id));
        match &self.inherit {
            None => {}
            Some(a) => class.push_str(format!(": public {}", a).as_str()),
        }
        class.push_str(" {\n");
        for v in self.variables.iter() {
            match v.variable_state {
                VariableState::Private => class.push_str("  private:\n"),
                VariableState::Protected => class.push_str("  protected:\n"),
                VariableState::Public => class.push_str("  public:\n"),
            }
            class.push_str(format!("    {} {};\n", v.v_type, v.id).as_str());
        }
        for f in self.functions.iter() {
            match f.variable_state {
                VariableState::Private => class.push_str("  private:\n"),
                VariableState::Protected => class.push_str("  protected:\n"),
                VariableState::Public => class.push_str("  public:\n"),
            }
            class.push_str(f.to_cpp(true).as_str());
        }
        class.push_str("};\n");
        class
    }
}
