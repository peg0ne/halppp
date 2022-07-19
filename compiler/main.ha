inc => string
get => ../lib/[peekable, print, stringextensions, conditional, clap]
get => consts/[strings, tokens, errors]
get => enums/[token, variablestate]
get => structs/[asttoken, pathdef]
get => message, utils, fileutil
get => structs/[variabledef, enumdef]
get => structs/[importsdef, globaldef, structdef]
get => structs/[fordef, conditiondef, expressiondef]
get => structs/[functiondef, classdef]
get => structs/[programdef, compilerdef]
get => ast, imports, enums, foreacher, expressions
get => switch, conditions, variable, template
get => functions, classes, globals

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
    if !clap.has("-t") do compile_program(paths, output.arguments)
;

fn compile_main CompilerPath paths, Program *p => CompileOutput doremi compile(paths, p, true)
fn compile CompilerPath paths, Program *p, bool is_main => CompileOutput
    println("compiling: " + paths.current)
    string output = EMPTY
    string includes = EMPTY
    string headers = EMPTY
    string fnheaders = EMPTY
    let is_named = false
    let content = get_content(paths)
    let ast = ast_create(content)
    let compiler_t = Compiler(p, ast)
    vector<string> incs = {}
    string args = EMPTY
    loop
        let next = get_next_or_exit(compiler_t.next(), "Compiler failed to do unexpected EOF")
        if !next.is_base()
            display_err_message("Token not allowed in base: " + to_string(next.token))
        ;
        if next.is_terminator() do break
        elif next.is_nl() do continue
        elif next.is_classy()
            let classdef = class_construct(&compiler_t, next.token == Token::Struct)
            output += classdef.to_cpp()
            headers += classdef.to_cpp_h()
        ;
        elif next.token == Token::Named
            if is_named do display_err_message("[Named] cannot have nested namespaces")
            is_named = true
            get_arrow_or_exit(compiler_t.next(), "[Named] missing => in declaration");
            let id = get_id_or_exit(compiler_t.next(), "[Named] cannot create namespace without Id");
            output += "namespace " + id + "\n{\n"
        ;
        elif next.token == Token::Function
            let fndef = function_construct(&compiler_t, VariableState::Public, false)
            output += fndef.to_cpp(false)
            fnheaders += fndef.to_cpp_h()
        ;
        elif next.token == Token::Enum
            let enumdef = enums_construct(&compiler_t)
            output += enumdef.to_cpp()
            headers += enumdef.to_cpp_h()
        ;
        elif next.token == Token::Global
            let global = global_construct(&compiler_t)
            headers += global.to_cpp()
        ;
        elif next.token == Token::Include
            incs = imports_creation(&compiler_t, next)
            foreach i in incs do includes += Include(i).to_cpp()
        ;
        elif next.token == Token::Use
            incs = imports_creation(&compiler_t, next)
            foreach i in incs do includes += Uses(i).to_cpp()
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
            ;
        ;
        elif next.token == Token::Compiler
            get_arrow_or_exit(compiler_t.next(), "[Compiler] Missing start of compiler intent [=>]: " + next.name)
            args = get_or_exit(compiler_t.next(), Token::String, "[Compiler] Missing value of compiler intent [TString]: " + next.name)
            compiler_t.add_arg(args)
        ;
        else do display_err_message("Token not handled: " + next.name)
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
    if !has_main && is_main do display_hint_message("Main function is not present!")
    if has_main && !is_main do display_hint_message("Main function not in main file")
;


