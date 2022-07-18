enum EnumError =>
    EDuplicate,
    ENoId,
    ENoArrow,
    EClosed,
    EIdExists,
    ECommaNoId,
    EValueNoId,
    EUnexpected,
;

fn e_err EnumError err => string doremi e_err(err, EMPTY, false)
fn e_err EnumError err, string opt => string doremi e_err(err, opt, false)
fn e_err EnumError err, string opt, bool display => string
    string msg = "[Enum] "
    switch err
    case EDuplicate   dobr msg += "Duplicate instances Enum of: "
    case ENoId        dobr msg += "Requires Id in initialization"
    case ENoArrow     dobr msg += "Requires [=>] after Id"
    case EClosed      dobr msg += "Ends without closing itself"
    case EIdExists    dobr msg += "Cannot assign id to EnumValue that already has id"
    case ECommaNoId   dobr msg += "Missing enum before separator"
    case EValueNoId   dobr msg += "Cannot assign value to EnumValue without id"
    case EUnexpected  dobr msg += "Invalid token inside Enum constructor"
    default do break
    ;
    msg += opt
    if display do display_err_message(msg)
    return msg
;

fn validate_enum Enum enumerator, Compiler *compiler_t =>
    let contains = compiler_t->has_enum(enumerator.name)
    if contains do e_err(EDuplicate, enumerator.name, true)
;

fn enums_construct Compiler *compiler_t => Enum
    let id = get_id_or_exit(compiler_t->next(), e_err(ENoId))
    let enumerator = Enum(id)
    get_arrow_or_exit(compiler_t->next(), e_err(ENoArrow))
    let enum_def = EnumValue()
    loop
        let next = get_next_or_exit(compiler_t->next(), e_err(EClosed))
        if next.token == TId
            if enum_def.name.size() == 0 doco enum_def.name = next.name
            e_err(EIdExists, EMPTY ,true)
        ;
        elif next.token == TComma
            if enum_def.name.size() == 0 do e_err(ECommaNoId, EMPTY, true)
            enumerator.enums.push_back(enum_def)
            enum_def = EnumValue()
        ;
        elif any(next.token, {TNumber, TEquals})
            if enum_def.name.size() != 0 do break
            e_err(EValueNoId, EMPTY, true)
        ;
        if any(next.token, {TSemiColon, TEof}) do break
        if any(next.token, {TId, TNewLine, TComma}) do continue
        e_err(EUnexpected, EMPTY, true)
    ;
    validate_enum(enumerator, compiler_t)
    compiler_t->add_enum(enumerator)
    return enumerator
;
