get => dictionary

fn run_test string file => bool doremi system($"halppp ./tests/{file} -t 2>&1 /dev/null")
fn run_compile_test string file => bool doremi system($"g++ ./tests/{file}.cpp -o tests/{file}")
fn run_program_test string file => bool doremi system($"./tests/{file}")
fn clean_up_cpp string file => do remove($"./tests/{file}.cpp")
fn clean_up_program string file => do remove($"./tests/{file}")
fn error string msg => do println($"\033[31m{msg}\033[0m")
fn good string msg => do println($"\033[32m{msg}\033[0m")

fn validate => bool
    let files = list_reg_files("./tests")
    if files.size() <= 0 doremi 1
    let tests = map<string>(files)
        .where(x => String(x).ends_with(".ha"))
    
    //Transpile
    println("Transpile")
    Dictionary<string, bool> failed = Dictionary<string, bool>()
    foreach test in tests
        if run_test(test) do continue
        failed.add(test, false)
    ;
    
    if failed.keys().size() == 0 do good("No Errors!")
    else do error($"Failed Transpile: {failed.keys().size()}/{tests.size()}")
    foreach test in tests
        if failed.contains(test) do error(test)
        else do good(test)
    ;

    //Compile
    println("\nCompile")
    Dictionary<string, bool> failed_compile = Dictionary<string, bool>()
    foreach test in tests
        if failed.contains(test) do continue
        if !run_compile_test(String(test).replace(".ha", "")) do failed_compile.add(test, false)
        clean_up_cpp(String(test).replace(".ha", ""))
    ;
    
    if failed_compile.keys().size() == 0 do good("No Errors!")
    else do error($"Failed Compile: {failed_compile.keys().size()}/{tests.size()-failed.keys().size()}")
    foreach test in tests
        if failed.contains(test) do continue
        if failed_compile.contains(test) do error(test)
        else do good(test)
    ;

    //Run
    println("\nRun")
    Dictionary<string, bool> failed_program = Dictionary<string, bool>()
    foreach test in tests
        if failed.contains(test) do continue
        if failed_compile.contains(test) do continue
        if !run_program_test(String(test).replace(".ha", "")) do failed_compile.add(test, false)
        clean_up_program(String(test).replace(".ha", ""))
    ;
    
    if failed_program.keys().size() == 0 do good("No Errors!")
    else do error($"Failed Run: {failed_program.keys().size()}/{tests.size()-failed.keys().size()-failed_compile.keys().size()}")
    foreach test in tests
        if failed.contains(test) do continue
        if failed_compile.contains(test) do continue
        if failed_program.contains(test) do error(test)
        else do good(test)
    ;
    return failed.keys().size() > 0
;
