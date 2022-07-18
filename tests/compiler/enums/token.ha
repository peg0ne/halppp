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
    TLBlock,
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
    TRBlock,
    TReturn,
    TRParen,
    TPointer,
    TSemiColon,
    TStruct,
    TSub,
    TSum,
    TTrue,
    TType,
    TUntil,
    TUse,
    TEnum,
    TString,
    TChar,
    TFloat,
    TDefault,
    TCase,
    TSwitch,
    UNKNOWN,
;

struct Token_t
    Token t = TId
    Token_t string s =>
        let S = String(s)
        if S.starts_with(QUOTE) dore t = TString
        elif S.starts_with("'") dore t = TChar
        elif s == TOKEN_ALLEQUALS dore t = TAllEquals
        elif s == TOKEN_ALLLESSOREQUALS dore t = TAllLessOrEquals
        elif s == TOKEN_ALLLESSTHAN dore t = TAllLessThan
        elif s == TOKEN_ALLMOREOREQUALS dore t = TAllMoreOrEquals
        elif s == TOKEN_ALLMORETHAN dore t = TAllMoreThan
        elif s == TOKEN_ALLNOTEQUALS dore t = TAllNotEquals
        elif s == TOKEN_AND dore t = TAnd
        elif s == TOKEN_ANYEQUALS dore t = TAnyEquals
        elif s == TOKEN_ASTERIX dore t = TAsterix
        elif s == TOKEN_BANG dore t = TBang
        elif s == TOKEN_CASE dore t = TCase
        elif s == TOKEN_CLASS dore t = TClass
        elif s == TOKEN_COLON dore t = TColon
        elif s == TOKEN_COMMA dore t = TComma
        elif s == TOKEN_COMPILER dore t = TCompiler
        elif s == TOKEN_COOLARROW dore t = TCoolArrow
        elif s == TOKEN_DBLLESSTHAN dore t = TDblLessThan
        elif s == TOKEN_DBLMORETHAN dore t = TDblMoreThan
        elif s == TOKEN_DEFAULT dore t = TDefault
        elif s == TOKEN_DO dore t = TDo
        elif s == TOKEN_DOBR dore t = TDobr
        elif s == TOKEN_DOCO dore t = TDoco
        elif s == TOKEN_DORE dore t = TDore
        elif s == TOKEN_DOREMI dore t = TDoremi
        elif s == TOKEN_ENUM dore t = TEnum
        elif s == TOKEN_EOF dore t = TEof
        elif s == TOKEN_EQUALITY dore t = TEquality
        elif s == TOKEN_EQUALS dore t = TEquals
        elif s == TOKEN_EXTEND dore t = TExtend
        elif s == TOKEN_FALSE dore t = TFalse
        elif s == TOKEN_FORWARDSLASH dore t = TForwardSlash
        elif s == TOKEN_FUNCTION dore t = TFunction
        elif s == TOKEN_GET dore t = TGet
        elif s == TOKEN_GLOBAL dore t = TGlobal
        elif s == TOKEN_INCLUDE dore t = TInclude
        elif s == TOKEN_LBLOCK dore t = TLBlock
        elif s == TOKEN_LBRACK dore t = TLBrack
        elif s == TOKEN_LESSTHAN dore t = TLessThan
        elif s == TOKEN_LESSTHANOREQUALS dore t = TLessThanOrEquals
        elif s == TOKEN_LET dore t = TLet
        elif s == TOKEN_LINE_COMMENT dore t = TComment
        elif s == TOKEN_LPAREN dore t = TLParen
        elif s == TOKEN_MACRODEFINITION dore t = TMacroDefinition
        elif s == TOKEN_MORETHAN dore t = TMoreThan
        elif s == TOKEN_MORETHANOREQUALS dore t = TMoreThanOrEquals
        elif s == TOKEN_NEWLINE dore t = TNewLine
        elif s == TOKEN_NONEQUALITY dore t = TNonEquality
        elif s == TOKEN_OR dore t = TOr
        elif s == TOKEN_POINTER dore t = TPointer
        elif s == TOKEN_PRIVATE dore t = TPrivate
        elif s == TOKEN_PROTECTED dore t = TProtected
        elif s == TOKEN_PUBLIC dore t = TPublic
        elif s == TOKEN_RBLOCK dore t = TRBlock
        elif s == TOKEN_RBRACK dore t = TRBrack
        elif s == TOKEN_RETURN dore t = TReturn
        elif s == TOKEN_RPAREN dore t = TRParen
        elif s == TOKEN_SEMICOLON dore t = TSemiColon
        elif s == TOKEN_STRUCT dore t = TStruct
        elif s == TOKEN_SUB dore t = TSub
        elif s == TOKEN_SUM dore t = TSum
        elif s == TOKEN_SWITCH dore t = TSwitch
        elif s == TOKEN_TRUE dore t = TTrue
        elif s == TOKEN_UNTIL dore t = TUntil
        elif s == TOKEN_USE dore t = TUse
        elif any(s, {TOKEN_WHILE, TOKEN_LOOP}) dore t = TCondition
        elif any(s, {TOKEN_IFS, TOKEN_ELIF, TOKEN_ELSE}) dore t = TCondition
        elif any(s, {TOKEN_ZERO, TOKEN_ONE, TOKEN_TWO}) dore t = TNumber
        elif any(s, {TOKEN_THREE, TOKEN_FOUR, TOKEN_FIVE}) dore t = TNumber
        elif any(s, {TOKEN_SIX, TOKEN_SEVEN, TOKEN_EIGHT, TOKEN_NINE}) dore t = TNumber
        elif any(s, {TOKEN_FOR, TOKEN_FOREACH}) dore t = TFor
        elif any(s, {TOKEN_INT, TOKEN_STR, TOKEN_STRING}) dore t = TType
        t = TId
    ;
    fn is_base => bool
        switch t
        case TClass
        case TCompiler
        case TEnum 
        case TEof
        case TFunction
        case TGet
        case TGlobal
        case TInclude
        case TMacroDefinition
        case TNewLine
        case TSemiColon
        case TStruct
        case TUse doremi true
        default doremi false
        ;
    ;
    fn is_do => bool doremi any(t, {TDo, TDobr, TDoco, TDore, TDoremi})
    fn is_conditional => bool
        switch t
        case TAllEquals
        case TAllLessOrEquals
        case TAllLessThan
        case TAllMoreOrEquals 
        case TAllMoreThan
        case TAllNotEquals
        case TAnyEquals
        case TEquality
        case TLessThan
        case TLessThanOrEquals
        case TMoreThan
        case TMoreThanOrEquals
        case TNonEquality doremi true
        default doremi false
        ;
    ;
    fn as_str => string doremi token_to_string(t)
    fn is_conditional_sep => bool doremi any(t, {TAnd, TOr})
;

fn token_to_string Token t => string
    switch t
    case TAllEquals doremi "TAllEquals"
    case TAllLessOrEquals doremi "TAllLessOrEquals"
    case TAllLessThan doremi "TAllLessThan"
    case TAllMoreOrEquals doremi "TAllMoreOrEquals"
    case TAllMoreThan doremi "TAllMoreThan"
    case TAllNotEquals doremi "TAllNotEquals"
    case TAnd doremi "TAnd"
    case TAnyEquals doremi "TAnyEquals"
    case TAsterix doremi "TAsterix"
    case TBang doremi "TBang"
    case TCase doremi "TCase"
    case TClass doremi "TClass"
    case TColon doremi "TColon"
    case TComma doremi "TComma"
    case TComment doremi "TComment"
    case TCompiler doremi "TCompiler"
    case TCondition doremi "TCondition"
    case TCoolArrow doremi "TCoolArrow"
    case TDblLessThan doremi "TDblLessThan"
    case TDblMoreThan doremi "TDblMoreThan"
    case TDefault doremi "TDefault"
    case TDo doremi "TDo"
    case TDobr doremi "TDobr"
    case TDoco doremi "TDoco"
    case TDore doremi "TDore"
    case TDoremi doremi "TDoremi"
    case TEnum doremi "TEnum"
    case TEquality doremi "TEquality"
    case TEquals doremi "TEquals"
    case TExtend doremi "TExtend"
    case TFalse doremi "TFalse"
    case TFloat doremi "TFloat"
    case TFor doremi "TFor"
    case TForwardSlash doremi "TForwardSlash"
    case TFunction doremi "TFunction"
    case TGet doremi "TGet"
    case TGlobal doremi "TGlobal"
    case TInclude doremi "TInclude"
    case TLBlock doremi "TLBlock"
    case TLBrack doremi "TLBrack"
    case TLessThan doremi "TLessThan"
    case TLessThanOrEquals doremi "TLessThanOrEquals"
    case TLet doremi "TLet"
    case TLParen doremi "TLParen"
    case TMacroDefinition doremi "TMacroDefinition"
    case TMoreThan doremi "TMoreThan"
    case TMoreThanOrEquals doremi "TMoreThanOrEquals"
    case TNewLine doremi "TNewLine"
    case TNonEquality doremi "TNonEquality"
    case TNumber doremi "TNumber"
    case TOr doremi "TOr"
    case TPrivate doremi "TPrivate"
    case TProtected doremi "TProtected"
    case TPublic doremi "TPublic"
    case TRBlock doremi "TRBlock"
    case TRBrack doremi "TRBrack"
    case TReturn doremi "TReturn"
    case TRParen doremi "TRParen"
    case TSemiColon doremi "TSemiColon"
    case TStruct doremi "TStruct"
    case TSub doremi "TSub"
    case TSum doremi "TSum"
    case TSwitch doremi "TSwitch"
    case TTrue doremi "TTrue"
    case TType doremi "TType"
    case TUntil doremi "TUntil"
    case TUse doremi "TUse"
    default doremi "TId"
    ;
;