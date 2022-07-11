enum Token =>
    AllEquals,
    AllLessOrEquals,
    AllLessThan,
    AllMoreOrEquals,
    AllMoreThan,
    AllNotEquals,
    And,
    AnyEquals,
    Asterix,
    Bang,
    Class,
    Colon,
    Comma,
    Comment,
    Compiler,
    Condition,
    CoolArrow,
    DblLessThan,
    DblMoreThan,
    Do,
    Dobr,
    Doco,
    Dore,
    Doremi,
    Eof,
    Equality,
    Equals,
    Extend,
    False,
    For,
    ForwardSlash,
    Function,
    Get,
    Global,
    Id,
    Include,
    LBrack,
    LessThan,
    LessThanOrEquals,
    Let,
    LParen,
    MacroDefinition,
    MoreThan,
    MoreThanOrEquals,
    NewLine,
    NonEquality,
    Number,
    Or,
    Private,
    Protected,
    Public,
    RBrack,
    Return,
    RParen,
    SemiColon,
    Struct,
    Sub,
    Sum,
    True,
    Type,
    Until,
    Use,
    Enum,
;

struct Token_t
    Token t = Id
    Token_t string s =>
        if s == "-" dore t = Sub
        elif s == "," dore t = Comma
        elif s == ":" dore t = Colon
        elif s == ";" dore t = SemiColon
        elif s == "!=" dore t = NonEquality
        elif s == "(" dore t = LParen
        elif s == "!" dore t = Bang
        elif s == ")" dore t = RParen
        elif s == "[" dore t = LBrack
        elif s == "]" dore t = RBrack
        elif s == "*" dore t = Asterix
        elif s == "/" dore t = ForwardSlash
        elif s == "//" dore t = Comment
        elif s == "\n" dore t = NewLine
        elif s == "&&" dore t = And
        elif s == "+" dore t = Sum
        elif s == "<" dore t = LessThan
        elif s == "<<" dore t = DblLessThan
        elif s == "<<<" dore t = AllLessThan
        elif s == "<=" dore t = LessThanOrEquals
        elif s == "=!=" dore t = AllNotEquals
        elif s == "=" dore t = Equals
        elif s == "=&=" dore t = AllEquals
        elif s == "=<=" dore t = AllLessOrEquals
        elif s == "==" dore t = Equality
        elif s == "=>" dore t = CoolArrow
        elif s == "=>=" dore t = AllMoreOrEquals
        elif s == "=|=" dore t = AnyEquals
        elif s == ">" dore t = MoreThan
        elif s == ">=" dore t = MoreThanOrEquals
        elif s == ">>" dore t = DblMoreThan
        elif s == ">>>" dore t = AllMoreThan
        elif s == "||" dore t = Or
        elif s == "0" dore t = Number
        elif s == "1" dore t = Number
        elif s == "2" dore t = Number
        elif s == "3" dore t = Number
        elif s == "4" dore t = Number
        elif s == "5" dore t = Number
        elif s == "6" dore t = Number
        elif s == "7" dore t = Number
        elif s == "8" dore t = Number
        elif s == "9" dore t = Number
        elif s == "char" dore t = Type
        elif s == "class" dore t = Class
        elif s == "compiler" dore t = Compiler
        elif s == "def" dore t = MacroDefinition
        elif s == "do" dore t = Do
        elif s == "dobr" dore t = Dobr
        elif s == "doco" dore t = Doco
        elif s == "dore" dore t = Dore
        elif s == "doremi" dore t = Doremi
        elif s == "enum" dore t = Enum
        elif s == "elif" dore t = Condition
        elif s == "else" dore t = Condition
        elif s == "extend" dore t = Extend
        elif s == "false" dore t = False
        elif s == "fn" dore t = Function
        elif s == "for" dore t = For
        elif s == "foreach" dore t = For
        elif s == "get" dore t = Get
        elif s == "glob" dore t = Global
        elif s == "if" dore t = Condition
        elif s == "inc" dore t = Include
        elif s == "int" dore t = Type
        elif s == "let" dore t = Let
        elif s == "private" dore t = Private
        elif s == "protected" dore t = Protected
        elif s == "pub" dore t = Public
        elif s == "return" dore t = Return
        elif s == "str" dore t = Type
        elif s == "string" dore t = Type
        elif s == "struct" dore t = Struct
        elif s == "switch" dore t = Condition
        elif s == "true" dore t = True
        elif s == "until" dore t = Until
        elif s == "use" dore t = Use
        elif s == "while" dore t = Condition
        t = Id
    ;
    fn is_base => bool
        switch t
            case Class: doremi true
            case Eof: doremi true
            case Function: doremi true
            case Get: doremi true
            case Global: doremi true
            case Include: doremi true
            case MacroDefinition: doremi true
            case NewLine: doremi true
            case SemiColon: doremi true
            case Struct: doremi true
            case Use: doremi true
            case Compiler: doremi true
            case Enum: doremi true
            default: doremi false
        ;
    ;
    fn is_do => bool
        switch t
            case Do: doremi true
            case Dobr: doremi true
            case Doco: doremi true
            case Dore: doremi true
            case Doremi: doremi true
            default: doremi false
        ;
    ;
    fn is_conditional => bool
        switch t
            case Equality: doremi true
            case NonEquality: doremi true
            case MoreThanOrEquals: doremi true
            case LessThanOrEquals: doremi true
            case LessThan: doremi true
            case MoreThan: doremi true
            case AnyEquals: doremi true
            case AllEquals: doremi true
            case AllNotEquals: doremi true
            case AllLessThan: doremi true
            case AllMoreThan: doremi true
            case AllLessOrEquals: doremi true
            case AllMoreOrEquals: doremi true
            default: doremi false
        ;
    ;
    fn is_conditional_sep => bool
        switch t
            case And: doremi true
            case Or: doremi true
            default: doremi false
        ;
    ;
;
