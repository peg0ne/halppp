inc => string
get => ../lib/[peekable, print, stringextensions, conditional, clap, list, files]
get => consts/[strings, tokens, errors]
get => enums/[token, variablestate]
get => structs/[asttoken, pathdef]
get => structs/[variabledef, enumdef]
get => structs/[importsdef, globaldef, structdef]
get => structs/[fordef, conditiondef, selectdef, expressiondef]
get => structs/[functiondef, classdef]
get => structs/[programdef, compilerdef]
get => message, utils, fileutil
get => ast, imports, enums, foreacher, expressions
get => switch, selects, conditions, variable, template
get => functions, classes, globals
compiler => "-O3"

struct CompileOutput
    string output = EMPTY
    string includes = EMPTY
    string headers = EMPTY
    string fnheaders = EMPTY
    vector<string> arguments = {}
    fn content => string doremi includes + headers + fnheaders + output
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
    FpFn fpfn = get_folder_and_name(get_file_path(argc, argv))
    let paths = CompilerPath(get_file_path(argc, argv), fpfn.f_p, fpfn.f_n)
    let p = Program()
    let output = compile_main(paths, &p)
    write_program(output.content(), paths)
    if !clap.has("-t") do compile_program(paths, output.arguments, clap.has("-r"))
;

fn compile_main CompilerPath paths, Program *p => CompileOutput doremi compile(paths, p, true)
fn compile CompilerPath paths, Program *p, bool is_main => CompileOutput
    println("compiling: " + paths.current)
    string output = EMPTY
    string includes = EMPTY
    string headers = EMPTY
    string fnheaders = EMPTY
    string cached_content = EMPTY
    string cached_output = EMPTY
    string cached_includes = EMPTY
    string cached_headers = EMPTY
    string cached_fnheaders = EMPTY
    vector<string> cached_args = {}
    vector<string> cached_gets = {}
    let is_named = false
    let content = get_content(paths, !is_main)
    if !is_main
        select cached_data from read("./.cache/content_" + paths.file_name)
            if String(content).strip() == String(cached_data).strip()
                println("Can get from cache")
                let c_get = read("./.cache/gets_" + paths.file_name).value_or("")
                cached_gets = String(c_get).split('\n')
                foreach g in cached_gets
                    if String(g).strip() == "" do continue
                    FpFn fpfn = get_folder_and_name(paths.folder_path + g + HA_SUFFIX)
                    let get_path = CompilerPath(paths.folder_path + g + HA_SUFFIX, fpfn.f_p, fpfn.f_n)
                    let get_out = compile(get_path, p, false)
                    output += get_out.output
                    includes += get_out.includes
                    headers += get_out.headers
                    fnheaders += get_out.fnheaders
                    foreach a in get_out.arguments
                        if String(a).strip() == "" do continue
                        cached_args.push_back(a)
                    ;
                ;
                output += read("./.cache/output_" + paths.file_name).value_or("")
                includes += read("./.cache/includes_" + paths.file_name).value_or("")
                headers += read("./.cache/headers_" + paths.file_name).value_or("")
                fnheaders += read("./.cache/fnheaders_" + paths.file_name).value_or("")
                let c_args = read("./.cache/args_" + paths.file_name).value_or("")
                let c_args_vec = String(c_args).split('\n')
                foreach a in c_args_vec
                    if String(a).strip() == "" do continue
                    cached_args.push_back(a)
                ;
                return CompileOutput(output, includes, headers, fnheaders, cached_args)
            ;
        ;
    ;
    cached_content = content
    let extralines = 0
    if is_main
        extralines = 5
        string extras = "\nfn to_string string value => string doremi value\n" 
        extras += "\ninc => string\nuse => std\n"
        content = extras + content
    ;
    let ast = ast_create(content)
    let compiler_t = Compiler(p, ast, extralines)
    vector<string> incs = {}
    string args = EMPTY
    loop
        let next = get_next_or_exit(&compiler_t, "Compiler failed to do unexpected EOF")
        if !next.is_base()
            display_err_message("Token not allowed in base: " + to_string(next.token), compiler_t.to_err_message())
        ;
        if next.is_terminator() do break
        elif next.is_nl() do continue
        elif next.is_classy()
            let classdef = class_construct(&compiler_t, next.token == Token::Struct, paths)
            output += classdef.to_cpp()
            headers += classdef.to_cpp_h()
            cached_output += classdef.to_cpp()
            cached_headers += classdef.to_cpp_h()
        ;
        elif next.token == Token::Named
            if is_named do display_err_message("[Named] cannot have nested namespaces", compiler_t.to_err_message())
            is_named = true
            get_arrow_or_exit(&compiler_t, "[Named] missing => in declaration");
            let id = get_id_or_exit(&compiler_t, "[Named] cannot create namespace without Id");
             output += "namespace " + id + "\n{\n"
            cached_output += "namespace " + id + "\n{\n"
        ;
        elif next.token == Token::Function
            let fndef = function_construct(&compiler_t, VariableState::Public, false)
            output += fndef.to_cpp(false)
            fnheaders += fndef.to_cpp_h()
            cached_output += fndef.to_cpp(false)
            cached_fnheaders += fndef.to_cpp_h()
        ;
        elif next.token == Token::Enum
            let enumdef = enums_construct(&compiler_t)
            output += enumdef.to_cpp()
            headers += enumdef.to_cpp_h()
            cached_output += enumdef.to_cpp()
            cached_headers += enumdef.to_cpp_h()
        ;
        elif next.token == Token::Global
            let global = global_construct(&compiler_t)
            headers += global.to_cpp()
            cached_headers += global.to_cpp()
        ;
        elif next.token == Token::Include
            incs = imports_creation(&compiler_t, next)
            foreach i in incs
                includes += Include(i).to_cpp()
                cached_includes += Include(i).to_cpp()
            ;
        ;
        elif next.token == Token::Use
            incs = imports_creation(&compiler_t, next)
            foreach i in incs
                includes += Uses(i).to_cpp()
                cached_includes += Uses(i).to_cpp()
            ;
        ;
        elif next.token == Token::Get
            incs = imports_creation(&compiler_t, next)
            foreach i in incs
                FpFn fpfn = get_folder_and_name(paths.folder_path + i + HA_SUFFIX)
                let get_path = CompilerPath(paths.folder_path + i + HA_SUFFIX, fpfn.f_p, fpfn.f_n)
                let get_out = compile(get_path, p, false)
                output += get_out.output
                includes += get_out.includes
                headers += get_out.headers
                fnheaders += get_out.fnheaders
                compiler_t.add_args(get_out.arguments)
                cached_gets.push_back(i)
            ;
        ;
        elif next.token == Token::Compiler
            get_arrow_or_exit(&compiler_t, "[Compiler] Missing start of compiler intent [=>]: " + next.name)
            args = get_or_exit(&compiler_t, Token::String, "[Compiler] Missing value of compiler intent [TString]: " + next.name)
            compiler_t.add_arg(args)
            cached_args.push_back(args)
        ;
        else do display_err_message("Token not handled: " + next.name, compiler_t.to_err_message())
    ;
    if is_named
        output += "\n}\n"
        cached_output += "\n}\n"
    ;
    validate_compiled(compiler_t, is_main)
    let cached = CompileOutput(cached_output, cached_includes, cached_headers, cached_fnheaders, cached_args)
    makedir("./.cache")
    write(cached_content, "./.cache/content_" + paths.file_name)
    write(cached_output, "./.cache/output_" + paths.file_name)
    write(cached_includes, "./.cache/includes_" + paths.file_name)
    write(cached_headers, "./.cache/headers_" + paths.file_name)
    write(cached_fnheaders, "./.cache/fnheaders_" + paths.file_name)
    string cached_args_str = EMPTY
    foreach arg in cached_args do cached_args_str += arg + "\n"
    write(cached_args_str, "./.cache/args_" + paths.file_name)
    string cached_gets_str = EMPTY
    foreach g in cached_gets do cached_gets_str += g + "\n"
    write(cached_gets_str, "./.cache/gets_" + paths.file_name)
    return CompileOutput(output, includes, headers, fnheaders, compiler_t.arguments)
;

fn validate_compiled Compiler compiler, bool is_main =>
    let has_main = false
    foreach f in compiler.program->functions
        if f.id == "main" dobr has_main = true
    ;
    if !has_main && is_main do display_hint_message("Main function is not present!")
    if has_main && !is_main do display_hint_message("Main function not in main file")
;