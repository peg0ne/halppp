use std::{
    env,
    str::from_utf8,
    fs::{File, remove_file},
    io::{Read, Write},
    path::Path,
    process::Command
};

use crate::{message::display_err_message, structs::CompilerPath};

pub fn get_file_path() -> String {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        display_err_message("No file path supplied in arguments!\nExiting...");
    }
    return args[1].to_owned();
}

pub fn get_content(paths: &CompilerPath) -> String {
    let path = Path::new(&paths.current);
    let display = path.display();

    let mut file = match File::open(&path) {
        Err(why) => {
            display_err_message(format!("Couldn't open {}: {}\nExiting...", display, why).as_str());
            return String::from("");
        }
        Ok(file) => file,
    };

    let mut s = String::new();
    match file.read_to_string(&mut s) {
        Err(why) => {
            display_err_message(format!("Couldn't read {}: {}\nExiting...", display, why).as_str());
            return String::from("");
        }
        Ok(file) => file,
    };

    return s;
}

pub fn write_program(program: String, paths: &CompilerPath) {
    let mut file = File::create(paths.main_path_cpp.to_owned()).expect("create failed");
    file.write_all(program.as_bytes()).expect("write failed");
}

pub fn compile_program(paths: &CompilerPath, arguments: Vec<String>, should_remove_cpp: bool) {
    let mut base_cmd = paths.output.to_owned();
    if arguments.len() > 0 { 
        base_cmd = format!("{} {}", base_cmd, arguments.join(" ")); 
    }
    let cmd: Vec<&str> = base_cmd.split(" ").collect();
    let cmd_output = Command::new("g++").args(cmd).output().expect("Failed to compile!");
    let result = match from_utf8(&cmd_output.stderr) {
        Ok(v) => v,
        Err(e) => panic!("Invalid UTF-8 sequence: {}", e),
    };
    println!("compilation completed\n\x1b[93m{}\x1b[0m", result);
    if !should_remove_cpp { return }
    let _ = remove_file(paths.main_path_cpp.to_owned());
}
