use crate::enums::VariableState;

#[derive(Clone, Debug)]
pub struct Variable {
    pub id: String,
    pub v_type: String,
    pub v_value: Option<String>,
    pub variable_state: VariableState,
}

impl Variable {
    pub fn has_minimum(self: &Variable) -> bool {
        self.has_id() && self.has_type()
    }
    pub fn has_id(self: &Variable) -> bool {
        self.id.len() != 0
    }
    pub fn has_type(self: &Variable) -> bool {
        self.v_type.len() != 0
    }
    pub fn to_owned(self: &Variable) -> Variable {
        let mut v = Variable {
            id: self.id.to_owned(),
            v_type: self.v_type.to_owned(),
            v_value: None,
            variable_state: self.variable_state,
        };
        match &self.v_value {
            Some(var) => {
                v.v_value = Some(var.to_owned());
            }
            None => {}
        }
        return v;
    }
    pub fn new() -> Variable {
        Variable {
            id: String::new(),
            v_type: String::new(),
            v_value: None,
            variable_state: VariableState::Private,
        }
    }
    pub fn from(
        id: String,
        v_type: String,
        v_value: Option<String>,
        variable_state: VariableState,
    ) -> Variable {
        Variable {
            id: id,
            v_type: v_type,
            v_value: v_value,
            variable_state: variable_state,
        }
    }
    pub fn return_void() -> Variable {
        Variable {
            id: String::from("return_value"),
            v_type: String::from("void"),
            v_value: None,
            variable_state: VariableState::Private,
        }
    }
}
