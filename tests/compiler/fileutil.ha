fn get_file_path int argc, char **argv => string
    if argc < 2 do display_err_message("No file path supplied in arguments!\nExiting...")
    return (string)argv[1]
;
fn get_content CompilerPath paths => string 
    return ""
;
fn write_program string program, CompilerPath paths =>
    return
;
fn compile_program CompilerPath paths, vector<string> arguments, bool should_remove_cpp =>
    // let mut base_cmd = paths.output.to_owned();
    // if arguments.len() > 0 { 
    //     base_cmd = format!("{} {}", base_cmd, arguments.join(" ")); 
    // }
    // let cmd: Vec<&str> = base_cmd.split(" ").collect();
    // let cmd_output = Command::new("g++").args(cmd).output().expect("Failed to compile!");
    // let result = match from_utf8(&cmd_output.stderr) {
    //     Ok(v) => v,
    //     Err(e) => panic!("Invalid UTF-8 sequence: {}", e),
    // };
    // println!("{}", base_cmd);
    // println!("compilation completed\n\x1b[93m{}\x1b[0m", result);
    // if !should_remove_cpp { return }
    // let _ = remove_file(paths.main_path_cpp.to_owned());
;
