inc => string
use => std
get => print, files, clap, stringextensions
get => Manual

fn halp string info => bool
    println("<-" + info + "->")
    println("HAMBLE")
    println("init <name> - initialize base repository")
    println("build Optional(-r, -t) - build binary")
    println("    -r - creates a release build")
    println("    -t - transpiles into c++")
    println("run Optional(-r) - build binary and run")
    println("man - opens manual")
    println("pack - pack into a hamble package (not implemented)")
    return false
;

fn hamble_base string name => string
    let base = "[commands]\n"
    base += "make=cp bin/main $HOME/.local/bin/" + name + "\n"
    base += "[rules]\n[dependencies]\n"
    return base
;

fn init string name =>
    if !makedir(name) dore println("Project couldn't be initialized here!")
    if !system("git init " + name) do println("Git couln't be initialized")
    if !changedir(name) dore println("Unable to move into project directory")
    write("# " + name, "README.md")
    write("bin/*\n", ".gitignore")
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
    if type == "halp"
        system("halp src/main.ha")
        system("mkdir bin")
        system("mv src/main bin/main")
        return 1
    ;
    changedir("src")
    if type == "-t"
        system("halppp main.ha -t")
        return 0
    ;
    elif type == "-r"
        system("halppp main.ha -r")
        system("mkdir bin")
        system("mv main ../bin/main")
    ;
    else 
        system("halppp main.ha")
        system("mkdir bin")
        system("mv main ../bin/main")
    ;
    return 1
;

fn run => int doremi run("")
fn run string type => int
    if !build(type)
        println("Unable to run binary")
        return 0
    ;
    changedir("..")
    system("./bin/main")
    return 1
;

fn watch => int doremi watch("")
fn watch string type => int
    let key = ""
    loop
        run(type)
        system("clear")
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
        system(l.to_string())
        doremi true
    ;
    return halp("Unkown command")
;

fn manual => int
    let man = Manual()
    man.run()
    return 1
;

fn main =>
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