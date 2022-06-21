#[derive(Clone, Debug)]
pub struct For {
    pub iterator: String,
    pub until: String,
}

impl For {
    pub fn new() -> For {
        For {
            iterator: String::new(),
            until: String::new(),
        }
    }
}
