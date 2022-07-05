inc => iostream
use => std

struct Option<T>
    T _value
    bool _forced_none = true
    pub fn is_none => bool 
        doremi &_value == nullptr || _forced_none
    ;
    pub fn is_some => bool 
        doremi !is_none()
    ;
    pub fn value_or T value => T
        doremi is_some() ? _value : value
    ;
    Option =>
    ;
    Option T val =>
        _value = val
        _forced_none = false
    ;
;
fn Some<T> T value => Option<T>
    doremi Option<T>(value)
;
fn None<T> => Option<T>
    doremi Option<T>()
;

fn main =>
    if a == b
        return 1
    ;
    Option<int> e
    cout << e.is_some() << " < expected: 7, got: " << e.value_or(7) << "\n"

    let a = Some(0)
    cout << a.is_some() << " < expected: 0, got: "<< a.value_or(1) << "\n"

    let b = Some(10)
    cout << b.is_some() << " < expected: 10, got: "<< b.value_or(5) << "\n"

    let c = None<int>()
    cout << c.is_some() << " < expected: 2, got: " << c.value_or(2) << "\n"
    return 0
;