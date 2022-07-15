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
    UNKNOWN,
;

struct Token_t
    Token t = TId
    Token_t string s =>
        let S = String(s)
        if S.starts_with(QUOTE) dore t = TString
        elif S.starts_with("'") dore t = TChar
        elif s == TOKEN_SUB dore t = TSub
        elif s == TOKEN_COMMA dore t = TComma
        elif s == TOKEN_COLON dore t = TColon
        elif s == TOKEN_SEMICOLON dore t = TSemiColon
        elif s == TOKEN_NONEQUALITY dore t = TNonEquality
        elif s == TOKEN_LPAREN dore t = TLParen
        elif s == TOKEN_BANG dore t = TBang
        elif s == TOKEN_RPAREN dore t = TRParen
        elif s == TOKEN_LBRACK dore t = TLBrack
        elif s == TOKEN_RBRACK dore t = TRBrack
        elif s == TOKEN_LBLOCK dore t = TLBlock
        elif s == TOKEN_RBLOCK dore t = TRBlock
        elif s == TOKEN_ASTERIX dore t = TAsterix
        elif s == TOKEN_POINTER dore t = TPointer
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
        elif any(s, {TOKEN_ZERO, TOKEN_ONE, TOKEN_TWO}) dore t = TNumber
        elif any(s, {TOKEN_THREE, TOKEN_FOUR, TOKEN_FIVE}) dore t = TNumber
        elif any(s, {TOKEN_SIX, TOKEN_SEVEN, TOKEN_EIGHT, TOKEN_NINE}) dore t = TNumber
        elif s == TOKEN_CLASS dore t = TClass
        elif s == TOKEN_COMPILER dore t = TCompiler
        elif s == TOKEN_MACRODEFINITION dore t = TMacroDefinition
        elif s == TOKEN_DO dore t = TDo
        elif s == TOKEN_DOBR dore t = TDobr
        elif s == TOKEN_DOCO dore t = TDoco
        elif s == TOKEN_DORE dore t = TDore
        elif s == TOKEN_DOREMI dore t = TDoremi
        elif s == TOKEN_ENUM dore t = TEnum
        elif any(s, {TOKEN_SWITCH, TOKEN_WHILE, TOKEN_LOOP}) dore t = TCondition
        elif any(s, {TOKEN_IFS, TOKEN_ELIF, TOKEN_ELSE}) dore t = TCondition
        elif s == TOKEN_EXTEND dore t = TExtend
        elif s == TOKEN_FALSE dore t = TFalse
        elif s == TOKEN_FUNCTION dore t = TFunction
        elif any(s, {TOKEN_FOR, TOKEN_FOREACH}) dore t = TFor
        elif s == TOKEN_GET dore t = TGet
        elif s == TOKEN_GLOBAL dore t = TGlobal
        elif s == TOKEN_INCLUDE dore t = TInclude
        elif any(s, {TOKEN_INT, TOKEN_STR, TOKEN_STRING}) dore t = TType
        elif s == TOKEN_LET dore t = TLet
        elif s == TOKEN_PRIVATE dore t = TPrivate
        elif s == TOKEN_PROTECTED dore t = TProtected
        elif s == TOKEN_PUBLIC dore t = TPublic
        elif s == TOKEN_RETURN dore t = TReturn
        elif s == TOKEN_STRUCT dore t = TStruct
        elif s == TOKEN_TRUE dore t = TTrue
        elif s == TOKEN_UNTIL dore t = TUntil
        elif s == TOKEN_USE dore t = TUse
        elif s == TOKEN_EOF dore t = TEof
        t = TId
    ;
    fn is_base => bool
        if any(t, {TClass, TEof, TFunction, TGet, TGlobal}) doremi true
        if any(t, {TInclude, TMacroDefinition, TNewLine}) doremi true
        if any(t, {TSemiColon, TStruct, TUse}) doremi true
        if any(t, {TCompiler, TEnum}) doremi true
        return false
    ;
    fn is_do => bool doremi any(t, {TDo, TDobr, TDoco, TDore, TDoremi})
    fn is_conditional => bool
        if any(t, {TEquality, TNonEquality, TMoreThanOrEquals}) doremi true
        if any(t, {TLessThanOrEquals, TLessThan, TMoreThan}) doremi true
        if any(t, {TAnyEquals, TAllEquals, TAllNotEquals}) doremi true
        if any(t, {TAllLessThan, TAllMoreThan}) doremi true
        if any(t, {TAllLessOrEquals, TAllMoreOrEquals}) doremi true
        return false
    ;
    fn is_conditional_sep => bool doremi any(t, {TAnd, TOr})
;

fn token_to_string Token t => string
    if t == TSub doremi "TSub"
    elif t == TComma doremi "TComma"
    elif t == TColon doremi "TColon"
    elif t == TSemiColon doremi "TSemiColon"
    elif t == TNonEquality doremi "TNonEquality"
    elif t == TLParen doremi "TLParen"
    elif t == TBang doremi "TBang"
    elif t == TRParen doremi "TRParen"
    elif t == TLBrack doremi "TLBrack"
    elif t == TRBrack doremi "TRBrack"
    elif t == TLBlock doremi "TLBlock"
    elif t == TRBlock doremi "TRBlock"
    elif t == TAsterix doremi "TAsterix"
    elif t == TForwardSlash doremi "TForwardSlash"
    elif t == TComment doremi "TComment"
    elif t == TNewLine doremi "TNewLine"
    elif t == TAnd doremi "TAnd"
    elif t == TSum doremi "TSum"
    elif t == TLessThan doremi "TLessThan"
    elif t == TDblLessThan doremi "TDblLessThan"
    elif t == TAllLessThan doremi "TAllLessThan"
    elif t == TLessThanOrEquals doremi "TLessThanOrEquals"
    elif t == TAllNotEquals doremi "TAllNotEquals"
    elif t == TEquals doremi "TEquals"
    elif t == TAllEquals doremi "TAllEquals"
    elif t == TAllLessOrEquals doremi "TAllLessOrEquals"
    elif t == TEquality doremi "TEquality"
    elif t == TCoolArrow doremi "TCoolArrow"
    elif t == TAllMoreOrEquals doremi "TAllMoreOrEquals"
    elif t == TAnyEquals doremi "TAnyEquals"
    elif t == TMoreThan doremi "TMoreThan"
    elif t == TMoreThanOrEquals doremi "TMoreThanOrEquals"
    elif t == TDblMoreThan doremi "TDblMoreThan"
    elif t == TAllMoreThan doremi "TAllMoreThan"
    elif t == TOr doremi "TOr"
    elif t == TNumber doremi "TNumber"
    elif t == TFloat doremi "TFloat"
    elif t == TClass doremi "TClass"
    elif t == TCompiler doremi "TCompiler"
    elif t == TMacroDefinition doremi "TMacroDefinition"
    elif t == TDo doremi "TDo"
    elif t == TDobr doremi "TDobr"
    elif t == TDoco doremi "TDoco"
    elif t == TDore doremi "TDore"
    elif t == TDoremi doremi "TDoremi"
    elif t == TEnum doremi "TEnum"
    elif t == TExtend doremi "TExtend"
    elif t == TFalse doremi "TFalse"
    elif t == TFunction doremi "TFunction"
    elif t == TFor doremi "TFor"
    elif t == TGet doremi "TGet"
    elif t == TGlobal doremi "TGlobal"
    elif t == TInclude doremi "TInclude"
    elif t == TType doremi "TType"
    elif t == TLet doremi "TLet"
    elif t == TPrivate doremi "TPrivate"
    elif t == TProtected doremi "TProtected"
    elif t == TPublic doremi "TPublic"
    elif t == TReturn doremi "TReturn"
    elif t == TStruct doremi "TStruct"
    elif t == TTrue doremi "TTrue"
    elif t == TUntil doremi "TUntil"
    elif t == TUse doremi "TUse"
    elif t == TCondition doremi "TCondition"
    return "TId"
;