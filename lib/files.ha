inc => fstream, stdlib.h, vector, dirent.h, algorithm, unistd.h, sys/stat.h
get => option, conditional

fn read string path => Option<string>
    string content
    string linebuf
    let reader = ifstream(path)
    if !reader doremi None<string>()
    while !reader.eof()
        {getline(reader, linebuf);}
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
    let file = ofstream(path)
    file << content
    file.close()
;
fn remove string path => do remove(path.c_str())
fn system string command => bool doremi !system(command.c_str())
fn system_output string command => vector<string>
    vector<string> output = {}
    let fp = popen(command.c_str(), "r")
    if fp == NULL doremi output
    {
        char buffer[1064];
        while (fgets(buffer, sizeof(buffer), fp))
            output.push_back(buffer);
    }
    {pclose(fp);}
    return output
;
fn makedir string name => bool doremi mkdir(name.c_str(), S_IRWXU)
fn changedir string name => bool doremi chdir(name.c_str())
fn env string env_var => Option<string>
    let e = getenv(env_var.c_str())
    if e == NULL doremi None<string>()
    return Some((string)e)
;
fn list_reg_files string path => vector<string>
    vector<string> files = {}
    struct dirent *diread
    let dir = opendir(path.c_str())
    if dir != nullptr
        while (diread = readdir(dir)) != nullptr
            if diread->d_type != DT_REG do continue
            files.push_back(diread->d_name)
        ;
        {closedir(dir);}
    ;
    {sort(files.begin(), files.end());}
    return files
;
fn list_dirs string path => vector<string>
    vector<string> files = {}
    let dir = opendir(path.c_str())
    struct dirent *diread
    if dir != nullptr
        while (diread = readdir(dir)) != nullptr
            if diread->d_type != DT_DIR do continue
            files.push_back(diread->d_name)
        ;
        {closedir(dir);}
    ;
    {sort(files.begin(), files.end());}
    return files
;
fn list_files string path => vector<string>
    vector<string> files = {}
    let dir = opendir(path.c_str())
    struct dirent *diread
    if dir != nullptr
        while (diread = readdir(dir)) != nullptr do files.push_back(diread->d_name)
        {closedir(dir);}
    ;
    {sort(files.begin(), files.end());}
    return files
;