inc => fstream, stdlib.h, cstdio, vector, algorithm, filesystem, system_error
get => option, conditional

fn read string path => Option<string>
    string content, linebuf
    ifstream reader(path)
    if !reader doremi None<string>()
    while !reader.eof()
        getline(reader, linebuf)
        content += linebuf + "\n"
    ;
    reader.close()
    if content == "" doremi None<string>()
    return Some(content)
;
fn readlines string path => vector<string>
    vector<string> lines = {}
    let content_opt = read(path)
    if content_opt.is_none() doremi lines
    let content = content_opt.value_or("")
    int start = 0
    int end = content.find("\n")
    while end != -1
        lines.push_back(content.substr(start, end - start))
        start = end + 1
        end = content.find("\n", start)
    ;
    lines.push_back(content.substr(start, end - start))
    return lines
;
fn write string content, string path =>
    ofstream file(path)
    file << content
    file.close()
;
fn _system string command =>
    if !system(command.c_str()) do print("")
;
fn system string command => bool doremi !system(command.c_str())
fn system_output string command => vector<string>
    vector<string> output = {}
    system_output(command, &output)
    return output
;
fn system_output string command, vector<string>* output =>
    char buffer[1064]
    FILE *fp = nullptr
    raw #ifdef _WIN32
    fp = _popen(command.c_str(), "r")
    raw #else
    fp = popen(command.c_str(), "r")
    raw #endif
    if fp == nullptr do return
    while fgets(buffer, sizeof(buffer), fp) do output->push_back(buffer)
    raw #ifdef _WIN32
    _pclose(fp)
    raw #else
    pclose(fp)
    raw #endif
;
fn remove string path => do remove(path.c_str())
fn makedir string name => bool
    raw std::error_code ec;
    raw return std::filesystem::create_directory(name, ec);
;
fn changedir string name => bool
    raw std::error_code ec;
    raw std::filesystem::current_path(name, ec);
    raw return !ec;
;
fn env string env_var => Option<string>
    let e = getenv(env_var.c_str())
    if e == NULL doremi None<string>()
    return Some((string)e)
;
// Where installed halppp libraries live: $HALPPP_LIB, or ~/.local/lib/halppp
// (%USERPROFILE%/.local/lib/halppp on Windows). Always ends with a separator.
fn halppp_lib_dir => Option<string>
    select custom from env("HALPPP_LIB")
        if custom.size() > 0 && any(custom.back(), {'/', '\\'}) doremi Some(custom)
        if custom.size() > 0 doremi Some(custom + "/")
    ;
    select home from home_env() doremi Some($"{home}/.local/lib/halppp/")
    return None<string>()
;
// The C++ compiler to call: $HALPPP_CXX, then $CXX, then clang++ on macOS and g++ elsewhere.
// It must accept g++-style flags (g++, clang++, MinGW).
fn cxx_compiler => string
    select cxx from env("HALPPP_CXX")
        if cxx.size() > 0 doremi cxx
    ;
    select cxx from env("CXX")
        if cxx.size() > 0 doremi cxx
    ;
    raw #ifdef __APPLE__
    return "clang++"
    raw #else
    return "g++"
    raw #endif
;
// "linux", "macos" or "windows"
fn platform_name => string
    raw #if defined(_WIN32)
    return "windows"
    raw #elif defined(__APPLE__)
    return "macos"
    raw #else
    return "linux"
    raw #endif
;
fn is_windows => bool doremi platform_name() == "windows"
// Name of an executable built from `path`: adds .exe on Windows
fn exe_name string path => string doremi is_windows() ? path + ".exe" : path
// Path with the platform's separator, for handing to the shell (cmd.exe treats / as a switch)
fn native_path string path => string
    if !is_windows() doremi path
    let native = path
    foreach i, c in path
        if c == '/' do native[i] = '\\'
    ;
    return native
;
// The shell's null device, for silencing command output
fn null_device => string doremi is_windows() ? "NUL" : "/dev/null"
fn clear_screen => do _system(is_windows() ? "cls" : "clear")
// Move/rename a file or directory, replacing an existing file at `to`
fn move_path string from, string to => bool
    raw std::error_code ec;
    raw std::filesystem::rename(from, to, ec);
    raw return !ec;
;
fn home_env => Option<string>
    raw #ifdef _WIN32
    return env("USERPROFILE")
    raw #else
    return env("HOME")
    raw #endif
;
// kind: 0 = everything, 1 = regular files, 2 = directories
// Symlinks are not followed, and "." / ".." are listed like readdir does
fn _list_entries string path, int kind => vector<string>
    vector<string> files = {}
    raw std::error_code ec;
    raw std::filesystem::directory_iterator it(path, ec);
    if ec doremi files
    if kind != 1
        files.push_back(".")
        files.push_back("..")
    ;
    raw for (auto& entry : it) {
    raw     auto status = entry.symlink_status(ec);
    raw     if (kind == 1 && !std::filesystem::is_regular_file(status)) continue;
    raw     if (kind == 2 && !std::filesystem::is_directory(status)) continue;
    raw     files.push_back(entry.path().filename().string());
    raw }
    sort(files.begin(), files.end())
    return files
;
fn list_reg_files string path => vector<string> doremi _list_entries(path, 1)
fn list_dirs string path => vector<string> doremi _list_entries(path, 2)
fn list_files string path => vector<string> doremi _list_entries(path, 0)
