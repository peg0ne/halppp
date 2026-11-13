get => ../lib/print

fn classify int n => string
    if n < 0 doremi "negative"
    elif n == 0 doremi "zero"
    elif n < 10 doremi "small"
    else doremi "big"
;

fn first_over int limit => int
    let i = 0
    loop
        i++
        if i * i > limit do break
    ;
    return i
;

fn sum_odd int n => int
    let total = 0
    for i until n
        if i % 2 == 0 do continue
        total += i
    ;
    return total
;

fn count_to int n => do for i until n do print(i)

fn main =>
    println(classify(-5))
    println(classify(0))
    println(classify(7))
    println(classify(42))
    println(first_over(50))
    println(sum_odd(10))
    // while with a block body
    int k = 10
    let steps = 0
    while k > 1
        k = k % 2 == 0 ? k / 2 : 3 * k + 1
        steps++
    ;
    println($"collatz steps {steps}")
    // one-line do/dore/dobr/doco forms
    let hits = 0
    for i until 20
        if i == 15 dobr hits += 100
        if i % 3 != 0 doco hits += 0
        hits++
    ;
    println($"hits {hits}")
    // nested loops with break only leaving the inner one
    let pairs = 0
    for a until 4
        for b until 4
            if b > a do break
            pairs++
        ;
    ;
    println($"pairs {pairs}")
    // ternaries and logical operators
    let flag = pairs > 5 && hits > 100 || false
    println(flag ? "yes" : "no")
    // switch with fallthrough cases and default
    for v until 5
        switch v
        case 0
        case 1 dobr println("low")
        case 2 dobr println("two")
        default dobr println("high")
        ;
    ;
    // a do can be followed by another statement
    count_to(4)
    println("")
    if pairs > 1 do for i until 3 do print(i)
    println("")
    for i until 3 do if i == 2 do println("two again")
    let w = 0
    while w < 4 do for j until 2 do w++
    println(w)
;
