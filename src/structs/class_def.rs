use crate::{
    enums::VariableState,
    structs::{Function, Variable},
};

#[derive(Clone, Debug)]
pub struct Class {
    pub is_struct: bool,
    pub id: String,
    pub inherit: Option<String>,
    pub functions: Vec<Function>,
    pub variables: Vec<Variable>,
    pub template: Vec<String>,
}

impl Class {
    pub fn new() -> Class {
        Class {
            is_struct: false,
            id: String::new(),
            inherit: None,
            functions: Vec::new(),
            variables: Vec::new(),
            template: Vec::new(),
        }
    }
    pub fn to_cpp(self: &Class) -> String {
        let mut class = String::new();
        if self.template.len() > 0 {
            class.push_str("template <typename ");
            let mut i = 0;
            while i < self.template.len() {
                class.push_str(self.template[i].as_str());
                if i + 1 < self.template.len() {
                    class.push_str(", typename ");
                }
                i += 1;
            }
            class.push_str(">\n")
        }
        if self.is_struct {
            class.push_str(format!("struct {}", self.id).as_str())
        } else {
            class.push_str(format!("class {}", self.id).as_str())
        }
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
            class.push_str(v.to_cpp("    ", ";\n").as_str());
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
