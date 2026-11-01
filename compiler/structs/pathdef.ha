struct CompilerPath
    string folder_path = EMPTY
    string file_path = EMPTY
    string main_path = EMPTY
    string main_path_cpp = EMPTY
    string main_path_bin = EMPTY
    string output = EMPTY
    string current = EMPTY
    CompilerPath string main, string f_p, string f_n =>
        // Only swap the extension, not a `.ha` elsewhere in the path
        let has_suffix = String(main).ends_with(HA_SUFFIX)
        let bin = has_suffix ? main.substr(0, main.size() - 3) : main
        let cpp = bin + CPP_SUFFIX
        this->folder_path = f_p
        this->file_path = f_n
        this->main_path = main
        this->main_path_cpp = cpp
        this->main_path_bin = bin
        this->output = cpp + COMPILER_OUT + bin
        this->current = f_p + f_n
    ;
;