inc => string
get => ../../lib/[peekable, print, stringextensions, conditional]
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
get => functions, classdef, globals

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
    let should_remove_cpp = false
    FpFn fpfn = get_folder_and_name(get_file_path(argc, argv))
    let paths = CompilerPath(get_file_path(argc, argv), fpfn.f_p, fpfn.f_n)
    let p = Program()
    let output = compile_main(paths, p)
    write_program(output.content(), paths)
    compile_program(paths, output.arguments, should_remove_cpp)
;

fn compile_main CompilerPath paths, Program p => CompileOutput doremi compile(paths, p, true)
fn compile CompilerPath paths, Program p, bool is_main => CompileOutput
    println("compiling: " + paths.current)
    string output = EMPTY
    string includes = EMPTY
    string headers = EMPTY
    string fnheaders = EMPTY
    let content = get_content(paths)
    let ast = ast_create(content)
    let compiler_t = Compiler(p, ast)
    vector<string> incs = {}
    string args = EMPTY
    loop
        let next = get_next_or_exit(compiler_t.next(), "Compiler failed to do unexpected EOF")
        if !next.t.is_base()
            display_err_message("Token not allowed in base: " + token_to_string(next.token))
        ;
        if next.token == TEof do break
        elif next.token == TNewLine do continue
        elif any(next.token, {TStruct, TClass})
            let classdef = class_construct(&compiler_t, next.token == TStruct)
            output += classdef.to_cpp()
            headers += classdef.to_cpp_h()
        ;
        elif next.token == TFunction
            let fndef = function_construct(&compiler_t, Public_State, false)
            output += fndef.to_cpp(false)
            fnheaders += fndef.to_cpp_h()
        ;
        elif next.token == TEnum
            let enumdef = enums_construct(&compiler_t)
            output += enumdef.to_cpp()
            headers += enumdef.to_cpp_h()
        ;
        elif next.token == TGlobal
            let global = global_construct(&compiler_t)
            headers += global.to_cpp()
        ;
        elif next.token == TInclude
            incs = imports_creation(&compiler_t, next)
            for i until incs.size() do includes += Include(incs.at(i)).to_cpp()
        ;
        elif next.token == TUse
            incs = imports_creation(&compiler_t, next)
            for i until incs.size() do includes += Uses(incs.at(i)).to_cpp()
        ;
        elif next.token == TGet
            incs = imports_creation(&compiler_t, next)
            for i until incs.size()
                FpFn fpfn = get_folder_and_name(paths.folder_path + incs.at(i) + HA_SUFFIX)
                let get_path = CompilerPath(paths.folder_path + incs.at(i) + HA_SUFFIX, fpfn.f_p, fpfn.f_n)
                let get_out = compile(get_path, compiler_t.program, false)
                output += get_out.output
                includes += get_out.includes
                headers += get_out.headers
                fnheaders += get_out.fnheaders
                compiler_t.add_args(get_out.arguments)
            ;
        ;
        elif next.token == TCompiler
            get_arrow_or_exit(compiler_t.next(), "[Compiler] Missing start of compiler intent [=>]: " + next.name)
            args = get_or_exit(compiler_t.next(), TString, "[Compiler] Missing value of compiler intent [TString]: " + next.name)
            compiler_t.add_arg(args)
        ;
        else do display_err_message("Token not handled: " + next.name)
    ;
    validate_compiled(compiler_t, is_main)
    return CompileOutput(output, includes, headers, fnheaders, compiler_t.arguments)
;

fn validate_compiled Compiler compiler, bool is_main =>
    let has_main = false
    for i until compiler.program.functions.size()
        let f = compiler.program.functions.at(i)
        if f.id == "main" dobr has_main = true
    ;
    if !has_main && is_main do display_hint_message("Main function is not present!")
    if has_main && !is_main do display_hint_message("Main function not in main file")
;


