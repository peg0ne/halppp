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
    let mut cmd: Vec<String> = vec![
        "-std=c++17".to_owned(),
        paths.main_path_cpp.to_owned(),
        "-o".to_owned(),
        paths.main_path_bin.to_owned(),
    ];
    for arg in arguments.iter() {
        cmd.extend(arg.split_whitespace().map(|a| a.to_owned()));
    }
    let base_cmd = format!("{} {}", cxx_compiler(), cmd.join(" "));
    let cmd_output = Command::new(cxx_compiler()).args(&cmd).output().expect("Failed to compile!");
    let result = match from_utf8(&cmd_output.stderr) {
        Ok(v) => v,
        Err(e) => panic!("Invalid UTF-8 sequence: {}", e),
    };
    println!("{}", base_cmd);
    println!("compilation completed\n\x1b[93m{}\x1b[0m", result);
    if !should_remove_cpp { return }
    let _ = remove_file(paths.main_path_cpp.to_owned());
}

/// $HALPPP_CXX, then $CXX, then clang++ on macOS and g++ elsewhere
fn cxx_compiler() -> String {
    for var in ["HALPPP_CXX", "CXX"] {
        if let Ok(cxx) = env::var(var) {
            if !cxx.is_empty() { return cxx; }
        }
    }
    if cfg!(target_os = "macos") { "clang++".to_owned() } else { "g++".to_owned() }
}
