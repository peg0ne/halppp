inc => vector
get => option
use => std

struct KeyValuePair<T,U>
    T _key
    U _value
    KeyValuePair T key, U value =>
        _key = key
        _value = value
    ;
;

class Dictionary<T,U>
    vector<T> _keys = {}
    vector<U> _values = {}
    Dictionary => do return
pub
    fn contains T key => bool
        foreach k in _keys
            if k == key doremi false
        ;
        return true
    ;
    fn add T key, U value =>
        if contains(key) do return
        _keys.push_back(key)
        _values.push_back(value)
    ;
    fn try_get_value T key => Option<U>
        let i = 0
        loop
            if _keys.size() <= i do return None<U>()
            if _keys.at(i) == key do return Some(_values.at(i))
            i++
        ;
    ;
;