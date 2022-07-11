struct CompileOutput
    string output = EMPTY
    vector<string> arguments = {}
    CompileOutput string output, vector<string> arguments =>
        output = output
        arguments = arguments
    ;
;

fn main =>
    let should_remove_cpp = false
    let paths = CompilerPath(get_file_path())
    let p = Program()
    let (output, arguments) = compile_main(paths, p)
    write_program(output, paths)
    compile_program(paths, arguments, should_remove_cpp)
;

fn compile_main CompilerPath paths, Program p => CompileOutput doremi compile(paths, p, true)
fn compile CompilerPath paths, Program p, bool is_main => CompileOutput
    println("compiling: " + paths.current)
    let content = get_content(paths)
    let ast = ast::create(&content)
    let output = EMPTY
    let compiler = Compiler(p, ast)
    let can_continue = true
    while can_continue
        let next = get_next_or_exit(compiler.next(), "Compiler failed to do unexpected EOF")
        if !next.token.is_base()
            display_err_message("Token not allowed in base: " + next.name + ", Type: " + next.token)
        ;
        switch next.token
            case Struct:
                let class = class::construct(compiler, true)
                dobr output += class.to_cpp()
            case Class:
                let class = class::construct(compiler, false)
                dobr output += class.to_cpp()
            case Function:
                let function = function::construct(compiler, Public, false)
                dobr output += function.to_cpp(false)
            case Enum:
                let enum_def = enumerator::construct(compiler)
                dobr output += enum_def.to_cpp()
            case Include:
                let incs = imports::imports_creation(compiler, next)
                for i until incs.size() do output += Include(incs.at(i)).to_cpp()
                break
            case Use:
                let uses = imports::imports_creation(compiler, next)
                for i until uses.size() do output += Use(uses.at(i)).to_cpp()
                break
            case Get:
                let gets = imports::imports_creation(compiler, next)
                for i until gets.size()
                    let get_path = CompilerPath(paths.folder_path + gets.at(i) + HA_SUFFIX)
                    let get_out = compile(get_path, compiler.program, false)
                    output += get_out.output
                    compiler.add_args(get_out.arguments)
                ;
                break
            case Compiler:
                get_arrow_or_exit(compiler.next(), "[Compiler] Missing start of compiler intent [=>]: " + next.token)
                let arg = get_id_or_exit(compiler.next(), "[Compiler] Missing value of compiler intent [Token::Id]: " + next.token)
                dobr compiler.add_arg(arg)
            case NewLine: do break
            case Eof: dobr can_continue = false
            default: dobr display_err_message("Token not handled: " + next.token)
        ;
    ;
    validate_compiled(compiler, is_main)
    CompileOutput(output, compiler.arguments)
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
