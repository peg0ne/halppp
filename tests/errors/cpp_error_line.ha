// g++ errors point at the .ha line, not the generated C++
// expect: cpp_error_line.ha:9:
// expect: cpp_error_line.ha:13:
// expect: 'no_such_method'
fn main =>
    let a = 1
    if a > 0
        a += 1
        a.no_such_method()
    ;
    let s = match a
        1 => do 1
        2 => do "two"
        _ => do 0
    ;
;
