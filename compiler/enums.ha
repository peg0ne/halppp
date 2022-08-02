enum EnumError
    Closed,
    CommaNoId,
    Duplicate,
    IdExists,
    Member,
    NoArrow,
    NoId,
    NoValue,
    Unexpected,
    ValueNoId,
;

fn e_err EnumError err => string doremi e_err(err, EMPTY, false, "")
fn e_err EnumError err, string opt => string doremi e_err(err, opt, false, "")
fn e_err EnumError err, string opt, bool display, string recap => string
    string msg = "[Enum] "
    switch err
    case EnumError::Closed      dobr msg += "Ends without closing itself"
    case EnumError::CommaNoId   dobr msg += "Missing enum before separator"
    case EnumError::Duplicate   dobr msg += "Duplicate instances Enum of: "
    case EnumError::IdExists    dobr msg += "Cannot assign id to EnumValue that already has id"
    case EnumError::Member      dobr msg += "Duplicate enum members: "
    case EnumError::NoArrow     dobr msg += "Requires [=>] after Id"
    case EnumError::NoId        dobr msg += "Requires Id in initialization"
    case EnumError::NoValue     dobr msg += "No Value found after assignment"
    case EnumError::Unexpected  dobr msg += "Invalid token inside Enum constructor"
    case EnumError::ValueNoId   dobr msg += "Cannot assign value to EnumValue without id"
    default do break
    ;
    msg += opt
    if display do display_err_message(msg, recap)
    return msg
;

fn validate_enum Enum enumerator, Compiler *compiler_t =>
    let contains = compiler_t->has_enum(enumerator.name)
    if contains do e_err(EnumError::Duplicate, enumerator.name, true, compiler_t->to_err_message())
;

fn enums_construct Compiler *compiler_t => Enum
    let id = get_id_or_exit(compiler_t, e_err(EnumError::NoId))
    let enumerator = Enum(id)
    let enum_def = EnumValue()
    loop
        let next = get_next_or_exit(compiler_t, e_err(EnumError::Closed))
        if next.is_id()
            if enum_def.name.size() == 0 doco enum_def.name = next.name
            e_err(EnumError::IdExists, EMPTY, true, compiler_t->to_err_message())
        ;
        elif next.token == Token::Comma
            if enum_def.name.size() == 0 do e_err(EnumError::CommaNoId, EMPTY, true, compiler_t->to_err_message())
            foreach i in enumerator.enums
                if i.name == enum_def.name
                    e_err(EnumError::Member, enum_def.name, true, compiler_t->to_err_message())
                ;
            ;
            enumerator.enums.push_back(enum_def)
            enum_def = EnumValue()
        ;
        elif next.token == Token::Equals
            if enum_def.name.size() != 0
                let val = get_or_exit(compiler_t, Token::Number, e_err(EnumError::NoValue))
                enum_def.value = Some(val)
                continue
            ;
            e_err(EnumError::ValueNoId, EMPTY, true, compiler_t->to_err_message())
        ;
        if any(next.token, {Token::SemiColon, Token::Eof}) do break
        if any(next.token, {Token::Id, Token::NewLine, Token::Comma}) do continue
        e_err(EnumError::Unexpected, EMPTY, true, compiler_t->to_err_message())
    ;
    validate_enum(enumerator, compiler_t)
    compiler_t->add_enum(enumerator)
    return enumerator
;

