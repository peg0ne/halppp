enum Token =>
    TAllEquals,
    TAllLessOrEquals,
    TAllLessThan,
    TAllMoreOrEquals,
    TAllMoreThan,
    TAllNotEquals,
    TAnd,
    TAnyEquals,
    TAsterix,
    TBang,
    TClass,
    TColon,
    TComma,
    TComment,
    TCompiler,
    TCondition,
    TCoolArrow,
    TDblLessThan,
    TDblMoreThan,
    TDo,
    TDobr,
    TDoco,
    TDore,
    TDoremi,
    TEof,
    TEquality,
    TEquals,
    TExtend,
    TFalse,
    TFor,
    TForwardSlash,
    TFunction,
    TGet,
    TGlobal,
    TId,
    TInclude,
    TLBrack,
    TLessThan,
    TLessThanOrEquals,
    TLet,
    TLParen,
    TMacroDefinition,
    TMoreThan,
    TMoreThanOrEquals,
    TNewLine,
    TNonEquality,
    TNumber,
    TOr,
    TPrivate,
    TProtected,
    TPublic,
    TRBrack,
    TReturn,
    TRParen,
    TSemiColon,
    TStruct,
    TSub,
    TSum,
    TTrue,
    TType,
    TUntil,
    TUse,
    TEnum,
    UNKNOWN,
;

struct Token_t
    Token t = TId
    Token_t string s =>
        if s == TOKEN_SUB dore t = TSub
        elif s == TOKEN_COMMA dore t = TComma
        elif s == TOKEN_COLON dore t = TColon
        elif s == TOKEN_SEMICOLON dore t = TSemiColon
        elif s == TOKEN_NONEQUALITY dore t = TNonEquality
        elif s == TOKEN_LPAREN dore t = TLParen
        elif s == TOKEN_BANG dore t = TBang
        elif s == TOKEN_RPAREN dore t = TRParen
        elif s == TOKEN_LBRACK dore t = TLBrack
        elif s == TOKEN_RBRACK dore t = TRBrack
        elif s == TOKEN_ASTERIX dore t = TAsterix
        elif s == TOKEN_FORWARDSLASH dore t = TForwardSlash
        elif s == TOKEN_LINE_COMMENT dore t = TComment
        elif s == TOKEN_NEWLINE dore t = TNewLine
        elif s == TOKEN_AND dore t = TAnd
        elif s == TOKEN_SUM dore t = TSum
        elif s == TOKEN_LESSTHAN dore t = TLessThan
        elif s == TOKEN_DBLLESSTHAN dore t = TDblLessThan
        elif s == TOKEN_ALLLESSTHAN dore t = TAllLessThan
        elif s == TOKEN_LESSTHANOREQUALS dore t = TLessThanOrEquals
        elif s == TOKEN_ALLNOTEQUALS dore t = TAllNotEquals
        elif s == TOKEN_EQUALS dore t = TEquals
        elif s == TOKEN_ALLEQUALS dore t = TAllEquals
        elif s == TOKEN_ALLLESSOREQUALS dore t = TAllLessOrEquals
        elif s == TOKEN_EQUALITY dore t = TEquality
        elif s == TOKEN_COOLARROW dore t = TCoolArrow
        elif s == TOKEN_ALLMOREOREQUALS dore t = TAllMoreOrEquals
        elif s == TOKEN_ANYEQUALS dore t = TAnyEquals
        elif s == TOKEN_MORETHAN dore t = TMoreThan
        elif s == TOKEN_MORETHANOREQUALS dore t = TMoreThanOrEquals
        elif s == TOKEN_DBLMORETHAN dore t = TDblMoreThan
        elif s == TOKEN_ALLMORETHAN dore t = TAllMoreThan
        elif s == TOKEN_OR dore t = TOr
        elif s == TOKEN_ZERO dore t = TNumber
        elif s == TOKEN_ONE dore t = TNumber
        elif s == TOKEN_TWO dore t = TNumber
        elif s == TOKEN_THREE dore t = TNumber
        elif s == TOKEN_FOUR dore t = TNumber
        elif s == TOKEN_FIVE dore t = TNumber
        elif s == TOKEN_SIX dore t = TNumber
        elif s == TOKEN_SEVEN dore t = TNumber
        elif s == TOKEN_EIGHT dore t = TNumber
        elif s == TOKEN_NINE dore t = TNumber
        elif s == TOKEN_TYPE dore t = TType
        elif s == TOKEN_CLASS dore t = TClass
        elif s == TOKEN_COMPILER dore t = TCompiler
        elif s == TOKEN_MACRODEFINITION dore t = TMacroDefinition
        elif s == TOKEN_DO dore t = TDo
        elif s == TOKEN_DOBR dore t = TDobr
        elif s == TOKEN_DOCO dore t = TDoco
        elif s == TOKEN_DORE dore t = TDore
        elif s == TOKEN_DOREMI dore t = TDoremi
        elif s == TOKEN_ENUM dore t = TEnum
        elif s == TOKEN_ELIF dore t = TCondition
        elif s == TOKEN_ELSE dore t = TCondition
        elif s == TOKEN_EXTEND dore t = TExtend
        elif s == TOKEN_FALSE dore t = TFalse
        elif s == TOKEN_FUNCTION dore t = TFunction
        elif s == TOKEN_FOR dore t = TFor
        elif s == TOKEN_FOREACH dore t = TFor
        elif s == TOKEN_GET dore t = TGet
        elif s == TOKEN_GLOBAL dore t = TGlobal
        elif s == TOKEN_IFS dore t = TCondition
        elif s == TOKEN_INCLUDE dore t = TInclude
        elif s == TOKEN_INT dore t = TType
        elif s == TOKEN_LET dore t = TLet
        elif s == TOKEN_PRIVATE dore t = TPrivate
        elif s == TOKEN_PROTECTED dore t = TProtected
        elif s == TOKEN_PUBLIC dore t = TPublic
        elif s == TOKEN_RETURN dore t = TReturn
        elif s == TOKEN_STR dore t = TType
        elif s == TOKEN_STRING dore t = TType
        elif s == TOKEN_STRUCT dore t = TStruct
        elif s == TOKEN_SWITCH dore t = TCondition
        elif s == TOKEN_TRUE dore t = TTrue
        elif s == TOKEN_UNTIL dore t = TUntil
        elif s == TOKEN_USE dore t = TUse
        elif s == TOKEN_WHILE dore t = TCondition
        t = TId
    ;
    fn is_base => bool
        switch t
            case TClass: doremi true
            case TEof: doremi true
            case TFunction: doremi true
            case TGet: doremi true
            case TGlobal: doremi true
            case TInclude: doremi true
            case TMacroDefinition: doremi true
            case TNewLine: doremi true
            case TSemiColon: doremi true
            case TStruct: doremi true
            case TUse: doremi true
            case TCompiler: doremi true
            case TEnum: doremi true
            default: doremi false
        ;
    ;
    fn is_do => bool
        switch t
            case TDo: doremi true
            case TDobr: doremi true
            case TDoco: doremi true
            case TDore: doremi true
            case TDoremi: doremi true
            default: doremi false
        ;
    ;
    fn is_conditional => bool
        switch t
            case TEquality: doremi true
            case TNonEquality: doremi true
            case TMoreThanOrEquals: doremi true
            case TLessThanOrEquals: doremi true
            case TLessThan: doremi true
            case TMoreThan: doremi true
            case TAnyEquals: doremi true
            case TAllEquals: doremi true
            case TAllNotEquals: doremi true
            case TAllLessThan: doremi true
            case TAllMoreThan: doremi true
            case TAllLessOrEquals: doremi true
            case TAllMoreOrEquals: doremi true
            default: doremi false
        ;
    ;
    fn is_conditional_sep => bool
        switch t
            case TAnd: doremi true
            case TOr: doremi true
            default: doremi false
        ;
    ;
;
