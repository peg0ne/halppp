#[derive(Clone, Debug)]
pub struct Condition {
    pub value1: String,
    pub value2: String,
    pub operator: String,
}

impl Condition {
    pub fn new() -> Condition {
        Condition {
            value1: String::new(),
            value2: String::new(),
            operator: String::new(),
        }
    }
}
