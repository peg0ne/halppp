inc => fstream

fn get_file_path int argc, char **argv => string
    if argc < 2 do display_err_message("No file path supplied in arguments!\nExiting...")
    string fp = EMPTY
    let i = 0
    while argv[1][i] != '\0' do fp.push_back(argv[1][i++])
    return fp
;
fn get_content CompilerPath paths => string 
    string content = " "
    string linebuf
    ifstream reader(paths.current)
    if !reader do display_err_message("Couldn't open file\nExiting...")
    while !reader.eof()
        getline(reader, linebuf)
        content += linebuf + "\n"
    ;
    return content
;
fn write_program string program, CompilerPath paths =>
    ofstream file("ha" + paths.main_path_cpp)
    file << program
    file.close()
;
fn compile_program CompilerPath paths, vector<string> arguments, bool should_remove_cpp =>
    return
;
