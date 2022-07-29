inc => vector
get => option
use => std

class Dictionary<T,U>
    vector<T> _keys = {}
    vector<U> _values = {}
    Dictionary => do return
    fn add T key, U value =>
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