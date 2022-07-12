fn validate_enum Enum enumerator, Compiler *compiler_t =>
    let contains = compiler_t->contains_enum(enumerator.name)
    if contains
        display_err_message("Duplicate instances Enum of: " + enumerator.name)
    ;
;

fn enums_construct Compiler *compiler_t => Enum
    let id = get_id_or_exit(compiler_t->next(), "[Enum] Requires Id in initialization")
    let enumerator = Enum(id)
    get_arrow_or_exit(compiler_t->next(), "[Enum] Requires [=>] after Id")
    let enum_def = EnumValue()
    let can_continue = true
    while can_continue
        let next = get_next_or_exit(compiler_t->next(), "[Enum] Ends without closing itself")
        switch next.token
            case TId: do can_continue = true
                if enum_def.name.size() > 0
                    display_err_message("[Enum] Cannot assign id to EnumValue that already has id");
                ;
                dobr enum_def.name = next.name
            case TNumber: do can_continue = true
            case TEquals: do can_continue = true
                if enum_def.name.size() == 0
                    display_err_message("[Enum] Cannot assign value to EnumValue without id")
                ;
                break
            case TNewLine: do break
            case TComma: do can_continue = true
                if enum_def.name.size() == 0
                    display_err_message("[Enum] Missing enum before separator")
                ;
                enumerator.enums.push_back(enum_def)
                dobr enum_def = EnumValue()
            case TSemiColon: dobr can_continue = false
            case TEof: dobr can_continue = false
            default: dobr display_err_message("[Enum] Invalid token inside Enum constructor")
        ;
    ;
    validate_enum(enumerator, compiler_t)
    compiler_t->add_enum(enumerator)
    return enumerator
;
