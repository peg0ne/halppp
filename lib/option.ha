use => std

struct Option<T>
private
    T _value
    bool _forced_none = true
pub
    fn is_none => bool doremi &_value == nullptr || _forced_none
    fn is_some => bool doremi !is_none()
    fn value_or T value => T doremi is_some() ? _value : value
    fn value_unsafe => T doremi _value
    fn to_string => string doremi is_some() ? "Some(" + std::to_string(_value) + ")" : "None"
    fn select_it<Func, ...Args> Func func, Args... args =>
        if is_none() do return
        func(_value, args...)
    ;
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
fn None<T> T value => Option<T> doremi Option<T>()
