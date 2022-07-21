inc => vector, iostream
use => std
fn any<T> T value, vector<T> values => bool
    foreach val in values
        if value == val doremi true
    ;
    return false
;
fn all<T> T value, vector<T> values => bool
    foreach val in values
        if value != val doremi false
    ;
    return true
;
fn none<T> T value, vector<T> values => bool
    foreach val in values
        if value == val doremi false
    ;
    return true
;
fn over<T> T value, vector<T> values => bool
    foreach val in values
        if value == val doremi false
        if value < val doremi false
    ;
    return true
;
fn under<T> T value, vector<T> values => bool
    foreach val in values
        if value == val doremi false
        if value > val doremi false
    ;
    return true
;
fn any_less<T> T value, vector<T> values => bool
    foreach val in values
        if value > val doremi true
    ;
    return false
;