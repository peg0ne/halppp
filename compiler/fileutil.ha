inc => fstream

fn get_file_path int argc, char **argv => string
    if argc < 2 do error("No file path supplied in arguments!\nExiting...", "")
    let fp = ""
    let i = 0
    while argv[1][i] != '\0' do fp.push_back(argv[1][i++])
    return fp
;
fn get_content CompilerPath paths, bool can_be_lib => string
    string content, linebuf
    ifstream reader(paths.current)
    if !reader && can_be_lib
        select home from home_env()
            reader = ifstream($"{home}/.local/lib/halppp/{paths.current}")
        ;
    ;
    if !reader do error("Couldn't open file\nExiting...", "")
    while !reader.eof()
        getline(reader, linebuf)
        content += $"{linebuf}\n"
    ;
    return content
;
fn write_program string program, CompilerPath paths =>
    ofstream file(paths.main_path_cpp)
    file << program
    file.close()
;
fn to_char_arr string s, char *buf => char*
    for i until s.size() do buf[i] = s.at(i)
    buf[s.size()] = '\0'
    return buf
;
fn compile_program CompilerPath paths, vector<string> arguments, bool is_release =>
    let base_cmd= "g++ "
    base_cmd += is_release ? "-O3 " : "-Wall "
    base_cmd += paths.output
    for i until arguments.size() do base_cmd += $" {arguments.at(i)}"
    println("compiling: " + base_cmd)
    char cmd[base_cmd.size() + 1]
    char cpp_path[paths.main_path_cpp.size() + 1]
    let _ = system(to_char_arr(base_cmd, cmd))
    remove(to_char_arr(paths.main_path_cpp, cpp_path))
;
