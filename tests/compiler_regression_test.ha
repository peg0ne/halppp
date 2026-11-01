get => ../lib/print
inc => map, vector

enum Color
    Red,
    Green,
    Blue
;

class Counter
pub
    static int count = 0
    static const int LIMIT = 10
    Counter => do count++
;

fn nested => vector<vector<int>>
    vector<vector<int>> v = {{1, 2}}
    return v
;

fn main =>
    // identifiers containing digits
    int x2 = 3
    let var1 = x2 + 1
    // string interpolation with quotes inside the braces
    map<string,int> m = {}
    m["k"] = 2
    println($"{var1} {m["k"]}")
    // comparisons are not typed after their first literal
    let same = "abc" == "abc"
    println($"{same}")
    // last enum member without trailing comma
    let c = Color::Blue
    // advanced conditions with multi-token operands
    if c =|= Color::Red : Color::Blue do println("any-equals ok")
    if var1 =!= var1 - 1 : var1 + 1 do println("all-not-equals ok")
    // static members with initialisers
    let a = Counter()
    let b = Counter()
    println($"{Counter::count} {Counter::LIMIT}")
    // nested template return types
    println($"{nested()[0].size()}")
    // match: default as first arm, advanced conditional arms
    match var1
        _ => do println("default-first ok")
    ;
    match var1
        =|= 1 : 4 => do println("match any-equals ok")
        _ => do println("match bad")
    ;
    // negative case labels
    int n = -1
    switch n
    case -1 dobr println("negative case ok")
    default do break
    ;
;
