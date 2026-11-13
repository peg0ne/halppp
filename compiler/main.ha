inc => string
get => ../lib/[peekable, print, stringextensions, conditional, clap, list, files]
get => consts/[strings, tokens, errors]
get => enums/[token, variablestate]
get => structs/[asttoken, pathdef]
get => structs/[variabledef, enumdef]
get => structs/[importsdef, globaldef, structdef]
get => structs/[fordef, conditiondef, selectdef, matchdef, expressiondef]
get => structs/[functiondef, classdef]
get => structs/[programdef, compilerdef]
get => structs/[mapdef, unitdef]
get => message, utils, fileutil
get => ast, imports, enums, foreacher, expressions, matching, mapper
get => switch, selects, conditions, variable, template
get => functions, classes, globals
compiler => "-O3"

struct CompileOutput
    string output = ""
    string includes = ""
    string headers = ""
    string fnheaders = ""
    vector<string> arguments = {}
    // Same as output, but with function and method bodies moved into units
    string header_output = ""
    vector<Unit> units = {}
    fn content => string doremi includes + headers + fnheaders + output
    fn header => string doremi includes + headers + fnheaders + header_output
    CompileOutput string output, string includes, string headers, string fnheaders, vector<string> args =>
        this->output = output
        this->includes = includes
        this->headers = headers
        this->fnheaders =fnheaders
        this->arguments = args
    ;
;

fn main =>
    let clap = Clap(argc, argv)
    FpFn fpfn = folder_and_name(get_file_path(argc, argv))
    let paths = CompilerPath(get_file_path(argc, argv), fpfn.f_p, fpfn.f_n)
    let p = Program()
    let output = compile_main(paths, &p)
    // -t: only transpile, -s: build everything as one translation unit (no cache)
    if clap.has("-t") || clap.has("-s")
        write_program(output.content(), paths)
        if !clap.has("-t") do compile_program(paths, output.arguments, clap.has("-r"))
        return 0
    ;
    compile_incremental(paths, output.header(), output.units, output.arguments, clap.has("-r"))
;

fn compile_main CompilerPath paths, Program *p => CompileOutput doremi compile(paths, p, true)
fn compile CompilerPath paths, Program *p, bool is_main => CompileOutput
    println("compiling: " + paths.current)
    let output = ""
    let includes = ""
    let headers = ""
    let fnheaders = ""
    let is_named = false
    // Incremental builds: header_output is shared by every unit, unit_output only
    // holds this file's function bodies so editing them rebuilds just this file
    let header_output = ""
    let unit_output = ""
    let unit_has_code = false
    vector<Unit> units = {}
    let content = get_content(paths, !is_main)
    let extralines = 0
    if is_main
        extralines = 5
        let extras = "\nfn to_string string value => string doremi value\n" 
        extras += "\ninc => string\nuse => std\n"
        content = extras + content
    ;
    let ast = ast_create(content, extralines)
    let compiler_t = Compiler(p, ast, extralines)
    vector<string> incs = {}
    string args = EMPTY
    loop
        let next = next_or_exit(&compiler_t, "Compiler failed to do unexpected EOF")
        if !next.is_base()
            error($"Token not allowed in base: {next.token}", compiler_t.recap())
        ;
        if next.is_terminator() do break
        elif next.is_nl() do continue
        elif next.is_classy()
            let classdef = class_construct(&compiler_t, next.token == Token::Struct, paths)
            output += classdef.to_cpp()
            headers += classdef.to_cpp_h()
            header_output += classdef.to_cpp_header()
            let impl = classdef.to_cpp_impl()
            if impl.size() > 0
                unit_output += impl
                unit_has_code = true
            ;
            continue
        ;
        match next.token
            Token::Named =>
                if is_named do error("[Named] cannot have nested namespaces", compiler_t.recap())
                is_named = true
                arrow_or_exit(&compiler_t, "[Named] missing => in declaration");
                let id = id_or_exit(&compiler_t, "[Named] cannot create namespace without Id");
                output += $"namespace {id}\n" + "{\n"
                headers += $"namespace {id}\n" + "{\n"
                fnheaders += $"namespace {id}\n" + "{\n"
                header_output += $"namespace {id}\n" + "{\n"
                unit_output += $"namespace {id}\n" + "{\n"
            ;
            Token::Function =>
                let fndef = function_construct(&compiler_t, VariableState::Public, false)
                output += fndef.to_cpp_def()
                fnheaders += fndef.to_cpp_h()
                // fnheaders already declares every function (with its default arguments)
                if fndef.templates.size() > 0 do header_output += fndef.to_cpp_def()
                elif fndef.header_only() do header_output += "inline " + fndef.to_cpp_def()
                else
                    unit_output += fndef.to_cpp_def()
                    unit_has_code = true
                ;
            ;
            Token::Enum =>
                let enumdef = enums_construct(&compiler_t)
                output += enumdef.to_cpp()
                headers += enumdef.to_cpp_h()
                header_output += enumdef.to_cpp_header()
                unit_output += enumdef.to_cpp_string()
                unit_has_code = true
            ;
            Token::Global =>
                let global = global_construct(&compiler_t)
                headers += global.to_cpp()
            ;
            Token::Include =>
                incs = imports_creation(&compiler_t, next)
                foreach i in incs do includes += Include(i).to_cpp()
            ;
            Token::Use =>
                incs = imports_creation(&compiler_t, next)
                foreach i in incs do includes += Uses(i).to_cpp()
            ;
            Token::Get =>
                incs = imports_creation(&compiler_t, next)
                foreach i in incs
                    let get_name = i + HA_SUFFIX
                    let get_file = resolve_get_path(paths.folder_path + get_name, get_name)
                    // Dedupe on the resolved path, so a/util and b/util are different files
                    // while ../lib/print and print (from the lib folder) are the same one
                    let canonical = canonical_path(get_file)
                    if compiler_t.has_get(canonical)
                        hint($"[Get]: Duplicate entry of: {i}")
                        continue
                    ;
                    compiler_t.add_get(canonical)
                    FpFn fpfn = folder_and_name(get_file)
                    let get_path = CompilerPath(get_file, fpfn.f_p, fpfn.f_n)
                    let get_out = compile(get_path, p, false)
                    output += get_out.output
                    header_output += get_out.header_output
                    foreach u in get_out.units do units.push_back(u)
                    includes += get_out.includes
                    headers += get_out.headers
                    fnheaders += get_out.fnheaders
                    compiler_t.add_args(get_out.arguments)
                ;
            ;
            Token::Compiler =>
                // compiler => "-lfoo"                  always
                // compiler windows, macos => "-lbar"   only when compiling on those platforms
                vector<string> platforms = {}
                loop
                    let platform = next_or_exit(&compiler_t, $"[Compiler] Missing start of compiler intent [=>]: {next.name}")
                    if platform.token == Token::CoolArrow do break
                    if platform.token == Token::Comma do continue
                    if platform.token != Token::Id || none(platform.name, {"linux", "macos", "windows"})
                        error($"[Compiler] Expected linux, macos, windows or => but got: {platform.name}", compiler_t.recap())
                    ;
                    platforms.push_back(platform.name)
                ;
                args = get_or_exit(&compiler_t, Token::String, $"[Compiler] Missing value of compiler intent [TString]: {next.name}")
                if platforms.size() == 0 || any(platform_name(), platforms) do compiler_t.add_arg(args)
            ;
            Token::Raw =>
                // Top-level raw lines go with the includes so they can pick headers per platform (#ifdef)
                includes += next.name
            ;
            _ => do error($"Token not handled: {next.name}", compiler_t.recap())
        ;
    ;
    if is_named
        output += "\n}\n"
        headers += "\n}\n"
        fnheaders += "\n}\n"
        header_output += "\n}\n"
        unit_output += "\n}\n"
    ;
    if unit_has_code do units.push_back(Unit(unit_name(paths.current), unit_output))
    validate_compiled(compiler_t, is_main)
    let result = CompileOutput(output, includes, headers, fnheaders, compiler_t.arguments)
    result.header_output = header_output
    result.units = units
    return result
;

fn validate_compiled Compiler compiler, bool is_main =>
    let has_main = false
    foreach f in compiler.program->functions
        if f.id == "main" dobr has_main = true
    ;
    if !has_main && is_main do hint("Main function is not present!")
    if has_main && !is_main do hint("Main function not in main file")
;
