inc => vector
get => option

struct Peekable<T>
private
    vector<T> _values
    int _index = 0
pub
    Peekable vector<T> values =>
        _values = values
    ;
    fn size => int doremi _values.size()
    fn is_end => bool doremi _index > _values.size() - 1
    fn is_begin => bool doremi _index == 0
    fn at => int at => Option<T> => doremi Some(_values.at(at))
    fn prev => Option<T> doremi !is_begin() ? at(--_index) : None<T>()
    fn peek_prev => Option<T> doremi !is_begin() ? at(_index - 1) : None<T>()
    fn next => Option<T> doremi !is_end() ? at(_index++) : None<T>()
    fn peek => Option<T> doremi !is_end() ? at(_index + 1) : None<T>()
;
