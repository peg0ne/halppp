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
        if s == TOKEN_SUB dore t = Sub
        elif s == TOKEN_COMMA dore t = Comma
        elif s == TOKEN_COLON dore t = Colon
        elif s == TOKEN_SEMICOLON dore t = SemiColon
        elif s == TOKEN_NONEQUALITY dore t = NonEquality
        elif s == TOKEN_LPAREN dore t = LParen
        elif s == TOKEN_BANG dore t = Bang
        elif s == TOKEN_RPAREN dore t = RParen
        elif s == TOKEN_LBRACK dore t = LBrack
        elif s == TOKEN_RBRACK dore t = RBrack
        elif s == TOKEN_ASTERIX dore t = Asterix
        elif s == TOKEN_FORWARDSLASH dore t = ForwardSlash
        elif s == TOKEN_LINE_COMMENT dore t = Comment
        elif s == TOKEN_NEWLINE dore t = NewLine
        elif s == TOKEN_AND dore t = And
        elif s == TOKEN_SUM dore t = Sum
        elif s == TOKEN_LESSTHAN dore t = LessThan
        elif s == TOKEN_DBLLESSTHAN dore t = DblLessThan
        elif s == TOKEN_ALLLESSTHAN dore t = AllLessThan
        elif s == TOKEN_LESSTHANOREQUALS dore t = LessThanOrEquals
        elif s == TOKEN_ALLNOTEQUALS dore t = AllNotEquals
        elif s == TOKEN_EQUALS dore t = Equals
        elif s == TOKEN_ALLEQUALS dore t = AllEquals
        elif s == TOKEN_ALLLESSOREQUALS dore t = AllLessOrEquals
        elif s == TOKEN_EQUALITY dore t = Equality
        elif s == TOKEN_COOLARROW dore t = CoolArrow
        elif s == TOKEN_ALLMOREOREQUALS dore t = AllMoreOrEquals
        elif s == TOKEN_ANYEQUALS dore t = AnyEquals
        elif s == TOKEN_MORETHAN dore t = MoreThan
        elif s == TOKEN_MORETHANOREQUALS dore t = MoreThanOrEquals
        elif s == TOKEN_DBLMORETHAN dore t = DblMoreThan
        elif s == TOKEN_ALLMORETHAN dore t = AllMoreThan
        elif s == TOKEN_OR dore t = Or
        elif s == TOKEN_ZERO dore t = Number
        elif s == TOKEN_ONE dore t = Number
        elif s == TOKEN_TWO dore t = Number
        elif s == TOKEN_THREE dore t = Number
        elif s == TOKEN_FOUR dore t = Number
        elif s == TOKEN_FIVE dore t = Number
        elif s == TOKEN_SIX dore t = Number
        elif s == TOKEN_SEVEN dore t = Number
        elif s == TOKEN_EIGHT dore t = Number
        elif s == TOKEN_NINE dore t = Number
        elif s == TOKEN_TYPE dore t = Type
        elif s == TOKEN_CLASS dore t = Class
        elif s == TOKEN_COMPILER dore t = Compiler
        elif s == TOKEN_MACRODEFINITION dore t = MacroDefinition
        elif s == TOKEN_DO dore t = Do
        elif s == TOKEN_DOBR dore t = Dobr
        elif s == TOKEN_DOCO dore t = Doco
        elif s == TOKEN_DORE dore t = Dore
        elif s == TOKEN_DOREMI dore t = Doremi
        elif s == TOKEN_ENUM dore t = Enum
        elif s == TOKEN_ELIF dore t = Condition
        elif s == TOKEN_ELSE dore t = Condition
        elif s == TOKEN_EXTEND dore t = Extend
        elif s == TOKEN_FALSE dore t = False
        elif s == TOKEN_FUNCTION dore t = Function
        elif s == TOKEN_FOR dore t = For
        elif s == TOKEN_FOREACH dore t = For
        elif s == TOKEN_GET dore t = Get
        elif s == TOKEN_GLOBAL dore t = Global
        elif s == TOKEN_IFS dore t = Condition
        elif s == TOKEN_INCLUDE dore t = Include
        elif s == TOKEN_INT dore t = Type
        elif s == TOKEN_LET dore t = Let
        elif s == TOKEN_PRIVATE dore t = Private
        elif s == TOKEN_PROTECTED dore t = Protected
        elif s == TOKEN_PUBLIC dore t = Public
        elif s == TOKEN_RETURN dore t = Return
        elif s == TOKEN_STR dore t = Type
        elif s == TOKEN_STRING dore t = Type
        elif s == TOKEN_STRUCT dore t = Struct
        elif s == TOKEN_SWITCH dore t = Condition
        elif s == TOKEN_TRUE dore t = True
        elif s == TOKEN_UNTIL dore t = Until
        elif s == TOKEN_USE dore t = Use
        elif s == TOKEN_WHILE dore t = Condition
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
