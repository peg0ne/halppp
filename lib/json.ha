get => stringextensions, conditional, print, dictionary, peekable

enum JsonType
    String,
    Number,
    Object,
    Array,
    Boolean,
    Null,
;

class Json
    string _name
    vector<Json> _value
    JsonType _type
    string _text
    double _number
    bool _boolean
    vector<string> _text_arr
    vector<double> _number_arr
    vector<bool> _boolean_arr
    vector<bool> _null_object_arr
    vector<Json> _object_arr
    Json => do return
    Json string json_string =>
        json_parse_json(json_string)
    ;
    Json string name, string value =>
        _name = name
        if value.size() == 0 do value += "null"
        let val = String(value)
        if value == "null"
            _type = JsonType::Null
        ;
        if any(value, {"false", "true"})
            _type = JsonType::Boolean
            _boolean = value == "true"
        ;
        elif is_char_number(value.at(0))
            _type = JsonType::Number
            _number = val.to_num().value_or(0.0)
        ;
        elif val.starts_with("[")
            _type = JsonType::Array
        ;
        elif val.starts_with("{")
            _type = JsonType::Object
        ;
        else
            _type = JsonType::String
            _text = value
        ;
    ;
pub
    fn name => string doremi _name
    fn type_as_str => string doremi to_string(_type)
    fn value_as_str => string
        switch _type
        case JsonType::Number doremi to_string(_number)
        case JsonType::Boolean doremi _boolean ? "true" : "false"
        case JsonType::String doremi _text
        case JsonType::Null doremi "null"
        default doremi ""
        ;
    ;
;

fn json_parse_json string json_string => vector<Json>
    vector<Json> json = {}
    vector<char> chars = {}

    let s = String(json_string)
    json_string = s.strip()
    foreach ch in json_string do chars.push_back(ch)
    let peekable = Peekable<char>(chars)
    if peekable.next().value_or(' ') != '{' doremi json
    loop
        select j from json_parse_json_obj(&peekable)
            json.push_back(j)
            println(j.name() + " >> " + j.type_as_str() + ": " + j.value_as_str())
            continue
        ;
        break
    ;
    return json
;

fn json_parse_json_obj Peekable<char> *peekable => Option<Json>
    loop
        select c from peekable->next()
            if isspace(c) do continue
            if c != '"' do return None<Json>()
        ;
        break
    ;
    let name = json_collect_name_json(peekable)
    if name.size() == 0 doremi None<Json>()
    loop
        select c from peekable->peek()
            if isspace(c) doco peekable->next()
            if c == ':' doco peekable->next()
            break
        ;
        break
    ;
    let value = json_collect_value_json(peekable)
    if value.size() == 0 doremi None<Json>()
    return Some(Json(name, value))
;

fn json_collect_name_json Peekable<char> *peekable => string
    let is_escaped = false
    let name = ""
    loop
        select c from peekable->next()
            switch c
            case '\\'
                if !is_escaped do is_escaped = true
                name += c
                break
            case '"'
                if !is_escaped doremi name
                name += c
                break
            default
                is_escaped = false
                name += c
                break
            ;
            continue
        ;
        break
    ;
    return name
;

fn json_collect_object_json Peekable<char> *peekable => string
    let value = ""
    loop
        select c from peekable->next()
            switch c
            case '}' doremi value
            default
                value += c
                break
            ;
            continue
        ;
        break
    ;
    return value
;

fn json_collect_array_json Peekable<char> *peekable => string
    let value = ""
    loop
        select c from peekable->next()
            switch c
            case ']' doremi value
            default
                value += c
                break
            ;
            continue
        ;
        break
    ;
    return value
;

fn json_collect_value_json Peekable<char> *peekable => string
    let value = ""
    loop
        select c from peekable->next()
            switch c
            case ',' doremi value
            case '['
                value = "["
                value += json_collect_array_json(peekable)
                value += "]"
                loop
                    select c from peekable->next()
                        if isspace(c) do continue
                    ;
                    break
                ;
                return value
            case '{'
                value = "{"
                value += json_collect_object_json(peekable)
                value += "}"
                loop
                    select c from peekable->next()
                        if isspace(c) do continue
                    ;
                    break
                ;
                return value
            case '"'
                value = json_collect_name_json(peekable)
                loop
                    select c from peekable->next()
                        if isspace(c) do continue
                    ;
                    break
                ;
                return value
            default
                if isspace(c) doremi value
                value += c
                break
            ;
            continue
        ;
        break
    ;
    return value
;
get => files
fn tests =>
    let js = ""
    select s from read("test.json") do js = s
    let j = Json(js)
;

fn main =>
    tests()
;