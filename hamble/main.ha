inc => string
use => std
get => print, files, clap, stringextensions
get => Manual, validator

fn halp string info => bool
    println("<-" + info + "->")
    println("HAMBLE")
    println("init <name> - initialize base repository")
    println("build Optional(-r, -t) - build binary")
    println("    -r - creates a release build")
    println("    -t - transpiles into c++")
    println("    -s - single c++ file, skips the incremental build cache")
    println("run Optional(-r) - build binary and run")
    println("do <CUSTOM COMMAND>")
    println("validate - tries to compile the tests in the test folder")
    println("man - opens manual")
    println("pack - pack into a hamble package (not implemented)")
    return false
;

// Quote an argument for the shell that runs hamble.haml commands.
// POSIX shells expand $(...) and `...` inside double quotes, so use single
// quotes there; cmd.exe has no single quotes and paths cannot contain `"`.
fn shell_quote string arg => string
    if is_windows() doremi $"\"{arg}\""
    let quoted = "'"
    foreach c in arg
        if c == '\'' do quoted += "'\\''"
        else do quoted.push_back(c)
    ;
    return quoted + "'"
;

fn hamble_base string name => string
    let base = "[commands]\n"
    let home = home_env().value_or("~")
    let bin = native_path(exe_name("bin/main"))
    let target = native_path(exe_name($"{home}/.local/bin/{name}"))
    let copy = is_windows() ? "copy /Y" : "cp"
    base += $"make={copy} {bin} {shell_quote(target)}\n"
    base += "[rules]\n[dependencies]\n"
    return base
;

fn init string name =>
    if !makedir(name) dore println("Project couldn't be initialized here!")
    if !changedir(name) dore println("Unable to move into project directory")
    // Run git inside the project so the name never reaches the shell
    if !system(string("git init")) do println("Git couldn't be initialized")
    write("# " + name, "README.md")
    write("bin/*\n.halppp-cache/\n", ".gitignore")
    write(hamble_base(name), "hamble.haml")
    if !makedir("bin") dore println("Unable to create binary directory")
    if !makedir("src") dore println("Unable to create src directory")
    if !changedir("src") dore println("Unable to move into src")
    write("get => print\n\nfn main =>\nprintln(\"hello world\")\n;", "main.ha")
;

fn is_hamble_dir => bool
    let files = list_reg_files(".")
    foreach file in files
        if file == "hamble.haml" doremi true
    ;
    return false
;

fn build => int doremi build("")
fn build string type => int
    if !is_hamble_dir()
        println("This is not a valid project to build from")
        return 0
    ;
    let files = list_files(".")
    let bin_exists = false
    foreach file in files
        if file == "bin" dobr bin_exists = true
    ;
    let binary = exe_name("main")
    if type == "halp"
        _system("halp src/main.ha")
        if !bin_exists do makedir("bin")
        move_path($"src/{binary}", $"bin/{binary}")
        return 1
    ;
    changedir("src")
    if type == "-t"
        if !system(string("halppp main.ha -t")) doremi 0
        return 1
    ;
    // -r: release build, -s: single c++ file without the incremental build cache
    let flag = type == "-r" || type == "-s" ? $" {type}" : ""
    if !system($"halppp main.ha{flag}")
        println("Build failed")
        return 0
    ;
    if !bin_exists do makedir("../bin")
    if !move_path(binary, $"../bin/{binary}") doremi 0
    return 1
;

fn run => int doremi run("")
fn run string type => int
    if !build(type)
        println("Unable to run binary")
        return 0
    ;
    changedir("..")
    if !system(native_path(exe_name("./bin/main"))) doremi 0
    return 1
;

fn watch => int doremi watch("")
fn watch string type => int
    let key = ""
    loop
        run(type)
        clear_screen()
        println("=0.o= Do you want to exit? (y/n)")
        cin >> key
        if key == "y" doremi 1
    ;
    return 0
;

fn custom string argument => bool
    if !is_hamble_dir() doremi halp("Not a valid argument")
    let lines = readlines("hamble.haml")
    bool isCommand = false
    foreach line in lines
        String l = String(line)
        if l.starts_with("[commands]") do isCommand = true
        if l.starts_with("[rules]") do isCommand = false
        if l.starts_with("[dependencies]") do isCommand = false
        if !isCommand || !l.starts_with(argument) do continue
        for i until argument.size() + 1
            l.remove(0)
        ;
        return system(l.to_string())
    ;
    return halp("Unkown command")
;

fn manual => int
    let man = Manual()
    man.run()
    return 1
;

// Commands return 1/true on success; main turns that into a process exit code
fn main =>
    if hamble(argc, argv) doremi 0
    return 1
;
fn hamble int argc, char **argv => int
    let clap = Clap(argc, argv)
    select name from clap.peek("init")
        init(name)
        return 1
    ;
    if clap.has("build")
        select type from clap.peek("build") doremi build(type)
        return build()
    ;
    elif clap.has("run")
        select type from clap.peek("run") doremi run(type)
        return run()
    ;
    elif clap.has("watch")
        select type from clap.peek("watch") doremi watch(type)
        return watch()
    ;
    elif clap.has("validate")
        return validate()
    ;
    elif clap.has("man")
        return manual()
    ;
    elif clap.has("do") 
        select type from clap.peek("do") doremi custom(type)
        return halp("No custom command supplied")
    ;
    elif clap.has("pack") doremi 0
    elif clap.has("validate") doremi 0
    else doremi halp("No argument")
;
