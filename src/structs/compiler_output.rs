pub struct CompilerOutput {
    pub output: String,
    pub includes: String,
    pub headers: String,
    pub fnheaders: String,
    pub arguments: Vec<String>,
}

impl CompilerOutput {
    pub fn content(self: &CompilerOutput) -> String {
        let mut c = String::from(self.includes.as_str());
        c.push_str(self.headers.as_str());
        c.push_str(self.fnheaders.as_str());
        c.push_str(self.output.as_str());
        c
    }
    pub fn from(o: String, i: String, h: String, fh: String, args: Vec<String>) -> CompilerOutput {
        CompilerOutput {
            output: o,
            includes: i,
            headers: h,
            fnheaders: fh,
            arguments: args,
        }
    }
}