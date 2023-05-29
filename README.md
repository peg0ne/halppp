# HALPPP - basically halp++

halppp compiles to c++ and is inspired by c#/c++/python/rust and probably some more.
It's experimental language that removes/reduce alot of the common tokens that's mandatory in alot of languages.
Such as...
- `{}`
- `()`
- `;`

Since it compiles to c++ you can do pretty much anything with it and explore it's capabilities.
I really haven't got to formatting the documentation of the language yet. But it's in the works...
There's alot of interesting features that's probably very confusing to see first time. like the `do/dore/dobr/doco/doremi` and `select`

# Examples
Hello world
```
get => print

//fn main always have the `int argc` and `char** argv` arguments available 
//it's just not necessary to add it into the function parameters
fn main =>
    println("Hello World!")
;
```

How a class/struct looks like
```
class ClassName
    string _name = ""
    int _a
    ClassName int a =>
        _a = a
        _name = "ClassName"
    ;
pub
    fn sum int b => int
        return _a + b
    ;
    fn set_name string name => do _name = name
;
```

Here's some stuff that show some features

# complex operators
- [=|=] Any Equals
```
if x =|= (1 : 2 : 3) 
same as
if x == 1 || x == 2 || x == 3
```
- [=&=] All Equals
```
if x =&= (1 : 2 : 3)
same as
if x == 1 && x == 2 && x == 3
```
- [=!=] All Not Equals
```
if x =!= (1 : 2 : 3)
same as
if x != 1 && x != 2 && x != 3
```
- [=>=] All More Than
```
if x =>= (1 : 2 : 3)
same as
if x > 1 && x > 2 && x > 3
```
- [=<=] All Less Than
```
if x =<= (1 : 2 : 3)
same as
if x < 1 && x < 2 && x < 3
```

# Lambda declarations / Anonymous functions
```
> <id> <captured values> (<parameters>)
    code...
    code...
    code...
;
//or
> <id> <captured values> (<parameters>) do/doremi code...

let a = 1
let b = 2
let c = 3
> sum a, b (int n) doremi a + b + n
println(sum(c))
//or
> sum a, b, c () doremi a + b + n
println(sum())
//or
> sum (int a, int b, int c) doremi a + b + n
println(sum(a,b,c))
```

# Extend classes (useful for larger classes)
```
get => print
class A
    int val = 0
    extend => A/hello
;

fn main =>
    let a = A()
    a.hello()
;

//file A/hello.ha
fn hello => do println($"hello world {val}")
```
