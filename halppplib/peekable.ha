inc => vector
get => option

struct Peekable<T>
    vector<T> _values
    int _index = 0
    Peekable vector<T> values =>
        _values = values
    ;
    pub fn size => int doremi _values.size()
    pub fn is_end => bool doremi _index > _values.size() - 1
    pub fn is_begin => bool doremi _index == 0
    pub fn prev => Option<T> doremi !is_begin() ? Some(_values.at(--_index)) : None<T>()
    pub fn peek_prev => Option<T> doremi !is_begin() ? Some(_values.at(_index - 1)) : None<T>()
    pub fn next => Option<T> doremi !is_end() ? Some(_values.at(_index++)) : None<T>()
    pub fn peek => Option<T> doremi !is_end() ? Some(_values.at(_index + 1)) : None<T>()
;
