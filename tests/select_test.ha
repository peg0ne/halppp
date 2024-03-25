get => ../lib/[print, option]

fn main =>
    let b = Some(1)
    let c = Some(2)
    let d = Some(3)
    select a from b doremi a
    select c from b doremi c
    select d from c do b
    select a from d
        select a from b doremi a
        select c from b doremi c
        select d from c do b
        select a from d
            println("Hello")
        ;
    ;
;
