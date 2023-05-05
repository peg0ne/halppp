struct Compiler
    Program *program
    Peekable<AstToken> ast
    vector<string> arguments = {}
    List<string> current_text = List<string>({"\033[0m>>"})
    int current_line = 0
    Compiler Program *p, Peekable<AstToken> ast, int extra_lines =>
        this->program = p
        this->ast = ast
        this->current_line -= extra_lines
    ;
    fn to_err_message => string
        let current = current_line - 2
        while current_text.len() < 7
            select n from next(true) do continue
            break
        ;
        let s = "\n"
        foreach line in current_text
            let nr = to_string(current)
            s += $"{nr} {line}\n"
            current++
        ;
        return s
    ;
    fn size => int doremi ast.size()
    fn next => Option<AstToken> doremi next(false)
    fn next bool is_err => Option<AstToken>
        //println(ast.peek().value_or(AstToken()).to_string())
        let len = current_text.len()
        if len == 0 do current_text.add("\033[0m>> ")
        select peeked from ast.peek()
            if peeked.token == Token::NewLine
                if !is_err && len > 3 do current_text.remove(0)
                current_text.add("\033[0m>> ")
                current_line++
            ;
            else
                select last from current_text.last()
                    if !is_err
                        last += $"\033[034m{peeked.name}\033[0m "
                    ;
                    else
                        last += $"\033[031m{peeked.name}\033[0m "
                    ;
                    let vec = current_text.as_vec_ptr()
                    vec->at(len - 1) = last
                ;
            ;
        ;
        return ast.next()
    ;
    fn peek => Option<AstToken> doremi ast.peek()
    fn prev => Option<AstToken> doremi ast.prev()
    fn add_fn Function function => do program->functions.push_back(function)
    fn add_class Class class_obj => do program->classes.push_back(class_obj)
    fn add_enum Enum enum_def => do program->enums.push_back(enum_def)
    fn add_glob Global global => do program->global.push_back(global)
    fn add_inc vector<string> includes =>
        foreach i in includes do program->includes.push_back(Include(i))
    ;
    fn add_use vector<string> usings =>
        foreach i in usings do program->usings.push_back(Uses(i))
    ;
    fn add_get vector<string> gets =>
        foreach i in gets
            while i.find("/") != -1 do i = i.substr(1)
            program->gets.push_back(i)
        ;
    ;
    fn add_arg string arg => do arguments.push_back(String(arg).replace(QUOTE, EMPTY))
    fn add_args vector<string> args =>
        foreach i in args do arguments.push_back(i)
    ;
    fn has_use string id => bool
        foreach i in program->usings
            if i.usings == id doremi true
        ;
        return false
    ;
    fn has_function string id => bool
        foreach i in program->functions
            if i.id == id doremi true
        ;
        return false
    ;
    fn has_class string id => bool
        foreach i in program->classes
            if i.id == id doremi true
        ;
        return false
    ;
    fn has_inc string id => bool
        foreach i in program->includes
            if i.include == id doremi true
        ;
        return false
    ;
    fn has_get string id => bool
        let getter = id
        while getter.find("/") != -1 do getter = getter.substr(1)
        foreach i in program->gets
            if i == getter doremi true
        ;
        return false
    ;
    fn has_enum string id => bool
        foreach i in program->enums
            if i.name == id doremi true
        ;
        return false
    ;
    fn has_glob string id => bool
        foreach g in program->global
            foreach v in g.variables
                if v.v_type == id doremi true
            ;
        ;
        return false
    ;
    fn has_enum_name string id => bool
        foreach e in program->enums
            foreach j in e.enums
                if j.name == id doremi true
            ;
        ;
        return false
    ;
;