get => JsonType, JsonTokenizer

class Json
    string _name = ""
    JsonType _type = JsonType::Object
    vector<Json*> _values = {}
    string _text_value = ""
    double _number_value = 0.0
    bool _bool_value = false
    Json => do return
    Json string json_string =>
        let tokens = json_tokenize_json(json_string)
        _values = json_parse_json(tokens)
        _type = JsonType::Object
    ;
    Json string id, JsonType type =>
        this->_name = id
        this->_type = type
    ;
    Json string id, string value =>
        this->_name = id
        this->_type = JsonType::String
        bool escaped = false
        this->_text_value = ""
        foreach i, ch in value
            if ch == '\\' && i == value.size() - 1 && !escaped
                _text_value += "\\"
            ;
            if ch == '"' && !escaped do _text_value += "\\"
            _text_value += string(1, ch)
            escaped = ch == '\\'
        ;
    ;
    Json string id, int value =>
        this->_name = id
        this->_type = JsonType::Number
        this->_number_value = value
    ;
    Json string id, float value =>
        this->_name = id
        this->_type = JsonType::Number
        this->_number_value = value
    ;
    Json string id, double value =>
        this->_name = id
        this->_type = JsonType::Number
        this->_number_value = value
    ;
    Json string id, bool value =>
        this->_name = id
        this->_type = JsonType::Boolean
        this->_bool_value = value
    ;
    Json string id, vector<Json*> values, JsonType type =>
        this->_name = id
        this->_type = type
        this->_values = values
    ;
pub
    fn [ string id => Option<Json*>
        foreach value in _values
            if value->name() == id doremi value
        ;
        return None<Json*>()
    ;
    fn add Json *value => do _values.push_back(value)
    fn add<T> T value => do _values.push_back(new Json("", value))
    fn try_add<T> string name, T value =>
        if try_get(name).is_some() do return
        _values.push_back(new Json(name, value))
    ;
    fn value_or double value => double
        if _type == JsonType::Number doremi _number_value
        return value
    ;
    fn value_or string value => string
        if _type == JsonType::String doremi String(_text_value).replace("\\\"", "\"")
        return value
    ;
    fn value_or bool value => bool
        if _type == JsonType::Boolean doremi _bool_value
        return value
    ;
    fn size => int doremi _values.size()
    fn pop => do _values.pop_back()
    fn try_get_value_of<T> string name, T value => T
        if _type == JsonType::Array doremi value
        select j from try_get(name) doremi j->value_or(value)
        return value
    ;
    fn try_get int at => Option<Json*>
        if _type != JsonType::Array doremi None<Json*>()
        if at < 0 || at >= _values.size() doremi None<Json*>()
        return Some(_values.at(at))
    ;
    fn try_get string name => Option<Json*>
        if _type == JsonType::Array doremi None<Json*>()
        foreach o in _values
            if name == o->name() doremi o
        ;
        return None<Json*>()
    ;
    fn name => string doremi _name
    fn type => JsonType doremi _type
    fn type_as_str => string doremi to_string(_type)
    fn value_as_str => string doremi as_j_str(false)
    fn as_j_str => string doremi as_j_str(true)
    fn as_j_str bool add_name => string
        let buf = add_name ? $"\"{_name}\": " : ""
        switch _type
        case JsonType::String dobr buf += $"\"{_text_value}\""
        case JsonType::Number dobr buf += String($"{_number_value}").replace(",", ".")
        case JsonType::Boolean dobr buf += _bool_value ? "true" : "false"
        case JsonType::Array
            buf += "["
            foreach i,e in _values
                buf += e->as_j_str(false)
                if i < _values.size() - 1
                    buf += ", "
                ;
            ;
            buf += "]"
            break
        case JsonType::Object
            buf += "{"
            foreach i,e in _values
                buf += e->as_j_str()
                if i < _values.size() - 1
                    buf += ", "
                ;
            ;
            buf += "}"
            break
        ;
        return buf
    ;
    fn destruct =>
        foreach v in _values
            v->destruct()
            delete(v)
        ;
    ;
; 
get => JsonParser