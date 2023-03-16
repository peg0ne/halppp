# Documentation for print and println functions

This module includes two functions: `print` and `println`. Both functions are used for printing output to the console.

## Usage

To use the `print` function, call it with a single argument of any type `T` that has a defined `<<` operator for the `std::ostream` type. The `print` function will print the argument to the console.

Example:

```cpp
print(42); // prints "42"
```

The `println` function is similar to `print`, but adds a newline character `(\n)` to the end of the output.

Example:

```cpp
println("Hello, world!"); // prints "Hello, world!\n"
```

Parameters

-   `s`: The argument to be printed. It can be of any type `T` that has a defined `<<` operator for the `std::ostream` type.

## Return Value

Both functions return `void`, so there is no return value.

## Dependencies

The `print` and `println` functions depend on the following libraries:

-   `iostream`
-   `std`
