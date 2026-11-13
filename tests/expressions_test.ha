get => ../lib/[print, option]
inc => vector

enum Color
    Red,
    Green,
    Blue,
;

fn name_of int n => string
    let r = match n
        0 => do "zero"
        1 =>
            let s = "o"
            s + "ne"
        ;
        < 0 => do "negative"
        =|= 2 : 3 => do "two-or-three"
        _ => do "many"
    ;
    return r
;

fn sign int n => int
    return match n
        < 0 => do -1
        0 => do 0
        _ =>
            let one = 1
            one
        ;
    ;
;

fn half int n => Option<int>
    if n % 2 != 0 doremi None<int>()
    return Some(n / 2)
;

fn main =>
    // enums print their name in interpolation
    let c = Color::Green
    println($"color {c}")
    println($"{Color::Red} {Color::Blue}")
    foreach n in vector<int>{-4, 0, 1, 2, 3, 9} do println(name_of(n))
    println($"{sign(-7)} {sign(0)} {sign(7)}")
    // select only runs its block when the option has a value
    select h from half(10) do println($"half {h}")
    select h from half(7) do println("never")
    let quarter = half(8)
    select q from quarter
        select qq from half(q) do println($"quarter {qq}")
    ;
    println(half(3).value_or(-1))
    // lambdas capture variables and take parameters
    let base = 10
    > add_base base (int v) doremi base + v
    println(add_base(5))
    > clamp (int v, int lo, int hi)
        if v < lo doremi lo
        if v > hi doremi hi
        return v
    ;
    println($"{clamp(-3, 0, 5)} {clamp(3, 0, 5)} {clamp(30, 0, 5)}")
    // interpolation: expressions, nested quotes, escapes, literal braces
    let items = vector<string>{"x", "y"}
    println($"{items.size()} items, first=\"{items[0]}\" sum={1 + 2 * 3}")
    println($"{{literal}} and {base}")
    println($"{base > 5 ? "big" : "small"}")
    // chars and escapes
    char q = '\''
    println(q)
    println("tab\tend")
    // chars interpolate as themselves and bools as true/false
    char letter = 'z'
    let yes = 3 > 2
    println($"{letter} {yes} {!yes} {"lit"}")
    println(yes)
;
