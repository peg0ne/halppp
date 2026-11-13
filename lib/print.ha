inc => iostream
use => std
// boolalpha: bools print as true/false, like they do in $"{...}"
fn print<T> T s => do cout << boolalpha << s
fn println<T> T s => do cout << boolalpha << s << "\n"
