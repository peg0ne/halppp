fn validate_enum Enum enumerator, Compiler *compiler_t =>
    let contains = compiler_t->has_enum(enumerator.name)
    if contains do display_err_message("Duplicate instances Enum of: " + enumerator.name)
;

fn enums_construct Compiler *compiler_t => Enum
    let id = get_id_or_exit(compiler_t->next(), "[Enum] Requires Id in initialization")
    let enumerator = Enum(id)
    get_arrow_or_exit(compiler_t->next(), "[Enum] Requires [=>] after Id")
    let enum_def = EnumValue()
    loop
        let next = get_next_or_exit(compiler_t->next(), "[Enum] Ends without closing itself")
        if next.token == TId
            if enum_def.name.size() == 0 doco enum_def.name = next.name
            display_err_message("[Enum] Cannot assign id to EnumValue that already has id")
        ;
        elif next.token == TComma
            if enum_def.name.size() == 0 do display_err_message("[Enum] Missing enum before separator")
            enumerator.enums.push_back(enum_def)
            enum_def = EnumValue()
        ;
        elif any(next.token, {TNumber, TEquals})
            if enum_def.name.size() != 0 do break
            display_err_message("[Enum] Cannot assign value to EnumValue without id")
        ;
        if any(next.token, {TSemiColon, TEof}) do break
        if any(next.token, {TId, TNewLine, TComma}) do continue
        display_err_message("[Enum] Invalid token inside Enum constructor")
    ;
    validate_enum(enumerator, compiler_t)
    compiler_t->add_enum(enumerator)
    return enumerator
;
