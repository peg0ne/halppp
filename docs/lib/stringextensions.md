## Class String

### Fields

-   `string _value`

### Public Methods

-   `fn to_string() -> string`: returns the string representation of the value.
-   `fn len() -> long`: returns the length of the string.
-   `fn at(int at) -> auto`: returns the character at the specified index.
-   `fn append(string value) -> void`: appends the specified string to the end of the current string.
-   `fn insert(string value, int at) -> void`: inserts the specified string at the specified index.
-   `fn remove_back(int amount) -> void`: removes the specified number of characters from the end of the string.
-   `fn remove(int at) -> void`: removes the character at the specified index.
-   `fn remove_word(int at) -> void`: removes the word at the specified index.
-   `fn remove_word(int at, bool spacebreak) -> void`: removes the word at the specified index, with an option to break at spaces.
-   `fn pop() -> string`: removes and returns the last character of the string.
-   `fn to_upper() -> string`: returns the uppercase version of the string.
-   `fn to_lower() -> string`: returns the lowercase version of the string.
-   `fn strip() -> string`: removes whitespace from the beginning and end of the string.
-   `fn strip(int times) -> string`: removes whitespace from the beginning and end of the string a specified number of times.
-   `fn strip(Option<int> times) -> string`: removes whitespace from the beginning and end of the string a specified number of times, or until no whitespace remains.
-   `fn strip_end() -> string`: removes whitespace from the end of the string.
-   `fn strip_end(int times) -> string`: removes whitespace from the end of the string a specified number of times.
-   `fn strip_end(Option<int> times) -> string`: removes whitespace from the end of the string a specified number of times, or until no whitespace remains.
-   `fn strip_front() -> string`: removes whitespace from the beginning of the string.
-   `fn strip_front(int times) -> string`: removes whitespace from the beginning of the string a specified number of times.
-   `fn strip_front(Option<int> times) -> string`: removes whitespace from the beginning of the string a specified number of times, or until no whitespace remains.
-   `fn replace(string from, string to) -> string`: replaces all occurrences of the specified string with the specified replacement string.
-   `fn replace(string from, string to, int amount) -> string`: replaces up to the specified number of occurrences of the specified string with the specified replacement string.
-   `fn to_num() -> Option<double>`: converts the string to a double, returning `None` if the conversion fails.
-   `fn split() -> vector<string>`: splits the string into a vector of substrings using whitespace as the delimiter.
-   `fn split(char delimiter) -> vector<string>`: splits the string into a vector of substrings using the specified character as the delimiter.
-   `fn split(Option<char> delimiter) -> vector<string>`: splits the string into a vector of substrings using the specified character as the delimiter, or whitespace if no delimiter is provided.

-   `fn contains(string contains) -> bool`: returns true if the string contains the specified substring.
-   `fn starts_with(string start) -> bool`: returns true if the string starts with the specified substring.
-   `fn ends_with(string ends) -> bool`: returns true if the string ends with the specified substring.

-   `fn substr(int start) -> string`: returns the substring starting at the specified index.
-   `fn substr(int start, int end) -> string`: returns the substring starting at the specified index and ending at the specified index.

-   `fn find(int from, string key) -> Option<int>`: searches for the specified substring starting from the specified index and returns the index of the first occurrence, or `None` if not found.
-   `fn find_non_alpha(int from) -> Option<int>`: searches for the first non-alpha character starting from the specified index and returns its index, or `None` if not found.
-   `fn find_non_alpha(int from, bool reverse) -> Option<int>`: searches for the first non-alpha character starting from the specified index in reverse order and returns its index, or `None` if not found.
-   `fn find_alpha(int from) -> Option<int>`: searches for the first alpha character starting from the specified index and returns its index, or `None` if not found.
-   `fn find_alpha(int from, bool reverse) -> Option<int>`: searches for the first alpha character starting from the specified index in reverse order and returns its index, or `None` if not found.

-   `fn escape() -> string`: escapes special characters in the string and returns the result.
-   `fn unescape() -> string`: unescapes special characters in the string and returns the result.
