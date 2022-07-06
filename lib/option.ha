use => std

struct Option<T>
    T _value
    bool _forced_none = true
    pub fn is_none => bool doremi &_value == nullptr || _forced_none
    pub fn is_some => bool doremi !is_none()
    pub fn value_or T value => T doremi is_some() ? _value : value
    pub fn to_string => string doremi is_some() ? "Some(" + std::to_string(_value) + ")" : "None"
    Option => 
        _forced_none = true
    ;
    Option T val =>
        _value = val
        _forced_none = false
    ;
;

fn Some<T> T value => Option<T> doremi Option<T>(value)
fn None<T> => Option<T> doremi Option<T>()