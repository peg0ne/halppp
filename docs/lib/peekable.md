The code defines a struct called `Peekable` that allows you to iterate over a sequence of values of type `T` and peek at the next or previous value without advancing the iterator.

The struct has the following methods:

-   `Peekable()`: Constructor that creates a new instance of the `Peekable` struct.
-   `Peekable(vector<T> values)`: Constructor that creates a new instance of the `Peekable` struct with the given sequence of values.
-   `Peekable(string text)`: Constructor that creates a new instance of the `Peekable` struct with the given string.
-   `index() -> int`: Returns the current index of the iterator.
-   `size() -> int`: Returns the number of elements in the sequence.
-   `is_end() -> bool`: Returns `true` if the iterator has reached the end of the sequence.
-   `is_begin() -> bool`: Returns `true` if the iterator is at the beginning of the sequence.
-   `at(int at) -> Option<T>`: Returns the element at the given index, or `None` if the index is out of bounds.
-   `prev() -> Option<T>`: Returns the previous element in the sequence, or `None` if the iterator is at the beginning of the sequence.
-   `peek_prev() -> Option<T>`: Returns the element before the previous element in the sequence, or `None` if the iterator is at the beginning of the sequence.
-   `next() -> Option<T>`: Returns the next element in the sequence, or `None` if the iterator has reached the end of the sequence.
-   `peek() -> Option<T>`: Returns the next element in the sequence without advancing the iterator, or `None` if the iterator has reached the end of the sequence.
