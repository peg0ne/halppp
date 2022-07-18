use crate::structs::Variable;

#[derive(Clone, Debug)]
pub struct Global {
    pub variables: Vec<Variable>,
}

impl Global {
    pub fn new() -> Global {
        Global {
            variables: Vec::new(),
        }
    }
    pub fn to_cpp(self: &Global) -> String {
        let mut g_str = String::new();
        for i in self.variables.iter() {
            g_str.push_str(format!("\n#define {} {}\n", i.v_type, i.id).as_str());
        }
        g_str
    }
}
