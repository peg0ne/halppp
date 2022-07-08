use crate::utils::get_folder_and_name;

#[derive(Clone, Debug)]
pub struct CompilerPath {
    pub folder_path: String,
    pub file_path: String,
    pub main_path: String,
    pub main_path_cpp: String,
    pub main_path_bin: String,
    pub output: String,
    pub current: String,
}

impl CompilerPath {
    pub fn from(main: String) -> CompilerPath {
        let (f_p, f_n) = get_folder_and_name(&main);
        let cpp = main.replace(".ha", ".cpp");
        let bin = main.replace(".ha", "");
        CompilerPath {
            folder_path: f_p.to_owned(),
            file_path: f_n.to_owned(),
            main_path: main,
            main_path_cpp: cpp.to_owned(),
            main_path_bin: bin.to_owned(),
            output: format!("{} -o {}", cpp, bin),
            current: format!("{}{}", f_p, f_n)
        }
    }
}