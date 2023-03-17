## Json Documentation

### `load_json(string path) => Json`

This function loads a JSON file located at `path` and returns its content as a `Json` object. If the file cannot be read, an empty `Json` object is returned.

### `write_json(string path, Json content)`

This function writes the given `content` (which must be a JSON object) to a file located at `path`. If the file cannot be written to, no action is taken.

## Json class

The `Json` class is a C++ implementation of JSON (JavaScript Object Notation) data structure. It can be used to parse and create JSON strings, as well as manipulate JSON objects and arrays.

### Constructor

-   `Json()`: creates an empty JSON object.
-   `Json(string json_string)`: creates a JSON object by parsing a JSON string.
-   `Json(string id, JsonType type)`: creates a JSON object with the given id and type.
-   `Json(string id, string value)`: creates a JSON object with the given id and string value.
-   `Json(string id, int value)`: creates a JSON object with the given id and integer value.
-   `Json(string id, float value)`: creates a JSON object with the given id and floating point value.
-   `Json(string id, double value)`: creates a JSON object with the given id and double precision value.
-   `Json(string id, bool value)`: creates a JSON object with the given id and boolean value.
-   `Json(string id, vector<Json*> values, JsonType type)`: creates a JSON object with the given id, type, and vector of child JSON objects.

### Public methods

-   `add(Json* value)`: adds a child JSON object to the current object.
-   `add<T>(T value)`: adds a child JSON object with the given value to the current object.
-   `try_add<T>(string name, T value)`: tries to add a child JSON object with the given name and value to the current object. If an object with the same name already exists, it does nothing.
-   `value_or(double value)`: returns the double value of the current object if it is a number, otherwise returns the given default value.
-   `value_or(string value)`: returns the string value of the current object if it is a string, otherwise returns the given default value.
-   `value_or(bool value)`: returns the boolean value of the current object if it is a boolean, otherwise returns the given default value.
-   `size()`: returns the number of child JSON objects in the current object.
-   `pop()`: removes the last child JSON object from the current object.
-   `try_get_value_of<T>(string name, T value)`: tries to get the value of the child JSON object with the given name and cast it to the given type. If the object is not found or cannot be cast to the given type, it returns the given default value.
-   `try_get(int at)`: tries to get the child JSON object at the given index. If the current object is not an array, or the index is out of bounds, it returns `None<Json*>()`.
-   `try_get(string name)`: tries to get the child JSON object with the given name. If the current object is not an object, or the name is not found, it returns `None<Json*>()`.
-   `name()`: returns the name of the current object.
-   `type()`: returns the type of the current object as a `JsonType` enum.
-   `type_as_str()`: returns the type of the current object as a string.
-   `value_as_str()`: returns the value of the current object as a string.
-   `as_j_str(bool add_name)`: returns the current object as a JSON string. If `add_name` is true, it includes the object name in the output.

### Private methods

-   `as_j_str()`: returns the current object as a JSON string.

### Destructor

-   `destruct()`: recursively destroys all child JSON objects and frees the memory.

## JsonType

The `JsonType` enum defines the different types that can be represented in a JSON object.

## Members

### `Boolean`

Represents a boolean value (`true` or `false`).

### `Array`

Represents an ordered list of values.

### `Number`

Represents a numeric value.

### `Object`

Represents an unordered collection of key-value pairs.

### `String`

Represents a string of characters.
