struct CompilerPath
    string folder_path = EMPTY
    string file_path = EMPTY
    string main_path = EMPTY
    string main_path_cpp = EMPTY
    string main_path_bin = EMPTY
    string output = EMPTY
    string current = EMPTY
    CompilerPath string main =>
        let (f_p, f_n) = get_folder_and_name(&main);
        let cpp = main.replace(HA_SUFFIX, CPP_SUFFIX);
        let bin = main.replace(HA_SUFFIX, EMPTY);
        folder_path = f_p
        file_path = f_n
        main_path = main
        main_path_cpp = cpp
        main_path_bin = bin
        output = cpp + COMPILER_OUT + bin
        current = f_p + f_n
    ;
;