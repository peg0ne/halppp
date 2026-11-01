inc => fstream, filesystem

fn get_file_path int argc, char **argv => string
    if argc < 2 do error("No file path supplied in arguments!\nExiting...", "")
    let fp = ""
    let i = 0
    while argv[1][i] != '\0' do fp.push_back(argv[1][i++])
    // The binary is written next to the source with `.ha` stripped,
    // so any other name would overwrite the source file
    if !String(fp).ends_with(HA_SUFFIX) do error($"Source file must end in {HA_SUFFIX}: {fp}\nExiting...", "")
    return fp
;
fn lib_dir_display => string doremi halppp_lib_dir().value_or("$HALPPP_LIB")

fn get_content CompilerPath paths, bool can_be_lib => string
    string content, linebuf
    ifstream reader(paths.current)
    if !reader && can_be_lib
        select dir from halppp_lib_dir()
            reader = ifstream(dir + paths.current)
        ;
    ;
    if !reader do error($"Couldn't open file: {paths.current}\nExiting...", "")
    while getline(reader, linebuf)
        // Accept Windows (CRLF) line endings
        if linebuf.size() > 0 && linebuf.back() == '\r' do linebuf.pop_back()
        content += $"{linebuf}\n"
    ;
    return content
;
fn canonical_path string path => string
    raw return std::filesystem::weakly_canonical(std::filesystem::path(path)).string();
;
fn resolve_get_path string local_path, string lib_name => string
    let local_reader = ifstream(local_path)
    if local_reader doremi local_path
    select dir from halppp_lib_dir()
        let lib_path = dir + lib_name
        let lib_reader = ifstream(lib_path)
        if lib_reader doremi lib_path
    ;
    hint($"[Get]: {lib_name} not found locally ({local_path}) or in {lib_dir_display()}")
    return local_path
;
fn write_program string program, CompilerPath paths =>
    ofstream file(paths.main_path_cpp)
    file << program
    file.close()
;
// Quote a path for system(). POSIX shells still expand $(...) and `...` inside
// double quotes, so use single quotes there and escape embedded ones as '\''.
// cmd.exe has no single quotes, and Windows paths cannot contain `"`.
fn quote_path string path => string
    raw #ifdef _WIN32
    return $"\"{path}\""
    raw #else
    let quoted = "'"
    foreach c in path
        if c == '\'' do quoted += "'\\''"
        else do quoted.push_back(c)
    ;
    return quoted + "'"
    raw #endif
;
fn compile_program CompilerPath paths, vector<string> arguments, bool is_release =>
    let base_cmd = cxx_compiler()
    // std::filesystem & friends need C++17; Apple clang defaults to an older standard
    base_cmd += " -std=c++17 "
    base_cmd += is_release ? "-O3 " : "-Wall "
    base_cmd += $"{quote_path(paths.main_path_cpp)} -o {quote_path(paths.main_path_bin)}"
    for i until arguments.size() do base_cmd += $" {arguments.at(i)}"
    println("compiling: " + base_cmd)
    raw #ifdef _WIN32
    // cmd.exe strips the outer quotes of a command line that starts with a quote
    base_cmd = $"\"{base_cmd}\""
    raw #endif
    let status = system(base_cmd.c_str())
    remove(paths.main_path_cpp.c_str())
    if status != 0 do exit(1)
;
