use crate::structs::Variable;

#[derive(Clone, Debug)]
pub struct Global {
    pub variables: Vec<Variable>,
}
