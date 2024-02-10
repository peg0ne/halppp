fn main =>
    let a = match 1
        < 0 => do -1
        > 1 => do 10
        2 => do 2
        _ => do 3
    ;
;
