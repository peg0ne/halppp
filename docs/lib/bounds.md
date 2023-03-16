## Documentation for Bounds Struct

### `struct Bounds`

This is a struct that represents the bounds of a rectangular area. It contains the following properties:

-   `min`: a `Vector` object representing the minimum coordinates of the bounding box.
-   `max`: a `Vector` object representing the maximum coordinates of the bounding box.

#### `Bounds => do return`

This constructor creates a new `Bounds` object with default `min` and `max` properties. It returns the created `Bounds` object.

#### `Bounds int minX, int minY, int maxX, int maxY =>`

This constructor creates a new `Bounds` object with the specified `min` and `max` properties. It takes four arguments:

-   `minX`: an integer representing the minimum x-coordinate of the bounding box.
-   `minY`: an integer representing the minimum y-coordinate of the bounding box.
-   `maxX`: an integer representing the maximum x-coordinate of the bounding box.
-   `maxY`: an integer representing the maximum y-coordinate of the bounding box.

It sets the `min` and `max` properties of the `Bounds` object based on the arguments provided.

#### `fn width => int`

This method returns the width of the `Bounds` object, which is the difference between the maximum and minimum x-coordinates.

#### `fn height => int`

This method returns the height of the `Bounds` object, which is the difference between the maximum and minimum y-coordinates.
