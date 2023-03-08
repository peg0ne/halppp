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
    fn set T key, U value =>
        if !contains(key) do return
        let i = 1
        loop
            if i >= _keys.size() doremi None<U>()
            if _keys.at(i) == key
                _values[i] = value
                return
            ;
            i++
        ;
    ;
    fn try_get_value T key => Option<U>
        let i = 0
        loop
            if i >= _keys.size() doremi None<U>()
            if _keys.at(i) == key doremi Some(_values.at(i))
            i++
        ;
    ;
    fn try_get_value_ptr T key => Option<U*>
        let i = 0
        loop
            if i >= _keys.size() doremi None<U*>()
            if _keys.at(i) == key doremi Some(&_values[i])
            i++
        ;
    ;
    fn steal Dictionary<T, U> other =>
        foreach key in other.keys()
            loop
                select val from other.try_get_value(key)
                    add(key, val)
                ;
            ;
        ;
    ;
;