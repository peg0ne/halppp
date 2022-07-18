inc => fstream, stdlib.h
get => option

fn read string path => Option<string>
    string content, linebuf
    ifstream reader(path)
    if !reader doremi None<string>()
    while !reader.eof()
        getline(reader, linebuf)
        content += linebuf + "\n"
    ;
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
fn env string env_var => Option<string>
    char env_var_arr[env_var.size() + 1]
    for i until env_var.size() do env_var_arr[i] = env_var.at(i)
    env_var_arr[env_var.size()] = '\0'
    let e = getenv(env_var_arr)
    if e == NULL doremi None<string>()
    return Some((string)e)
;
