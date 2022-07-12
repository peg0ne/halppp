use => std

struct Option<T>
private
    T _value
    bool _forced_none = true
pub
    fn is_none => bool doremi &_value == nullptr || _forced_none
    fn is_some => bool doremi !is_none()
    fn value_or T value => T doremi is_some() ? _value : value
    fn to_string => string doremi is_some() ? "Some(" + std::to_string(_value) + ")" : "None"
    Option => 
        _forced_none = true
    ;
    Option T val =>
        _value = val
        _forced_none = false
    ;
;

fn Some<T> T value => Option<T> doremi Option<T>(value)
fn None<T> => Option<T> doremi Option<T>()


struct ClassOption<C>
private
    C _value
    bool _forced_none = true
pub
    fn is_none => bool doremi &_value == nullptr || _forced_none
    fn is_some => bool doremi !is_none()
    fn value_or C value => C doremi is_some() ? _value : value
    fn to_string => string doremi is_some() ? "Some(" + std::to_string(_value) + ")" : "None"
    ClassOption => 
        _forced_none = true
    ;
    ClassOption C val =>
        _value = val
        _forced_none = false
    ;
;

fn ClassSome<C> C value => ClassOption<C> doremi ClassOption<C>(value)
fn ClassNone<C> => ClassOption<C> doremi ClassOption<C>()