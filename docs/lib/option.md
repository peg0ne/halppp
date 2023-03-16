# Option<T> Struct Documentation

A generic struct that represents an optional value of type `T`.

## Properties

-   `T _value`: The value of the `Option`.
-   `bool _forced_none`: A flag that indicates if the `Option` is forced to be `None`.

## Public Methods

-   `fn is_none() -> bool`: Returns a boolean that indicates if the `Option` is `None`.
-   `fn is_some() -> bool`: Returns a boolean that indicates if the `Option` is `Some`.
-   `fn value_or(T value: T) -> T`: Returns the value of the `Option` if it is `Some`, otherwise returns the specified default value.
-   `fn value_unsafe() -> T`: Returns the value of the `Option` if it is `Some`. This method is unsafe and should be used with caution.
-   `fn to_string() -> string`: Returns a string representation of the `Option`.

## Constructors

-   `Option()`: Constructs a `None` `Option`.
-   `Option(T val: T)`: Constructs a `Some` `Option` with the specified value.

## Functions

-   `fn Some(T value: T) -> Option<T>`: Constructs a `Some` `Option` with the specified value.
-   `fn None<T>() -> Option<T>`: Constructs a `None` `Option`.
