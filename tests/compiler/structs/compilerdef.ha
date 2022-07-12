struct Compiler
    Program program = Program()
    ClassPeekable<AstToken> ast
    vector<string> arguments = {}
    Compiler Program p, Peekable<AstToken> ast =>
        program = p
        ast = ast
    ;
    fn next => ClassOption<AstToken> doremi ast.next()
    fn peek => ClassOption<AstToken> doremi ast.peek()
    fn add_fn Function function => void do program.functions.push_back(function)
    fn add_class Class class_obj => void do program.classes.push_back(class_obj)
    fn add_enum Enum enum_def => void do program.enums.push_back(enum_def)
    fn add_inc vector<string> includes =>
        for i until includes.size() do program.includes.push_back(Include(includes.at(i)))
    ;
    fn add_use vector<string> usings =>
        for i until usings.size() do program.usings.push_back(Uses(usings.at(i)))
    ;
    fn add_arg string arg => void do arguments.push_back(replace_string(arg, QUOTE, EMPTY))
    fn add_args vector<string> args =>
        for i until args.size() do arguments.push_back(args.at(i))
    ;
    
;
