inc => vector, iostream
use => std
fn any<T> T value, vector<T> values => bool
    for i until values.size()
        if value == values.at(i) doremi 1
    ;
    return 0
;
fn all<T> T value, vector<T> values => bool
    for i until values.size()
        if value != values.at(i) doremi 0
    ;
    return 1
;
fn none<T> T value, vector<T> values => bool
    for i until values.size()
        if value == values.at(i) doremi 0
    ;
    return 1
;
fn over<T> T value, vector<T> values => bool
    for i until values.size()
        if value == values.at(i) doremi 0
        if value < values.at(i) doremi 0
    ;
    return 1
;
fn under<T> T value, vector<T> values => bool
    for i until values.size()
        if value == values.at(i) doremi 0
        if value > values.at(i) doremi 0
    ;
    return 1
;
