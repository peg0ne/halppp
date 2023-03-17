# List

## Introduction

The `List` class is a implementation of a generic list data structure. It provides methods for adding, removing, and accessing elements in the list.

## Class Definition

### Constructors

-   `List<T>()`: Constructs an empty list.
-   `List(vector<T> list)`: Constructs a list from a vector.

### Public Methods

-   `at(int index) -> T`: Returns the element at the given index in the list.
-   `at_ptr(int index) -> T*`: Returns a pointer to the element at the given index in the list.
-   `set(int index, T value)`: Sets the value of the element at the given index in the list.
-   `first() -> Option<T>`: Returns an `Option` containing the first element in the list, or `None` if the list is empty.
-   `last() -> Option<T>`: Returns an `Option` containing the last element in the list, or `None` if the list is empty.
-   `begin() -> auto`: Returns an iterator pointing to the first element in the list.
-   `end() -> auto`: Returns an iterator pointing to the past-the-end element in the list.
-   `len() -> int`: Returns the number of elements in the list.
-   `size() -> int`: Alias for `len()`.
-   `add(T element)`: Adds an element to the end of the list.
-   `pop()`: Removes the last element from the list.
-   `clear()`: Removes all elements from the list.
-   `as_vec_ptr() -> vector<T>*`: Returns a pointer to the underlying vector.
-   `insert(int index, T element)`: Inserts an element at the given index in the list.
-   `remove(int index)`: Removes the element at the given index from the list.

### Public Static Methods

-   `to_string(List<T> list) -> string`: Returns a string representation of the list.

## Example Usage

```cpp
get => list

fn main =>
    let list = List({1, 2, 3})
    println($"list: {list}")
    list.add(4)
    println($"list: {list}")
    list.insert(2, 5)
    println($"list: {list}")
    list.remove(1)
    println($"list: {list}")
;
```

Output:

```
list: 3 : [1,2,3,]
list: 4 : [1,2,3,4,]
list: 5 : [1,2,5,3,4,]
list: 4 : [1,5,3,4,]

```
