use crate::structs::variable::Variable;

#[derive(Clone, Debug)]
pub struct Global {
    pub variables: Vec<Variable>,
}
