use std::{env, fs::File, io::Read, path::Path};

use crate::message::display_err_message;

pub fn get_file_path() -> String {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        display_err_message("No file path supplied in arguments!\nExiting...");
    }
    return args[1].to_owned();
}

pub fn get_content(fp: &String) -> String {
    let path = Path::new(&fp);
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
