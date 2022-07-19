struct Compiler
    Program *program
    Peekable<AstToken> ast
    vector<string> arguments = {}
    Compiler Program *p, Peekable<AstToken> ast =>
        this->program = p
        this->ast = ast
    ;
    fn size => int doremi ast.size()
    fn next => Option<AstToken> doremi ast.next()
    // fn next => Option<AstToken>
    //     println(ast.peek().value_or(AstToken()).to_string())
    //     return ast.next()
    // ;
    fn peek => Option<AstToken> doremi ast.peek()
    fn prev => Option<AstToken> doremi ast.prev()
    fn add_fn Function function => do program->functions.push_back(function)
    fn add_class Class class_obj => do program->classes.push_back(class_obj)
    fn add_enum Enum enum_def => do program->enums.push_back(enum_def)
    fn add_glob Global global => do program->global.push_back(global)
    fn add_inc vector<string> includes =>
        for i until includes.size() do program->includes.push_back(Include(includes.at(i)))
    ;
    fn add_use vector<string> usings =>
        for i until usings.size() do program->usings.push_back(Uses(usings.at(i)))
    ;
    fn add_get vector<string> gets =>
        for i until gets.size()
            let getter = gets.at(i)
            while getter.find("/") != -1 do getter = getter.substr(1)
            program->gets.push_back(getter)
        ;
    ;
    fn add_arg string arg => do arguments.push_back(String(arg).replace(QUOTE, EMPTY))
    fn add_args vector<string> args =>
        for i until args.size() do arguments.push_back(args.at(i))
    ;
    fn has_use string id => bool
        for i until program->usings.size()
            if program->usings.at(i).usings == id doremi true
        ;
        return false
    ;
    fn has_function string id => bool
        for i until program->functions.size()
            if program->functions.at(i).id == id doremi true
        ;
        return false
    ;
    fn has_class string id => bool
        for i until program->classes.size()
            if program->classes.at(i).id == id doremi true
        ;
        return false
    ;
    fn has_inc string id => bool
        for i until program->includes.size()
            if program->includes.at(i).include == id doremi true
        ;
        return false
    ;
    fn has_get string id => bool
        let getter = id
        while getter.find("/") != -1 do getter = getter.substr(1)
        for i until program->gets.size()
            if program->gets.at(i) == getter doremi true
        ;
        return false
    ;
    fn has_enum string id => bool
        for i until program->enums.size()
            if program->enums.at(i).name == id doremi true
        ;
        return false
    ;
    fn has_glob string id => bool
        for i until program->global.size()
            let g = program->global.at(i)
            for j until g.variables.size()
                if g.variables.at(j).v_type == id doremi true
            ;
        ;
        return false
    ;
    fn has_enum_name string id => bool
        for i until program->enums.size()
            let e = program->enums.at(i)
            for j until e.enums.size()
                if e.enums.at(j).name == id doremi true
            ;
        ;
        return false
    ;
;
