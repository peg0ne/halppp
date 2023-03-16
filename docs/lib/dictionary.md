# Dictionary<T,U>

A class representing a dictionary data structure. It associates keys with values of possibly different types. The keys must be unique.

## Type parameters

-   `T`: the type of the keys.
-   `U`: the type of the values.

## Methods

-   `keys() -> vector<T>`: returns a vector containing all the keys in the dictionary.
-   `contains(key: T) -> bool`: returns `true` if the specified key is in the dictionary, `false` otherwise.
-   `remove(key: T) -> void`: removes the key and its associated value from the dictionary.
-   `add(key: T, value: U) -> void`: adds the key and its associated value to the dictionary. If the key is already in the dictionary, nothing happens.
-   `set(key: T, value: U) -> void`: changes the value associated with the specified key. If the key is not in the dictionary, nothing happens.
-   `try_get_value(key: T) -> Option<U>`: returns an `Option` containing the value associated with the specified key, or `None` if the key is not in the dictionary.
-   `try_get_value_ptr(key: T) -> Option<&U>`: returns an `Option` containing a reference to the value associated with the specified key, or `None` if the key is not in the dictionary.
-   `steal(other: Dictionary<T, U>) -> void`: moves all the keys and values from the other dictionary to this one. If a key is already in this dictionary, its associated value is replaced by the one from the other dictionary.

## Example

```rust
get => dictionary

let dict = Dictionary<string, int>()
dict.add("one", 1)
dict.add("two", 2)
dict.add("three", 3)

let keys = dict.keys();
foreach key in keys
    select value from dict.try_get_value(key)
        println($"{key}, {value}")
    ;
;

dict.set("one", 10)
select value from dict.try_get_value("one")
    println($"New value of 'one': {value}")
;

dict.remove("two")

let other_dict = Dictionary<string, int>()
other_dict.add("four", 4)
other_dict.add("five", 5)
dict.steal(other_dict)
select value from dict.try_get_value("four")
    println($"Value of 'four' after steal: {value}")
;
```
