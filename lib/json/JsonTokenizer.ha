get => JsonToken

fn json_tokenize_json string json => vector<JsonTokenized>
    vector<JsonTokenized> tokens = {}
    let iter = Peekable<char>(json)
    let buf = ""
    let escaped = true
    while iter.peek().is_some()
        let ch = iter.next().value_or(' ')
        switch ch
        case '{'
            tokens.push_back(JsonTokenized(ch, JsonToken::LBrace))
            break
        case '}'
            tokens.push_back(JsonTokenized(ch, JsonToken::RBrace))
            break
        case '['
            tokens.push_back(JsonTokenized(ch, JsonToken::LBox))
            break
        case ']'
            tokens.push_back(JsonTokenized(ch, JsonToken::RBox))
            break
        case ':'
            tokens.push_back(JsonTokenized(ch, JsonToken::Colon))
            break
        case ','
            tokens.push_back(JsonTokenized(ch, JsonToken::Comma))
            break
        case '"'
            while iter.peek().is_some()
                let ch = iter.next().value_or(' ')
                if ch == '"' && !escaped do break
                if ch == '\\' && escaped doco escaped = false
                buf += string(1,ch)
                escaped = ch == '\\'
            ;
            tokens.push_back(JsonTokenized(buf, JsonToken::StringLiteral))
            buf = ""
            break
        case '\n'
        case ' ' do break
        default
            buf = string(1,ch)
            while iter.peek().is_some()
                let ch = iter.peek().value_or(' ')
                if ch == '.' && String(buf).to_num().is_some()
                    buf += string(1,ch)
                    iter.next()
                    continue
                ;
                if !isalnum(ch) do break
                buf += string(1,ch)
                iter.next()
            ;
            if buf =|= "true" : "false"
                tokens.push_back(JsonTokenized(buf, JsonToken::BooleanLiteral))
            ;
            select num from String(buf).to_num()
                tokens.push_back(JsonTokenized(buf, JsonToken::NumberLiteral))
            ;
            buf = ""
            break
        ;
    ;
    return tokens
;