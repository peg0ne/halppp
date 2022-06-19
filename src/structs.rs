#[derive(Clone, Debug)]
pub struct Variable {
    pub id: String,
    pub v_type: String,
    pub v_value: Option<String>,
    pub is_public: bool,
}

#[derive(Clone, Debug)]
pub struct Function {
    pub id: String,
    pub arguments: Vec<Variable>,
    pub return_value: Option<Variable>,
    pub is_public: bool,
}

#[derive(Clone, Debug)]
pub struct Struct {
    pub id: String,
    pub variables: Vec<Variable>,
}

#[derive(Clone, Debug)]
pub struct Global {
    pub variables: Vec<Variable>,
}

#[derive(Clone, Debug)]
pub struct Class {
    pub id: String,
    pub inherit: Option<String>,
    pub functions: Vec<Function>,
    pub variables: Vec<Variable>,
}

#[derive(Debug)]
pub struct Program {
    pub global: Vec<Global>,
    pub structs: Vec<Struct>,
    pub functions: Vec<Function>,
    pub classes: Vec<Class>,
}
