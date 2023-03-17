# Ncurses Class Documentation

The `Ncurses` class provides a set of methods that help to manipulate the terminal interface in a convenient way.

## Dependencies

The following header files are used by the `Ncurses` class:

-   `ncurses.h`
-   `curses.h`
-   `wchar.h`
-   `locale.h`
-   `iostream`
-   `cstring`

The `std` namespace is used.

## Constructor

### `Ncurses(bool ignore_colors = false)`

Creates a new `Ncurses` object and initializes the ncurses library. The `ignore_colors` parameter determines whether to enable the color mode or not. If it is set to `true`, the color mode will be disabled, otherwise it will be enabled. The default value is `false`.

## Methods

### `move_curs(int y, int x)`

Moves the cursor to the specified position `(y, x)`.

### `underline_until(int y, int x, short color, int len)`

Underlines the characters from position `(y, x)` for a length of `len` characters, using the specified color.

### `mark_until(int y, int x, short color, int len)`

Marks the characters from position `(y, x)` for a length of `len` characters, using the specified color. The text is not made bold.

### `mark_until(int y, int x, short color, int len, bool is_bold)`

Marks the characters from position `(y, x)` for a length of `len` characters, using the specified color. The `is_bold` parameter determines whether to make the text bold or not.

### `mark_until(int y, int x, short color, int len, bool is_bold, bool is_dim)`

Marks the characters from position `(y, x)` for a length of `len` characters, using the specified color. The `is_bold` parameter determines whether to make the text bold or not, and the `is_dim` parameter determines whether to make the text dim or not.

### `mark(int y, int x, short color)`

Marks the character at position `(y, x)` with the specified color.

### `box(int y, int x, int h, int w)`

Draws a box at position `(y, x)` with the specified height `h` and width `w`.

### `invis_box(int y, int x, int h, int w)`

Draws an invisible box at position `(y, x)` with the specified height `h` and width `w`.

### `use_arrows()`

Enables the use of arrow keys in the terminal interface.

### `col(short c, bool on)`

Sets the text color to the specified color pair `c`. The `on` parameter determines whether to turn on or off the color pair.

### `col(short c)`

Sets the text color to the specified color pair `c`. The color pair is turned on.

### `bold(bool on)`

Sets the text to bold. The `on` parameter determines whether to turn on or off the bold mode.

### `clear(int y, int len)`

Clears the line starting from position `(y, 0)` for a length of `len` characters.

### `clearScr()`

Clears the entire screen.

### `clearLn(int y)`

Clears the line at position `y`.

### `add(int y, int x, char c, bool is_bold)`

Adds the character `c` at position `(y, x)` with the specified bold mode

markdown

### add

This function adds a string to the screen at the specified position. It takes four parameters:

-   y: the y-coordinate of the screen position where the string should be added
-   x: the x-coordinate of the screen position where the string should be added
-   s: the string to be added
-   is_bold: a boolean flag indicating whether the string should be in bold or not (optional)

### add(int, int, string)

A helper function that calls the `add` function with the `is_bold` parameter set to false.

### add(int, int, int)

A helper function that converts the integer parameter to a string and calls the `add` function with it.

### add(int, int, short)

A helper function that converts the short parameter to a string and calls the `add` function with it.

### add(int, int, float)

A helper function that converts the float parameter to a string and calls the `add` function with it.

### add(int, int, double)

A helper function that converts the double parameter to a string and calls the `add` function with it.

### add_until

This function adds a string to the screen at the specified position up to a specified limit. It takes five parameters:

-   y: the y-coordinate of the screen position where the string should be added
-   x: the x-coordinate of the screen position where the string should be added
-   s: the string to be added
-   limit: the maximum number of characters to be added
-   is_bold: a boolean flag indicating whether the string should be in bold or not (optional)

### v_line

This function draws a vertical line on the screen at the specified position. It takes three parameters:

-   y: the y-coordinate of the screen position where the line should be drawn
-   x: the x-coordinate of the screen position where the line should be drawn
-   len: the length of the line

### h_line

This function draws a horizontal line on the screen at the specified position. It takes three parameters:

-   y: the y-coordinate of the screen position where the line should be drawn
-   x: the x-coordinate of the screen position where the line should be drawn
-   len: the length of the line

### key

This function waits for a keypress and returns the keycode.

### stop

This function stops the ncurses screen and restores the cursor.

### start

This function starts the ncurses screen and hides the cursor. It takes one optional parameter:

-   nonblock: a boolean flag indicating whether the screen should operate in non-blocking mode (optional)

### init_pair_adv

This function initializes a color pair with advanced settings. It takes five parameters:

-   pair: the ID of the color pair to be initialized
-   fg_p: the ID of the foreground color to be used
-   fg: a vector of three values (x, y, z) representing the RGB values of the foreground color
-   bg_p: the ID of the background color to be used
-   bg: a vector of three values (x, y, z) representing the RGB values of the background color
