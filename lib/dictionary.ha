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
    fn [ T key => Option<U> doremi try_get_value(key)
    fn keys => vector<T> doremi _keys
    fn contains T key => bool
        foreach k in _keys
            if k == key doremi true
        ;
        return false
    ;
    fn remove T key =>
        vector<T> keys = {}
        vector<U> values = {}
        if !contains(key) do return
        let i = 0
        loop
            if i >= _keys.size() do break
            if _keys.at(i) == key doco i++
            keys.push_back(_keys.at(i))
            values.push_back(_values.at(i))
            i++
        ;
        _keys = keys
        _values = values
    ;
    fn add T key, U value =>
        if contains(key) do return
        _keys.push_back(key)
        _values.push_back(value)
    ;
    fn set T key, U value =>
        if !contains(key) do return
        let i = 0
        loop
            if i >= _keys.size() do return
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
            select val from other.try_get_value(key)
                add(key, val)
            ;
        ;
    ;
;