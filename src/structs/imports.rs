#[derive(Clone, Debug)]
pub struct Include {
    pub include: String,
}
#[derive(Clone, Debug)]
pub struct Use {
    pub using: String,
}
#[derive(Clone, Debug)]
pub struct Get {
    pub get: String,
}

impl Include {
    pub fn from(include: String) -> Include {
        Include { include: include }
    }
    pub fn to_cpp(self: &Include) -> String {
        if self.include.starts_with("\"") {
            return format!("#include {}\n", self.include);
        }
        format!("#include <{}>\n", self.include)
    }
}

impl Use {
    pub fn from(using: String) -> Use {
        Use { using: using }
    }
    pub fn to_cpp(self: &Use) -> String {
        format!("using namespace {};\n", self.using)
    }
}
