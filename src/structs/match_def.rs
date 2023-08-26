#[derive(Clone, Debug)]
pub struct Match {
    pub matcher_expr: String,
    pub statements: Vec<String>,
    pub lines: Vec<Vec<String>>,
    pub operators: Vec<String>,
    pub id: Option<String>,
    pub is_let: bool,
}

impl Match {
    pub fn new(id: Option<String>, is_let: bool) -> Match {
        Match {
            matcher_expr: String::new(),
            statements: Vec::new(),
            lines: Vec::new(),
            operators: Vec::new(),
            id: id,
            is_let: is_let
        }
    }
}