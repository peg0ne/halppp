inc => vector
get => option

struct Peekable<T>
private
    vector<T> _values = {}
    int _index = 0
pub
    Peekable =>
    ;
    Peekable vector<T> values =>
        _values = values
    ;
    fn size => int doremi _values.size()
    fn is_end => bool doremi _index > _values.size() - 1
    fn is_begin => bool doremi _index == 0
    fn at int at => Option<T> doremi Some(_values.at(at))
    fn prev => Option<T> doremi !is_begin() ? at(--_index) : None<T>()
    fn peek_prev => Option<T> doremi !is_begin() ? at(_index - 1) : None<T>()
    fn next => Option<T> doremi !is_end() ? at(_index++) : None<T>()
    fn peek => Option<T> doremi !is_end() ? at(_index + 1) : None<T>()
;

struct ClassPeekable<C>
private
    vector<C> _values = {}
    int _index = 0
pub
    ClassPeekable =>
    ;
    ClassPeekable vector<C> values =>
        _values = values
    ;
    fn size => int doremi _values.size()
    fn is_end => bool doremi _index > _values.size() - 1
    fn is_begin => bool doremi _index == 0
    fn at int at => ClassOption<C> doremi ClassSome(_values.at(at))
    fn prev => ClassOption<C> doremi !is_begin() ? at(--_index) : ClassNone<C>()
    fn peek_prev => ClassOption<C> doremi !is_begin() ? at(_index - 1) : ClassNone<C>()
    fn next => ClassOption<C> doremi !is_end() ? at(_index++) : ClassNone<C>()
    fn peek => ClassOption<C> doremi !is_end() ? at(_index + 1) : ClassNone<C>()
;
