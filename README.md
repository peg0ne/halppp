# HALPPP - basically halp++

# Documentation
[WIP Documentation](https://peg0ne.github.io/halppp-documentation/)
# Text editor included
[Hide](https://github.com/peg0ne/halppp/tree/main/hide)

halppp compiles to c++ and is inspired by c#/c++/python/rust and probably some more.
It's experimental language that removes/reduce alot of the common tokens that's mandatory in alot of languages.
Such as...
- `{}`
- `()`
- `;`

Since it compiles to c++ you can do pretty much anything with it and explore it's capabilities.
I really haven't got to formatting the documentation of the language yet. But it's in the works...
There's alot of interesting features that's probably very confusing to see first time. like the `do/dore/dobr/doco/doremi` and `select`

# Installing
Requirements: [Rust/cargo](https://rustup.rs) (only to bootstrap) and a g++-compatible C++17 compiler
(g++ on Linux, clang++ from the Xcode command line tools on macOS, [MinGW-w64](https://www.msys2.org) on Windows).

## Linux / macOS
```bash
git clone https://github.com/peg0ne/halppp.git
# install compiler
cd halppp/compiler
./rebuild.sh
cp main $HOME/.local/bin/halppp
# install "build tool"
cd ../hamble
halppp main.ha -r
cp main $HOME/.local/bin/hamble++
# install texteditor (needs ncurses)
cd ../hide
hamble++ build -r
hamble++ do make
```

## Windows (PowerShell)
Install [MSYS2](https://www.msys2.org), then in an MSYS2 MinGW64 shell:
```bash
pacman -S mingw-w64-x86_64-gcc mingw-w64-x86_64-pdcurses
```
and add `C:\msys64\mingw64\bin` to your PATH. PDCurses stands in for ncurses on Windows,
so `lib/ncurses.ha` (and `hamble man`) work there too.
```powershell
git clone https://github.com/peg0ne/halppp.git
cd halppp\compiler
.\rebuild.ps1
# put compiler\main.exe on your PATH as halppp.exe
# install "build tool"
cd ..\hamble
halppp main.ha -r
# put hamble\main.exe on your PATH as hamble++.exe
```
`hide` still relies on Linux tools (xclip, tree-sitter, a POSIX shell) and is not supported on Windows.

## Configuration
| Environment variable | Default | Purpose |
| --- | --- | --- |
| `HALPPP_CXX` (or `CXX`) | `clang++` on macOS, `g++` elsewhere | C++ compiler used to build the generated code (must accept g++-style flags) |
| `HALPPP_LIB` | `~/.local/lib/halppp` (`%USERPROFILE%\.local\lib\halppp` on Windows) | Where `get` looks for installed libraries |
| `HALPPP_JOBS` | number of CPU cores | How many C++ files to compile in parallel |
| `HALPPP_PCH` | on | Set to `0` to not precompile the shared header |

## Incremental builds
`halppp main.ha` only recompiles what changed. Every `.ha` file becomes its own C++ file in
`.halppp-cache/<name>-<debug|release>/` next to `main.ha`, all sharing one generated `program.h`
(includes, types, class layouts, function declarations). Function and method bodies live in their
file's own `.cpp`, so editing them only recompiles that one file and relinks.
Changing what goes in `program.h` (a signature, a class field, a template, a new import) recompiles
everything, with the header precompiled once so that is about as fast as a full build used to be.

| Flag | Effect |
| --- | --- |
| `-r` | release build (`-O3`), cached separately from debug builds |
| `-t` | only transpile to a single `main.cpp`, don't compile |
| `-s` | build the old way: one single C++ file, no cache (whole-program optimisation for releases) |

Add `.halppp-cache/` to your `.gitignore` (`hamble++ init` does this for you).

## Platform-specific compiler flags
`compiler =>` passes a flag to the C++ compiler. Name platforms (`linux`, `macos`, `windows`) to only pass it there:
```
compiler => "-pthread"
compiler linux => "-lncursesw"
compiler macos => "-lncurses"
compiler windows => "-lpdcurses"
```
Top-level `raw` lines are placed with the `#include`s, so a library can pick headers per platform with `#ifdef`.

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
if x =|= 1 : 2 : 3)
same as
if x == 1 || x == 2 || x == 3
```
- [=&=] All Equals
```
if x =&= 1 : 2 : 3
same as
if x == 1 && x == 2 && x == 3
```
- [=!=] All Not Equals
```
if x =!= 1 : 2 : 3
same as
if x != 1 && x != 2 && x != 3
```
- [=>=] All More Than
```
if x =>= 1 : 2 : 3
same as
if x > 1 && x > 2 && x > 3
```
- [=<=] All Less Than
```
if x =<= 1 : 2 : 3
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

# Tests
`tests/run.sh` builds every `tests/*.ha` both as a single file (`-s`) and incrementally, runs it,
and compares the output with `tests/expected/<name>.out`. Pass another compiler as the first
argument (`tests/run.sh path/to/halppp`) and test names after it to run only those.
`UPDATE=1 tests/run.sh` rewrites the expected files after an intended change in output.
Files in `tests/errors/` must fail to compile, and the compiler output must contain every
`// expect: <text>` line written in them.

Errors from the C++ compiler point at the `.ha` file and line they came from (via `#line`).
