inc => fstream, sstream, filesystem, thread, atomic, cstdio, cctype

fn get_file_path int argc, char **argv => string
    if argc < 2 do error("No file path supplied in arguments!\nExiting...", "")
    let fp = ""
    let i = 0
    while argv[1][i] != '\0' do fp.push_back(argv[1][i++])
    // The binary is written next to the source with `.ha` stripped,
    // so any other name would overwrite the source file
    if !String(fp).ends_with(HA_SUFFIX) do error($"Source file must end in {HA_SUFFIX}: {fp}\nExiting...", "")
    return fp
;
fn lib_dir_display => string doremi halppp_lib_dir().value_or("$HALPPP_LIB")

fn get_content CompilerPath paths, bool can_be_lib => string
    string content, linebuf
    ifstream reader(paths.current)
    if !reader && can_be_lib
        select dir from halppp_lib_dir()
            reader = ifstream(dir + paths.current)
        ;
    ;
    if !reader do error($"Couldn't open file: {paths.current}\nExiting...", "")
    while getline(reader, linebuf)
        // Accept Windows (CRLF) line endings
        if linebuf.size() > 0 && linebuf.back() == '\r' do linebuf.pop_back()
        content += $"{linebuf}\n"
    ;
    return content
;
fn canonical_path string path => string
    raw return std::filesystem::weakly_canonical(std::filesystem::path(path)).string();
;
fn resolve_get_path string local_path, string lib_name => string
    let local_reader = ifstream(local_path)
    if local_reader doremi local_path
    select dir from halppp_lib_dir()
        let lib_path = dir + lib_name
        let lib_reader = ifstream(lib_path)
        if lib_reader doremi lib_path
    ;
    hint($"[Get]: {lib_name} not found locally ({local_path}) or in {lib_dir_display()}")
    return local_path
;
fn write_program string program, CompilerPath paths =>
    ofstream file(paths.main_path_cpp)
    file << program
    file.close()
;
// Quote a path for system(). POSIX shells still expand $(...) and `...` inside
// double quotes, so use single quotes there and escape embedded ones as '\''.
// cmd.exe has no single quotes, and Windows paths cannot contain `"`.
fn quote_path string path => string
    raw #ifdef _WIN32
    return $"\"{path}\""
    raw #else
    let quoted = "'"
    foreach c in path
        if c == '\'' do quoted += "'\\''"
        else do quoted.push_back(c)
    ;
    return quoted + "'"
    raw #endif
;
fn run_command string command => int
    raw #ifdef _WIN32
    // cmd.exe strips the outer quotes of a command line that starts with a quote
    command = $"\"{command}\""
    raw #endif
    return system(command.c_str())
;
fn compile_program CompilerPath paths, vector<string> arguments, bool is_release =>
    let base_cmd = cxx_compiler()
    // std::filesystem & friends need C++17; Apple clang defaults to an older standard
    base_cmd += " -std=c++17 "
    base_cmd += is_release ? "-O3 " : "-Wall "
    base_cmd += $"{quote_path(paths.main_path_cpp)} -o {quote_path(paths.main_path_bin)}"
    for i until arguments.size() do base_cmd += $" {arguments.at(i)}"
    println("compiling: " + base_cmd)
    let status = run_command(base_cmd)
    remove(paths.main_path_cpp.c_str())
    if status != 0 do exit(1)
;

// ---- Incremental builds ----
// Every .ha file becomes its own translation unit in .halppp-cache/<name>-<mode>/,
// all sharing program.h (includes, types, class layouts, declarations).
// A unit is only recompiled when its key (compiler flags + program.h + its own
// code) differs from the one stored when it was last compiled successfully.

// Stable 64 bit FNV-1a hash as 16 hex digits
fn fnv_hash string text => string
    raw unsigned long long h = 1469598103934665603ULL;
    raw for (unsigned char c : text) { h ^= c; h *= 1099511628211ULL; }
    raw char buf[17];
    raw std::snprintf(buf, sizeof(buf), "%016llx", h);
    raw return std::string(buf);
;
// Cache file name for a source path: readable part plus a hash so a/b.ha and a_b.ha differ
fn unit_name string path => string
    let name = ""
    foreach c in path
        raw name.push_back(std::isalnum(static_cast<unsigned char>(c)) ? c : '_');
    ;
    if name.size() > 48 do name = name.substr(name.size() - 48)
    return name + "_" + fnv_hash(path).substr(0, 8)
;
fn read_file string path => string
    ifstream reader(path, ios::binary)
    if !reader doremi EMPTY
    raw std::stringstream buffer;
    raw buffer << reader.rdbuf();
    raw return buffer.str();
;
fn file_exists string path => bool
    raw std::error_code ec;
    raw return std::filesystem::exists(path, ec);
;
// Only touch files whose content changed
fn write_if_changed string path, string content =>
    if file_exists(path) && read_file(path) == content do return
    ofstream file(path, ios::binary)
    file << content
    file.close()
;
// Flags that only mean something to the linker
fn is_link_flag string arg => bool
    let a = String(arg)
    return a.starts_with("-l") || a.starts_with("-L") || a.starts_with("-Wl,") || a.starts_with("-framework")
;
// `compiler => "&& cp ..."` chains a shell command onto the build; it and
// everything after it only belongs on the final (link) command
fn is_shell_chain string arg => bool
    let a = String(arg)
    return a.starts_with("&&") || a.starts_with("||") || a.starts_with(";") || a.starts_with("|")
;
// Parallel jobs: $HALPPP_JOBS, or the number of cores
fn build_jobs => int
    select jobs from env("HALPPP_JOBS")
        raw int n = std::atoi(jobs.c_str());
        raw if (n > 0) return n;
    ;
    raw unsigned cores = std::thread::hardware_concurrency();
    raw return cores > 0 ? (int)cores : 1;
;
// Runs the commands on build_jobs() threads, returns each exit status
fn run_commands vector<string> commands => vector<int>
    raw std::vector<int> status(commands.size(), 0);
    raw std::atomic<size_t> next_index{0};
    raw std::vector<std::thread> workers;
    raw size_t jobs = std::min((size_t)build_jobs(), commands.size());
    raw for (size_t w = 0; w < jobs; w++) workers.emplace_back([&]() {
    raw     for (size_t i = next_index++; i < commands.size(); i = next_index++) status[i] = run_command(commands[i]);
    raw });
    raw for (auto &worker : workers) worker.join();
    raw return status;
;
// Removes cache entries of units that are no longer part of the program
fn remove_stale_units string cache, vector<Unit> units =>
    raw std::error_code ec;
    raw for (auto &entry : std::filesystem::directory_iterator(cache, ec)) {
    raw     std::string stem = entry.path().stem().string();
    raw     std::string file = entry.path().filename().string();
    raw     if (file == "program.h" || file == "program.h.gch" || file == "program.h.pch" || file == "program.h.stamp") continue;
    raw     bool used = false;
    raw     for (auto &u : units) if (u.name == stem) used = true;
    raw     if (!used) std::filesystem::remove(entry.path(), ec);
    raw }
;
// The shared header is precompiled once instead of parsed by every unit.
// g++ finds program.h.gch next to program.h by itself, clang++ needs -include-pch.
// HALPPP_PCH=0 turns it off.
fn use_pch => bool
    select pch from env("HALPPP_PCH")
        if pch == "0" doremi false
    ;
    return true
;
fn pch_file string cache => string
    if String(cxx_compiler()).contains("clang") doremi cache + "program.h.pch"
    return cache + "program.h.gch"
;
// Extra unit flags to use the precompiled header
fn pch_flag string cache => string
    if !use_pch() || !String(cxx_compiler()).contains("clang") doremi EMPTY
    return $" -include-pch {quote_path(pch_file(cache))}"
;
fn precompile_header string cache, string compile_flags, string header_key =>
    let pch = pch_file(cache)
    if !use_pch()
        // g++ would still pick up a stale program.h.gch on its own
        remove(pch.c_str())
        return
    ;
    let stamp = cache + "program.h.stamp"
    if file_exists(pch) && read_file(stamp) == header_key do return
    remove(stamp.c_str())
    remove(pch.c_str())
    let header = cache + "program.h"
    println("compiling: program.h (precompiled header)")
    // A broken header would fail in every unit, so report it once and stop
    if run_command($"{compile_flags} -x c++-header {quote_path(header)} -o {quote_path(pch)}") != 0
        remove(pch.c_str())
        exit(1)
    ;
    write_if_changed(stamp, header_key)
;
fn compile_incremental CompilerPath paths, string header, vector<Unit> units, vector<string> arguments, bool is_release =>
    let name = paths.file_path.substr(0, paths.file_path.size() - 3)
    let mode = is_release ? "release" : "debug"
    let cache = $"{paths.folder_path}.halppp-cache/{name}-{mode}/"
    raw std::error_code ec;
    raw std::filesystem::create_directories(cache, ec);
    if ec do error($"Couldn't create build cache: {cache}\nExiting...", "")
    let base = cxx_compiler()
    base += is_release ? " -std=c++17 -O3" : " -std=c++17 -Wall"
    let compile_flags = base
    let link_args = ""
    let in_shell_chain = false
    foreach arg in arguments
        if is_shell_chain(arg) do in_shell_chain = true
        if !in_shell_chain && String(arg).starts_with("-") && !is_link_flag(arg) do compile_flags += $" {arg}"
        link_args += $" {arg}"
    ;
    write_if_changed(cache + "program.h", "#pragma once\n" + header)
    let header_key = fnv_hash(compile_flags + "\n" + header)
    vector<string> commands = {}
    vector<string> stamps = {}
    vector<string> keys = {}
    let objects = ""
    foreach unit in units
        let source = cache + unit.name + CPP_SUFFIX
        let object = cache + unit.name + ".o"
        let stamp = cache + unit.name + ".stamp"
        objects += $" {quote_path(object)}"
        let key = fnv_hash(compile_flags + "\n" + header + "\n" + unit.body)
        write_if_changed(source, "#include \"program.h\"\n" + unit.body)
        if file_exists(object) && read_file(stamp) == key do continue
        // Forget the old key first, so a failed or interrupted compile is retried
        remove(stamp.c_str())
        commands.push_back($"{compile_flags}{pch_flag(cache)} -c {quote_path(source)} -o {quote_path(object)}")
        stamps.push_back(stamp)
        keys.push_back(key)
    ;
    println($"compiling: {commands.size()} of {units.size()} units changed ({cache})")
    if commands.size() > 0 do precompile_header(cache, compile_flags, header_key)
    foreach command in commands do println("compiling: " + command)
    let status = run_commands(commands)
    let failed = false
    for i until status.size()
        if status.at(i) != 0 doco failed = true
        write_if_changed(stamps.at(i), keys.at(i))
    ;
    if failed do exit(1)
    remove_stale_units(cache, units)
    // Libraries go after the objects that need them
    let link_cmd = $"{base}{objects} -o {quote_path(paths.main_path_bin)}{link_args}"
    println($"linking: {paths.main_path_bin} ({units.size()} units)")
    if run_command(link_cmd) != 0 do exit(1)
;
