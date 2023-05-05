# Select

The `select` feature is used to extract a value from an optional variable and perform an action with that value. The syntax for using the `select` feature is as follows:

```csharp
let value_opt = Some(value)
select value from value_opt
    <action>
    ...
    <action>
;
// or
select value from value_opt do/dore/doco/dobr/doremi <action>
```

In this syntax, `value_opt` is an optional variable that may or may not contain a value. If `value_opt` does contain a value, that value is extracted and assigned to `value`.

The `<action>` placeholder is where you can put any code you'd like to execute with the extracted value. For example, you could print the value to the console using `println(value)`.

Note that if `value_opt` does not contain a value (i.e., it is `None`), the `select` statement will not execute the `<action>` code. Instead, it will simply skip over the entire `select` block.

### Example Usage

Here's an example of how you might use the `select` feature in your code:

```csharp
let value_opt = Some(42)
select value from value_opt
    println(value)
; // Output: 42

let empty_opt = None<int>()
select value from empty_opt
    println(value)
; // No output (because `empty_opt` is `None`)

```

In this example, the first `select` block will execute the `println(value)` statement because `value_opt` contains a value (specifically, the value 42). The second `select` block will not execute any code because `empty_opt` does not contain a value
