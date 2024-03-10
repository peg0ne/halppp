inc => fstream, stdlib.h, vector, dirent.h, algorithm, unistd.h, sys/stat.h
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
fn system string command => bool doremi !system(command.c_str())
fn system_output string command => vector<string>
    vector<string> output = {}
    system_output(command, &output)
    return output
;
fn system_output string command, vector<string>* output =>
    char buffer[1064]
    let fp = popen(command.c_str(), "r")
    while fgets(buffer, sizeof(buffer), fp) do output->push_back(buffer)
    pclose(fp)
;
fn remove string path => do remove(path.c_str())
fn makedir string name => bool
    raw #ifdef _WIN32
    return !mkdir(name.c_str())
    raw #else
    return !mkdir(name.c_str(), S_IRWXU)
    raw #endif
;
fn changedir string name => bool doremi chdir(name.c_str()) >= 0
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
fn list_reg_files string path => vector<string>
    vector<string> files = {}
    struct dirent *diread
    let dir = opendir(path.c_str())
    if dir == nullptr doremi files
    while (diread = readdir(dir)) != nullptr
        if diread->d_type != DT_REG do continue
        files.push_back(diread->d_name)
    ;
    closedir(dir)
    sort(files.begin(), files.end())
    return files
;
fn list_dirs string path => vector<string>
    vector<string> files = {}
    struct dirent *diread
    let dir = opendir(path.c_str())
    if dir == nullptr doremi files
    while (diread = readdir(dir)) != nullptr
        if diread->d_type != DT_DIR do continue
        files.push_back(diread->d_name)
    ;
    closedir(dir)
    sort(files.begin(), files.end())
    return files
;
fn list_files string path => vector<string>
    vector<string> files = {}
    struct dirent *diread
    let dir = opendir(path.c_str())
    if dir == nullptr doremi files
    while (diread = readdir(dir)) != nullptr do files.push_back(diread->d_name)
    closedir(dir)
    sort(files.begin(), files.end())
    return files
;
