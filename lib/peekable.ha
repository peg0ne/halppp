inc => vector
get => option
use => std

struct Peekable<T>
private
    vector<T> _values = {}
    int _index = 0
pub
    Peekable => do return
    Peekable vector<T> values =>
        _values = values
    ;
    Peekable string text =>
        foreach c in text
            _values.push_back(c)
        ;
    ;
    fn index => int doremi _index
    fn size => int doremi _values.size()
    fn is_end => bool doremi _index > _values.size() - 1
    fn is_begin => bool doremi _index == 0
    fn at int at => Option<T> doremi at < _valuse.size() ? Some(_values.at(at)) : None<T>()
    fn prev => Option<T> doremi !is_begin() ? at(--_index) : None<T>()
    fn peek_prev => Option<T> doremi !is_begin() ? at(_index - 1) : None<T>()
    fn next => Option<T> doremi !is_end() ? at(_index++) : None<T>()
    fn peek => Option<T> doremi !is_end() ? at(_index) : None<T>()
;