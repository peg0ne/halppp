get => dictionary

fn run_test string file => bool doremi system($"halppp ./tests/{file} -t 2>&1 /dev/null")
fn error string msg => do println($"\033[31m{msg}\033[0m")
fn good string msg => do println($"\033[32m{msg}\033[0m")

fn validate => bool
    let files = list_reg_files("./tests")
    if files.size() <= 0 doremi 1
    let tests = map<string>(files)
        .where(x => String(x).ends_with(".ha"))
    
    Dictionary<string, bool> failed = Dictionary<string, bool>()
    foreach test in tests
        if run_test(test) do continue
        failed.add(test, false)
    ;
    
    if failed.keys().size() == 0 do good("No Errors!")
    else do error($"Failed: {failed.keys().size()}/{tests.size()}")
    foreach test in tests
        if failed.contains(test) do error(test)
        else do good(test)
    ;
    return failed.keys().size() > 0
;
