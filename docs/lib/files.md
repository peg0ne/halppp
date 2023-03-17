# Documentation of `files` library

## Dependencies

The following dependencies are required:

-   fstream
-   stdlib.h
-   vector
-   dirent.h
-   algorithm
-   unistd.h
-   sys/stat.h

## Functions

### `read(string path) -> Option<string>`

Reads the contents of a file at the given path and returns it as a `string`. If the file does not exist or could not be opened, returns `None`.

### `readlines(string path) -> vector<string>`

Reads the contents of a file at the given path and returns each line as a separate `string` in a `vector`. If the file does not exist or could not be opened, returns an empty `vector`.

### `write(string content, string path) -> void`

Writes the given `content` to a file at the given `path`. If the file does not exist, it is created. If it does exist, its contents are overwritten.

### `system(string command) -> bool`

Runs the given `command` in the system shell and returns `true` if the command executed successfully, or `false` if it did not.

### `system_output(string command) -> vector<string>`

Runs the given `command` in the system shell and returns the output of the command as a `vector` of `string`s, one for each line of output.

### `makedir(string name) -> bool`

Creates a new directory with the given `name` and returns `true` if successful, or `false` if it could not be created.

### `changedir(string name) -> bool`

Changes the current working directory to the directory with the given `name` and returns `true` if successful, or `false` if it could not be changed.

### `env(string env_var) -> Option<string>`

Retrieves the value of the environment variable with the given `env_var` and returns it as a `string`. If the environment variable is not set, returns `None`.

### `list_reg_files(string path) -> vector<string>`

Lists all regular (non-directory) files in the directory at the given `path` and returns their names as a sorted `vector` of `string`s.

### `list_dirs(string path) -> vector<string>`

Lists all directories in the directory at the given `path` and returns their names as a sorted `vector` of `string`s.

### `list_files(string path) -> vector<string>`

Lists all files (including directories) in the directory at the given `path` and returns their names as a sorted `vector` of `string`s.

### `remove(string path) -> void`

Deletes the file at the given `path`. If the file does not exist, does nothing.
