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
    fn keys => vector<T> doremi _keys
    fn contains T key => bool
        foreach k in _keys
            if k == key doremi true
        ;
        return false
    ;
    fn add T key, U value =>
        if contains(key) do return
        _keys.push_back(key)
        _values.push_back(value)
    ;
    fn try_get_value T key => Option<U>
        let i = 0
        loop
            if i >= _keys.size() do return None<U>()
            if _keys.at(i) == key do return Some(_values.at(i))
            i++
        ;
    ;
;
