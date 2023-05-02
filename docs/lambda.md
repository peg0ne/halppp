# Lambda Functions

Lambda functions are anonymous functions that can be defined inline and passed around as values. They can be used to define a block of code that can be executed at a later time, or to pass a block of code as an argument to another function.

In this language, you can define a lambda function using the following syntax:

```c++
> <lambda_name> <captured variables>... (<parameters>...) doremi <expression> //oneline variant
//or
> <lambda_name> <captured variables>... (<parameters>...) //multiline variant
     return <expression>
;
```

## Example

```c++
let a = 0
> is_a a (int value) doremi value == a

println(is_a(10)) //false
println(is_a(0)) //true
```
