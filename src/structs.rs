#[derive(Debug, Copy, Clone)]
pub enum VariableState {
    Private,
    Protected,
    Public,
}

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

#[derive(Clone, Debug)]
pub struct Function {
    pub id: String,
    pub arguments: Vec<Variable>,
    pub return_value: Option<Variable>,
    pub variable_state: VariableState,
}

impl Function {
    pub fn to_py(self: &Function, in_class: bool) -> String {
        let mut function = String::new();
        let spacing = if in_class { "    " } else { "" };
        function.push_str(format!("{}def {}(", spacing, self.id).as_str());
        let mut i = 0;
        loop {
            if i + 1 > self.arguments.len() {
                break;
            }
            function.push_str(
                format!("{}: {}", self.arguments[i].id, self.arguments[i].v_type).as_str(),
            );
            if i + 1 != self.arguments.len() {
                function.push_str(", ");
            }
            i += 1;
        }
        function.push_str("):\n");
        function
    }
    pub fn to_cpp(self: &Function, in_class: bool) -> String {
        let mut function = String::new();
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
            function.push_str(
                format!("{} {}", self.arguments[i].v_type, self.arguments[i].id).as_str(),
            );
            if i + 1 != self.arguments.len() {
                function.push_str(", ");
            }
            i += 1;
        }
        function.push_str(") {\n");
        function.push_str(format!("{}}}\n", spacing).as_str());
        function
    }
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

#[derive(Debug)]
pub struct Program {
    pub global: Vec<Global>,
    pub structs: Vec<Struct>,
    pub functions: Vec<Function>,
    pub classes: Vec<Class>,
}
