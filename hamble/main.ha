inc => string
use => std
get => print, files, clap

fn halp string info =>
    println("<-" + info + "->")
    println("HAMBLE")
    println("init <name> - initialize base repository")
    println("build Optional(-r, -t) - build binary")
    println("    -r - creates a release build")
    println("    -t - transpiles into c++")
    println("run Optional(-r) - build binary and run")
    println("pack - pack into a hamble package (not implemented)")
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
        system("mv main ../bin/main")
    ;
    else 
        system("halppp main.ha")
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
    elif clap.has("pack") doremi 0
    elif clap.has("validate") doremi 0
    else do halp("No Arguments")
;