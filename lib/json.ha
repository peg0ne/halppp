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
    string _name = ""
    vector<Json*> _value = {}
    JsonType _type = JsonType::Object
    string _text = ""
    double _number = 0.0
    bool _boolean = false
    Json => do _type = JsonType::Object
    Json string json_string =>
        _value = json_parse_json(json_string)
        _type = JsonType::Object
    ;
    Json string name, double value =>
        _name = name
        _type = JsonType::Number
        _number = value
    ;
    Json string name, string value =>
        _name = name
        let val = String(value)
        if value == ""
            _type = JsonType::String
            _text = " "
        ;
        elif value == "null"
            _type = JsonType::Null
        ;
        elif any(value, {"false", "true"})
            _type = JsonType::Boolean
            _boolean = value == "true"
        ;
        elif is_char_number(value.at(0))
            _type = JsonType::Number
            _number = val.to_num().value_or(0.0)
        ;
        elif val.starts_with("[")
            _type = JsonType::Array
            _value = json_parse_json_arr(value)
        ;
        elif val.starts_with("{")
            _type = JsonType::Object
            _value = json_parse_json(value)
        ;
        elif val.starts_with("\"")
            _type = JsonType::String
            val.remove(0)
            val.pop()
            _text = val.to_string()
        ;
        else
            _type = JsonType::String
            _text = value
        ;
    ;
pub
    fn add Json *value =>
        _value.push_back(value)
    ;
    fn add string value =>
        if _type != JsonType::Array do return
        _value.push_back(new Json("", value))
    ;
    fn add int value =>
        if _type != JsonType::Array do return
        _value.push_back(new Json("", value))
    ;
    fn try_add_str string name, string value =>
        if _type != JsonType::Object do return
        if try_get(name).is_none()
            _value.push_back(new Json(name, "\"" + value + "\""))
        ;
    ;
    fn try_add string name, string value =>
        if _type != JsonType::Object do return
        if try_get(name).is_none()
            _value.push_back(new Json(name, value))
        ;
    ;
    fn try_add string name, int value =>
        if _type != JsonType::Object do return
        if try_get(name).is_none()
            _value.push_back(new Json(name, value))
        ;
    ;
    fn value_or<T> T value => T
        return value
    ;
    fn value_or double value => double
        if _type == JsonType::Number doremi _number
        return value
    ;
    fn value_or string value => string
        if _type == JsonType::String doremi _text
        return value
    ;
    fn value_or bool value => bool
        if _type == JsonType::Boolean doremi _boolean
        return value
    ;
    fn size => int doremi _value.size()
    fn pop => do _value.pop_back()
    fn try_get int at => Option<Json*>
        if _type != JsonType::Array doremi None<Json*>()
        if at < 0 || at >= _value.size() doremi None<Json*>()
        return Some(_value.at(at))
    ;
    fn try_get string name => Option<Json*>
        if _type == JsonType::Array doremi None<Json*>()
        foreach o in _value
            if name == o->name() doremi o
        ;
        return None<Json*>()
    ;
    fn name => string doremi _name
    fn type => JsonType doremi _type
    fn type_as_str => string doremi to_string(_type)
    fn value_as_str => string
        switch _type
        case JsonType::Object doremi "{" + to_string(_value.size()) + "}"
        case JsonType::Array doremi "[" + to_string(_value.size()) + "]"
        case JsonType::Number doremi to_string(_number)
        case JsonType::Boolean doremi _boolean ? "true" : "false"
        case JsonType::String doremi _text
        case JsonType::Null doremi "null"
        default doremi ""
        ;
    ;
    fn as_str => string
        let buf = ""
        let s = ""
        let i = 0
        if _name.size() != 0 do buf += "\"" + _name + "\": "
        switch _type
        case JsonType::Object
            buf += "{"
            foreach o in _value
                buf += o->as_str()
                i++
                if i < _value.size() do buf += ","
            ;
            buf += "}"
            break
        case JsonType::Array
            buf += "["
            foreach o in _value
                buf += o->as_str()
                i++
                if i < _value.size() do buf += ","
            ;
            buf += "]"
            break
        case JsonType::String
            buf += "\""
            buf += String(_text).escape()
            buf += "\""
            break
        case JsonType::Number
            s = String(to_string(_number)).replace(",",".")
            buf += s
            break
        case JsonType::Boolean dobr buf += _boolean ? "true" : "false"
        case JsonType::Null dobr buf += "null"
        default doremi ""
        ;
        return buf
    ;
;

fn json_parse_json string json_string => vector<Json*>
    vector<Json*> json = {}
    vector<char> chars = {}
    let s = String(json_string)
    json_string = s.strip()
    foreach ch in json_string do chars.push_back(ch)
    let peekable = Peekable<char>(chars)
    if peekable.next().value_or(' ') != '{' doremi json
    loop
        select j from json_parse_json_obj(&peekable)
            json.push_back(j)
            continue
        ;
        break
    ;
    return json
;


fn json_parse_json_arr string json_arr_string => vector<Json*>
    vector<Json*> json = {}
    vector<char> chars = {}
    let s = String(json_arr_string)
    json_arr_string = s.strip()
    foreach ch in json_arr_string do chars.push_back(ch)
    let peekable = Peekable<char>(chars)
    if peekable.next().value_or(' ') != '[' doremi json
    loop
        select j from json_parse_json_arr(&peekable)
            json.push_back(j)
            continue
        ;
        break
    ;
    return json
;

fn json_parse_json_arr Peekable<char> *peekable => Option<Json*>
    loop
        select c from peekable->peek()
            if isspace(c) doco peekable->next()
        ;
        break
    ;
    let value = json_collect_value_json(peekable)
    if value.size() == 0 doremi None<Json*>()
    return Some(new Json("", value))
;

fn json_parse_json_obj Peekable<char> *peekable => Option<Json*>
    loop
        select c from peekable->next()
            if isspace(c) do continue
            if c != '"' do return None<Json*>()
        ;
        break
    ;
    let name = json_collect_name_json(peekable)
    if name.size() == 0 doremi None<Json*>()
    loop
        select c from peekable->peek()
            if isspace(c) doco peekable->next()
            if c == ':' doco peekable->next()
            break
        ;
        break
    ;
    let value = json_collect_value_json(peekable)
    if value.size() == 0 doremi None<Json*>()
    return Some(new Json(name, value))
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

fn json_collect_arr_json Peekable<char> *peekable => string
    let value = ""
    loop
        select c from peekable->next()
            switch c
            case ']' doremi value
            case '['
                value += "["
                value += json_collect_arr_json(peekable)
                value += "]"
                break
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

fn json_collect_object_json Peekable<char> *peekable => string
    let value = ""
    loop
        select c from peekable->next()
            switch c
            case '}' doremi value
            case '{'
                value += "{"
                value += json_collect_object_json(peekable)
                value += "}"
                break
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
                value += "["
                value += json_collect_arr_json(peekable)
                value += "]"
                break
            case '{'
                value = "{"
                value += json_collect_object_json(peekable)
                value += "}"
                break
            case '"'
                value += json_collect_name_json(peekable)
                break
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
fn load_json string path => Json
    let content = ""
    select s from read(path) doremi Json(s)
    return Json()
;
fn write_json string path, Json content =>
    if content.type() != JsonType::Object do return
    let s = content.as_str()
    write(s, path)
;



