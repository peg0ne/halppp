inc => string
get => ../../lib/peekable, ../../lib/print, ../../lib/stringextensions, ../../lib/conditional
inc => "cpp/strings.h", "cpp/tokens.h"
get => enums/token, enums/variablestate
get => structs/asttoken, structs/pathdef
get => message, utils, fileutil
get => structs/variabledef, structs/enumdef
get => structs/importsdef, structs/globaldef, structs/structdef
get => structs/fordef, structs/conditiondef, structs/expressiondef
get => structs/functiondef, structs/classdef
get => structs/programdef, structs/compilerdef
get => ast, imports, enums, foreacher, expressions, conditions, variable, template, functions, classdef

struct CompileOutput
    string output = EMPTY
    vector<string> arguments = {}
    CompileOutput string output, vector<string> arguments =>
        this->output = output
        this->arguments = arguments
    ;
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

fn compile CompilerPath paths, Program p, bool is_main => CompileOutput
    println("compiling: " + paths.current)
    string output = EMPTY
    let content = get_content(paths)
    let ast = ast_create(content)
    let compiler_t = Compiler(p, ast)
    let can_continue = true
    let a = 0
    let class_def = Class()
    let function = Function(Private_State)
    let enum_def = Enum("NONE")
    vector<string> incs = {}
    string args = EMPTY
    while can_continue
        let next = get_next_or_exit(compiler_t.next(), "Compiler failed to do unexpected EOF")
        if !next.t.is_base()
            display_err_message("Token not allowed in base: " + next.name + ", Type: " + token_to_string(next.token))
        ;
        switch next.token
            case TStruct: do class_def = class_construct(&compiler_t, true)
                dobr output += class_def.to_cpp()
            case TClass: do class_def = class_construct(&compiler_t, false)
                dobr output += class_def.to_cpp()
            case TFunction: do function = function_construct(&compiler_t, Public_State, false)
                dobr output += function.to_cpp(false)
            case TEnum: do enum_def = enums_construct(&compiler_t)
                dobr output += enum_def.to_cpp()
            case TInclude: do incs = imports_creation(&compiler_t, next)
                for i until incs.size() do output += Include(incs.at(i)).to_cpp()
                break
            case TUse: do incs = imports_creation(&compiler_t, next)
                for i until incs.size() do output += Uses(incs.at(i)).to_cpp()
                break
            case TGet: do incs = imports_creation(&compiler_t, next)
                for i until incs.size()
                    FpFn fpfn = get_folder_and_name(paths.folder_path + incs.at(i) + HA_SUFFIX)
                    let get_path = CompilerPath(paths.folder_path + incs.at(i) + HA_SUFFIX, fpfn.f_p, fpfn.f_n)
                    let get_out = compile(get_path, compiler_t.program, false)
                    output += get_out.output
                    compiler_t.add_args(get_out.arguments)
                ;
                break
            case TCompiler: do a = 0
                get_arrow_or_exit(compiler_t.next(), "[Compiler] Missing start of compiler intent [=>]: " + next.name)
                args = get_id_or_exit(compiler_t.next(), "[Compiler] Missing value of compiler intent [Token::Id]: " + next.name)
                dobr compiler_t.add_arg(args)
            case TNewLine: do break
            case TEof: dobr can_continue = false
            default: dobr display_err_message("Token not handled: " + next.name)
        ;
    ;
    validate_compiled(compiler_t, is_main)
    return CompileOutput(output, compiler_t.arguments)
;
fn compile_main CompilerPath paths, Program p => CompileOutput doremi compile(paths, p, true)

fn main =>
    let should_remove_cpp = false
    FpFn fpfn = get_folder_and_name(get_file_path(argc, argv))
    let paths = CompilerPath(get_file_path(argc, argv), fpfn.f_p, fpfn.f_n)
    let p = Program()
    let output = compile_main(paths, p)
    write_program(output.output, paths)
    compile_program(paths, output.arguments, should_remove_cpp)
;