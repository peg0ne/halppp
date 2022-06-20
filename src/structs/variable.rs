use crate::enums::variable_state::VariableState;

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
}
