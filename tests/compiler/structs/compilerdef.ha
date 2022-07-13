struct Compiler
    Program program = Program()
    Peekable<AstToken> ast
    vector<string> arguments = {}
    Compiler Program p, Peekable<AstToken> ast =>
        this->program = p
        this->ast = ast
    ;
    fn size => int doremi ast.size()
    fn next => Option<AstToken>
        // println(ast.peek().value_or(AstToken()).name)
        return ast.next()
    ;
    fn peek => Option<AstToken> doremi ast.peek()
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
    fn contains_use string id => bool
        for i until program.usings.size()
            if program.usings.at(i).usings == id doremi true
        ;
        return false
    ;
    fn contains_function string id => bool
        for i until program.functions.size()
            if program.functions.at(i).id == id doremi true
        ;
        return false
    ;
    fn contains_class string id => bool
        for i until program.classes.size()
            if program.classes.at(i).id == id doremi true
        ;
        return false
    ;
    fn contains_inc string id => bool
        for i until program.includes.size()
            if program.includes.at(i).include == id doremi true
        ;
        return false
    ;
    fn contains_enum string id => bool
        for i until program.enums.size()
            if program.enums.at(i).name == id doremi true
        ;
        return false
    ;
;
