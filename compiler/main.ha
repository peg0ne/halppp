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
get => message, utils, fileutil
get => ast, imports, enums, foreacher, expressions, matching
get => switch, selects, conditions, variable, template
get => functions, classes, globals
compiler => "-O3"

struct CompileOutput
    string output = ""
    string includes = ""
    string headers = ""
    string fnheaders = ""
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
    FpFn fpfn = folder_and_name(get_file_path(argc, argv))
    let paths = CompilerPath(get_file_path(argc, argv), fpfn.f_p, fpfn.f_n)
    let p = Program()
    let output = compile_main(paths, &p)
    write_program(output.content(), paths)
    if !clap.has("-t") do compile_program(paths, output.arguments, clap.has("-r"))
;

fn compile_main CompilerPath paths, Program *p => CompileOutput doremi compile(paths, p, true)
fn compile CompilerPath paths, Program *p, bool is_main => CompileOutput
    println("compiling: " + paths.current)
    let output = ""
    let includes = ""
    let headers = ""
    let fnheaders = ""
    let is_named = false
    let content = get_content(paths, !is_main)
    let extralines = 0
    if is_main
        extralines = 5
        let extras = "\nfn to_string string value => string doremi value\n" 
        extras += "\ninc => string\nuse => std\n"
        content = extras + content
    ;
    let ast = ast_create(content)
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
            continue
        ;
        match next.token
            Token::Named =>
                if is_named do error("[Named] cannot have nested namespaces", compiler_t.recap())
                is_named = true
                arrow_or_exit(&compiler_t, "[Named] missing => in declaration");
                let id = id_or_exit(&compiler_t, "[Named] cannot create namespace without Id");
                output += $"namespace {id}\n" + "{\n"
            ;
            Token::Function =>
                let fndef = function_construct(&compiler_t, VariableState::Public, false)
                output += fndef.to_cpp(false)
                fnheaders += fndef.to_cpp_h()
            ;
            Token::Enum =>
                let enumdef = enums_construct(&compiler_t)
                output += enumdef.to_cpp()
                headers += enumdef.to_cpp_h()
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
                    FpFn fpfn = folder_and_name(paths.folder_path + i + HA_SUFFIX)
                    let get_path = CompilerPath(paths.folder_path + i + HA_SUFFIX, fpfn.f_p, fpfn.f_n)
                    let get_out = compile(get_path, p, false)
                    output += get_out.output
                    includes += get_out.includes
                    headers += get_out.headers
                    fnheaders += get_out.fnheaders
                    compiler_t.add_args(get_out.arguments)
                ;
            ;
            Token::Compiler =>
                arrow_or_exit(&compiler_t, $"[Compiler] Missing start of compiler intent [=>]: {next.name}")
                args = get_or_exit(&compiler_t, Token::String, $"[Compiler] Missing value of compiler intent [TString]: {next.name}")
                compiler_t.add_arg(args)
            ;
            Token::Raw => do output += next.name
            _ => do error($"Token not handled: {next.name}", compiler_t.recap())
        ;
    ;
    if is_named do output += "\n}\n"
    validate_compiled(compiler_t, is_main)
    return CompileOutput(output, includes, headers, fnheaders, compiler_t.arguments)
;

fn validate_compiled Compiler compiler, bool is_main =>
    let has_main = false
    foreach f in compiler.program->functions
        if f.id == "main" dobr has_main = true
    ;
    if !has_main && is_main do hint("Main function is not present!")
    if has_main && !is_main do hint("Main function not in main file")
;
