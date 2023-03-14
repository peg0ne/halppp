fn json_parser_panic string message =>
    println($"\033[31mJSONPANIC >> {message}\033[0m")
    exit(1)
;

fn json_peek_or_panic Peekable<JsonTokenized> *iter => JsonTokenized
    select peek from iter->peek() doremi peek
    json_parser_panic("Expected token got EOF. (check missing pairs ()/\"\"/{}/[])")
    return JsonTokenized()
;

fn json_next_or_panic Peekable<JsonTokenized> *iter => JsonTokenized
    select next from iter->next() doremi next
    json_parser_panic("Expected token got EOF. (check missing pairs ()/\"\"/{}/[])")
    return JsonTokenized()
;

fn json_next_is_or_panic Peekable<JsonTokenized> *iter, JsonToken token => JsonTokenized
    select next from iter->next()
        if next.token == token doremi next
        json_parser_panic($"Expected token {token} got {next.token}")
    ;
    json_parser_panic($"Expected token {token} got EOF")
    return JsonTokenized()
;

fn json_parse_json vector<JsonTokenized> tokens => vector<Json*>
    let iter = Peekable<JsonTokenized>(tokens)
    json_next_is_or_panic(&iter, JsonToken::LBrace)
    return json_parse_json_obj(&iter)
;

fn json_parse_json_obj Peekable<JsonTokenized> *iter => vector<Json*>
    vector<Json*> objects = {}
    loop
        let current = json_next_or_panic(iter)
        if current.token == JsonToken::RBrace do break
        switch current.token
        case JsonToken::StringLiteral
            objects.push_back(json_parse_identifier(iter, current, false))
            break
        case JsonToken::Comma do break
        default dobr json_parser_panic($"Unallowed token in object {current.token}")
        ;
    ;
    return objects
;

fn json_parse_json_arr Peekable<JsonTokenized> *iter => vector<Json*>
    vector<Json*> objects = {}
    let i = 0
    loop
        let current = json_peek_or_panic(iter)
        if current.token == JsonToken::RBox dobr iter->next()
        switch current.token
        case JsonToken::StringLiteral
        case JsonToken::NumberLiteral
        case JsonToken::BooleanLiteral
        case JsonToken::LBrace
        case JsonToken::LBox
            objects.push_back(
                json_parse_identifier(
                    iter,
                    JsonTokenized(
                        $"{i++}",
                        JsonToken::StringLiteral
                    ),
                    true
                )
            )
            break
        case JsonToken::Comma dobr iter->next()
        default dobr json_parser_panic($"Unallowed token in array {current.token}")
        ;
    ;
    return objects
;

fn json_parse_identifier Peekable<JsonTokenized> *iter, JsonTokenized id, bool from_array => Json*
    if !from_array do json_next_is_or_panic(iter, JsonToken::Colon)
    let value = json_next_or_panic(iter)
    if value.token == JsonToken::StringLiteral
        return new Json(id.literal, value.literal)
    ;
    elif value.token == JsonToken::NumberLiteral
        return new Json(id.literal, String(value.literal).to_num().value_or(0.0))
    ;
    elif value.token == JsonToken::BooleanLiteral
        return new Json(id.literal, value.literal == "true")
    ;
    elif value.token == JsonToken::LBrace
        return new Json(id.literal, json_parse_json_obj(iter), JsonType::Object)
    ;
    elif value.token == JsonToken::LBox
        return new Json(id.literal, json_parse_json_arr(iter), JsonType::Array)
    ;
    json_parser_panic($"Expected Value got {value.token}")
    return new Json()
;