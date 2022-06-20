use crate::structs::Variable;

#[derive(Clone, Debug)]
pub struct Struct {
    pub id: String,
    pub variables: Vec<Variable>,
}
