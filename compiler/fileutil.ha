inc => fstream

fn get_file_path int argc, char **argv => string
    if argc < 2 do display_err_message("No file path supplied in arguments!\nExiting...", "")
    string fp = EMPTY
    let i = 0
    while argv[1][i] != '\0' do fp.push_back(argv[1][i++])
    return fp
;
fn get_content CompilerPath paths, bool can_be_lib => string
    string content
    string linebuf
    let reader = ifstream(paths.current)
    if !reader && can_be_lib
        select home from env("HOME")
            reader = ifstream(home + "/.local/lib/halppp/" + paths.current)
        ;
    ;
    if !reader do display_err_message("Couldn't open file\nExiting...", "")
    while !reader.eof()
        {getline(reader, linebuf);}
        content += linebuf + "\n"
    ;
    return content
;
fn write_program string program, CompilerPath paths =>
    let file = ofstream(paths.main_path_cpp)
    file << program
    file.close()
;
fn compile_program CompilerPath paths, vector<string> arguments, bool is_release =>
    string base_cmd= "g++ "
    base_cmd += is_release ? "-O3 " : "-Wall "
    base_cmd += paths.output
    for i until arguments.size() do base_cmd += " " + arguments.at(i)
    println("compiling: " + base_cmd)
    system(base_cmd.c_str())
    remove(paths.main_path_cpp.c_str())
;