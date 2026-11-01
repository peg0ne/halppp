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
