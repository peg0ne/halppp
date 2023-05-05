# Match

The `match` statement is a powerful control flow feature that allows you to `match` the value of a variable against multiple patterns and execute different code blocks depending on the matching pattern.

## Syntax

```rust
match variable
    pattern_1 => do code_block_1
    pattern_2 => do code_block_2
    ...
    pattern_n =>
        code_block_n
        code_block_n
        code_block_n
    ;
    _ => do default_code_block
;
```

The `match` statement takes an expression `variable` that is matched against one or more patterns. Each pattern is separated by a `=>` symbol, followed by a code block that will be executed if the pattern matches the value of the variable.

The patterns can be any expression, but the most common types are literals (such as `0`, `"hello"`, or `true`), variable names, or wildcards (`_`), which match any value.

The last pattern in the `match` statement is a wildcard pattern (`_`) that matches any value not already matched by the previous patterns. This pattern is optional but is usually included to handle unexpected values.

### Example

```rust
let a = 0
match a
    0 => do println("ZERO")
    1 => do println("ONE")
    2 =>
        println("TWO")
        return
    ;
    _ =>
        println("Unknown")
        return
    ;
;
```

This code block shows an example of how to use the `match` statement. Here, we define a variable a with a value of `0`, and we use the `match` statement to match the value of a against multiple patterns.

In this case, the first pattern `0` matches the value of `a`, so the code block do `println("ZERO")` is executed. If the value of a were `1`, the code block do `println("ONE")` would be executed instead. If the value of `a` were `2`, the code block `println("TWO")` would be executed, and the function would return immediately.

If the value of a were anything other than `0`, `1`, or `2`, the last pattern `_` (wildcard) would match, and the code block `println("Unknown")` would be executed.

Note that each code block is terminated with a semicolon ; or by using the inline `do`/`dore`/`dobr`/`doco`/`doremi`. This is optional for the last code block but is required for all other code blocks.

You can also assign the result of the match statement to a variable, as shown in this example:

### Example

```rust
let a = 0
let b = match a
    0 => do "zero"
    1 => do "one"
    2 =>
        println("TWO")
        "two"
    ;
    _ =>
        println("Unknown")
        "unknown"
    ;
;
//or like this
let b = ""
b = match a
    0 => do "zero"
    1 => do "one"
    2 =>
        println("TWO")
        "two"
    ;
    _ =>
        println("Unknown")
        "unknown"
    ;
;
```
