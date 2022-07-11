#[derive(Clone, Debug)]
pub struct EnumValue {
    pub name: String,
    pub value: Option<String>
}

#[derive(Clone, Debug)]
pub struct Enum {
    pub name: String,
    pub enums: Vec<EnumValue>,
}

impl Enum {
    pub fn from(enum_name: String) -> Enum {
        Enum { 
            name: enum_name,
            enums: Vec::new(),
        }
    }
    pub fn to_cpp(self: &Enum) -> String {
        let mut enum_str = format!("enum {} {{\n", self.name);
        for i in self.enums.iter() {
            enum_str.push_str(format!("    {}", i.name).as_str());
            match &i.value {
                Some(v) => enum_str.push_str(format!("= {},\n", v).as_str()),
                None => enum_str.push_str(",\n"),
            }
        }
        enum_str.push_str("};\n");
        enum_str
    }
}

impl EnumValue {
    pub fn new() -> EnumValue {
        EnumValue {
            name: String::new(),
            value: None,
        }
    }
}
