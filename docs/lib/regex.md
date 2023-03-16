## Documentation for RegexMatch Struct

### `struct RegexMatch`

This is a struct that represents a single match of a regular expression. It contains the following properties:

-   `match`: a string representing the matched text.
-   `position`: an integer representing the starting position of the matched text in the input string.

#### `RegexMatch =>`

This constructor creates a new `RegexMatch` object with default values.

#### `RegexMatch string match, int pos =>`

This constructor creates a new `RegexMatch` object with the specified values. It takes two arguments:

-   `match`: a string representing the matched text.
-   `pos`: an integer representing the starting position of the matched text in the input string.

It sets the `match` and `position` properties of the `RegexMatch` object based on the arguments provided.

#### `fn re string line, regex reg, int capture, vector<Vector> claimed => vector<RegexMatch>`

This function searches the specified input string `line` for matches of the specified regular expression `reg`, capturing the group identified by `capture`. It takes three arguments:

-   `line`: a string representing the input to search for matches.
-   `reg`: a regular expression object to use for matching.
-   `capture`: an integer representing the capture group to extract.
-   `claimed`: a `vector<Vector>` representing already claimed positions.

If a match is found, this function creates a new `RegexMatch` object with the captured text and starting position, and adds it to the `matches_str` vector. If a match is already claimed by a previous `claimed` vector, it will not be added to the result vector. The `claimed` vector contains a list of claimed matches as pairs of start and end positions.

This function returns a vector of `RegexMatch` objects representing the matches found in the input string.

#### `fn re string line, regex reg, int capture => vector<RegexMatch>`

This function is similar to the previous one, but it does not take a `claimed` vector as argument. If a match is found, it creates a new `RegexMatch` object with the captured text and starting position, and adds it to the `matches_str` vector.

This function returns a vector of `RegexMatch` objects representing the matches found in the input string.

#### `fn re string line, string rex, int capture => vector<RegexMatch>`

This function is similar to the previous one, but it takes a string `rex` as argument instead of a regular expression object. It creates a new regular expression object using the `rex` string, and proceeds to search the input string `line` for matches.

This function returns a vector of `RegexMatch` objects representing the matches found in the input string.
