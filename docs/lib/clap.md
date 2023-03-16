## Documentation for Clap Struct

### `struct Clap`

This is a struct that represents command-line arguments. It contains the following properties:

-   `_argc`: an integer representing the number of arguments passed in the command line.
-   `_argv`: a pointer to an array of strings representing the command line arguments.

#### `private`

This section indicates that the following properties or methods are private, meaning they cannot be accessed outside of the struct.

-   `_argc`: an integer representing the number of arguments passed in the command line.
-   `_argv`: a pointer to an array of strings representing the command line arguments.

#### `pub`

This section indicates that the following properties or methods are public, meaning they can be accessed outside of the struct.

#### `fn has string check => bool`

This method checks if the specified string `check` is present in the command line arguments. It takes one argument:

-   `check`: a string to search for in the command line arguments.

It returns a boolean value indicating whether the specified string was found in the command line arguments.

#### `fn peek string check => Option<string>`

This method returns an `Option` object containing the string value that follows the specified string `check` in the command line arguments. It takes one argument:

-   `check`: a string to search for in the command line arguments.

If the specified string is found in the command line arguments, this method returns an `Option` object containing the string value that immediately follows it. If the specified string is not found or if it is the last argument in the command line, this method returns an empty `Option` object.

#### `Clap int argc, char **argv =>`

This constructor creates a new `Clap` object with the specified arguments. It takes two arguments:

-   `argc`: an integer representing the number of arguments passed in the command line.
-   `argv`: a pointer to an array of strings representing the command line arguments.

It sets the `_argc` and `_argv` properties of the `Clap` object based on the arguments provided.
