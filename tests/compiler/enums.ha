enum EnumError =>
    Duplicate,
    NoId,
    NoArrow,
    NoValue,
    Closed,
    IdExists,
    CommaNoId,
    ValueNoId,
    Unexpected,
;

fn e_err EnumError err => string doremi e_err(err, EMPTY, false)
fn e_err EnumError err, string opt => string doremi e_err(err, opt, false)
fn e_err EnumError err, string opt, bool display => string
    string msg = "[Enum] "
    switch err
    case EnumError::Duplicate   dobr msg += "Duplicate instances Enum of: "
    case EnumError::NoId        dobr msg += "Requires Id in initialization"
    case EnumError::NoArrow     dobr msg += "Requires [=>] after Id"
    case EnumError::NoValue     dobr msg += "No Value found after assignment"
    case EnumError::Closed      dobr msg += "Ends without closing itself"
    case EnumError::IdExists    dobr msg += "Cannot assign id to EnumValue that already has id"
    case EnumError::CommaNoId   dobr msg += "Missing enum before separator"
    case EnumError::ValueNoId   dobr msg += "Cannot assign value to EnumValue without id"
    case EnumError::Unexpected  dobr msg += "Invalid token inside Enum constructor"
    default do break
    ;
    msg += opt
    if display do display_err_message(msg)
    return msg
;

fn validate_enum Enum enumerator, Compiler *compiler_t =>
    let contains = compiler_t->has_enum(enumerator.name)
    if contains do e_err(EnumError::Duplicate, enumerator.name, true)
;

fn enums_construct Compiler *compiler_t => Enum
    let id = get_id_or_exit(compiler_t->next(), e_err(EnumError::NoId))
    let enumerator = Enum(id)
    get_arrow_or_exit(compiler_t->next(), e_err(EnumError::NoArrow))
    let enum_def = EnumValue()
    loop
        let next = get_next_or_exit(compiler_t->next(), e_err(EnumError::Closed))
        if next.token == Token::Id
            if enum_def.name.size() == 0 doco enum_def.name = next.name
            e_err(EnumError::IdExists, EMPTY ,true)
        ;
        elif next.token == Token::Comma
            if enum_def.name.size() == 0 do e_err(EnumError::CommaNoId, EMPTY, true)
            enumerator.enums.push_back(enum_def)
            enum_def = EnumValue()
        ;
        elif next.token == Token::Equals
            if enum_def.name.size() != 0
                let val = get_or_exit(compiler_t->next(), Token::Number, e_err(EnumError::NoValue))
                enum_def.value = Some(val)
                continue
            ;
            e_err(EnumError::ValueNoId, EMPTY, true)
        ;
        if any(next.token, {Token::SemiColon, Token::Eof}) do break
        if any(next.token, {Token::Id, Token::NewLine, Token::Comma}) do continue
        e_err(EnumError::Unexpected, EMPTY, true)
    ;
    validate_enum(enumerator, compiler_t)
    compiler_t->add_enum(enumerator)
    return enumerator
;
