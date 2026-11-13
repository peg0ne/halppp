get => ../lib/print
inc => vector, map, set, list

struct Item
    string name
    int qty = 1
;

class Registry
pub
    static int created = 0
    static fn make string n => Item
        created++
        return Item{n, 2}
    ;
;

fn bump int &x => do x++
fn fill vector<int> *v, int n => do for i until n do v->push_back(i)
fn total vector<Item> const &items => int
    let t = 0
    foreach it in items do t += it.qty
    return t
;

fn main =>
    int a = 1
    bump(a)
    println(a)
    vector<int> v = {}
    fill(&v, 4)
    println(v.size())
    vector<Item> items = {}
    items.push_back(Registry::make("x"))
    items.push_back(Item{"y", 5})
    println($"{total(items)} {Registry::created}")
    map<string, int> m = {}
    m["one"] = 1
    m["two"] = 2
    // foreach works on containers without .at(i)
    foreach kv in m do println($"{kv.first}={kv.second}")
    set<int> uniq = {3, 1, 3, 2}
    foreach i, u in uniq
        if u == 2 do continue
        println($"{i}:{u}")
    ;
    list<string> words = {"a", "b"}
    foreach w in words do print(w)
    println("")
    // growing a vector while looping over it still visits the new items
    vector<int> work = {1}
    foreach w in work
        if w < 4 do work.push_back(w + 1)
    ;
    println(work.size())
    int* p = new int(7)
    println(*p)
    delete p
    let s = string("abc")
    println(s == "abc" ? "same" : "diff")
    let neg = -a + 3
    println(neg)
    let x = 10
    x -= 3
    x *= 2
    println(x % 5)
    println(a != 2 || x > 0)
;
