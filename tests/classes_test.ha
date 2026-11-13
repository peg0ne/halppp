get => ../lib/print
inc => vector

struct Point
    int x = 0
    int y = 0
    Point => do return
    Point int x, int y =>
        this->x = x
        this->y = y
    ;
    fn + Point o => Point doremi Point(x + o.x, y + o.y)
    fn == Point o => bool doremi x == o.x && y == o.y
    fn len_sq => int doremi x * x + y * y
;

class Shape
pub
    string name = "shape"
    virtual fn area => int doremi 0
    fn describe => string doremi $"{name} area={area()}"
;

class Rect => Shape
pub
    int w
    int h
    Rect int w, int h =>
        this->w = w
        this->h = h
        name = "rect"
    ;
    fn area => int doremi w * h
;

class Square => Rect
pub
    Square int s => Rect(s, s)
        name = "square"
    ;
;

class Labeled
pub
    string label
    int size
    Labeled string l => label(l), size(l.size()) do return
;

class Counter
private
    int _count = 0
pub
    fn inc => Counter* 
        _count++
        return this
    ;
    fn get => int doremi _count
;

class Stack<T>
private
    vector<T> _items = {}
pub
    fn push T item => do _items.push_back(item)
    fn pop => T
        T top = _items.back()
        _items.pop_back()
        return top
    ;
    fn size => int doremi _items.size()
;

fn biggest<T> T a, T b => T doremi a > b ? a : b

fn main =>
    let a = Point(1, 2)
    let b = Point(3, 4)
    let c = a + b
    println($"{c.x},{c.y} len_sq={c.len_sq()}")
    println(c == Point(4, 6) ? "equal" : "different")
    let r = Rect(2, 3)
    println(r.describe())
    let s = Square(4)
    println(s.describe())
    Shape* shape = &s
    println($"virtual {shape->area()}")
    let counter = Counter()
    counter.inc()->inc()->inc()
    println($"count {counter.get()}")
    let st = Stack<string>()
    st.push("a")
    st.push("b")
    let top = st.pop()
    let next = st.pop()
    println($"{top}{next} left={st.size()}")
    let lab = Labeled("hello")
    println($"{lab.label} {lab.size}")
    println(biggest(3, 9))
    println(biggest<string>("pear", "apple"))
;
