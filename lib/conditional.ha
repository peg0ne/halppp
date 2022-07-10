inc => vector, iostream
use => std
fn any<T> T value, vector<T> values => bool
    for i until values.size()
        if value == values.at(i) doremi true
    ;
    return false
;
fn all<T> T value, vector<T> values => bool
    for i until values.size()
        if !(value == values.at(i)) doremi false
    ;
    return true
;
fn none<T> T value, vector<T> values => bool
    for i until values.size()
        if value == values.at(i) doremi false
    ;
    return true
;
fn over<T> T value, vector<T> values => bool
    for i until values.size()
        if value == values.at(i) doremi false
        if value < values.at(i) doremi false
    ;
    return true
;
fn under<T> T value, vector<T> values => bool
    for i until values.size()
        if value == values.at(i) doremi false
        if value > values.at(i) doremi false
    ;
    return true
;
