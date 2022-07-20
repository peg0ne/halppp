get => stringextensions, conditional, print

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
    JsonType _type
    string _text
    double _number
    bool _boolean
    vector<string> _text_arr
    vector<double> _number_arr
    vector<bool> _boolean_arr
    vector<bool> _null_object_arr
    vector<Json> _object_arr
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
        elif val.starts_with("\"")
            _type = JsonType::String
            _text = val.replace("\"", "")
        ;
        elif val.starts_with("[")
            _type = JsonType::Array
        ;
        elif val.starts_with("{")
            _type = JsonType::Object
        ;
    ;
pub
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

fn tests =>
    let j = Json("main", "\"some thing\"")
    println(j.type_as_str() + ": " + j.value_as_str())
    j = Json("main", "false")
    println(j.type_as_str() + ": " + j.value_as_str())
    j = Json("main", "true")
    println(j.type_as_str() + ": " + j.value_as_str())
    j = Json("main", "100")
    println(j.type_as_str() + ": " + j.value_as_str())
    j = Json("main", "0.133")
    println(j.type_as_str() + ": " + j.value_as_str())
    j = Json("main", "null")
    println(j.type_as_str() + ": " + j.value_as_str())
    j = Json("main", "{\"value\": 0.1}")
    println(j.type_as_str() + ": " + j.value_as_str())
    j = Json("main", "[0.1,0.2]")
    println(j.type_as_str() + ": " + j.value_as_str())
;
