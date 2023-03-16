# Struct Vector

Represents a vector with three dimensions.

## Properties

-   `x` (int): The value of the x dimension. Initialized to 0 by default.
-   `y` (int): The value of the y dimension. Initialized to 0 by default.
-   `z` (int): The value of the z dimension. Initialized to 0 by default.

## Constructors

-   `Vector()`: Initializes all dimensions to 0.
-   `Vector(int x, int y)`: Initializes the x and y dimensions with the given values and sets the z dimension to 0.
-   `Vector(int x, int y, int z)`: Initializes all three dimensions with the given values.

## Methods

-   `add(Vector other)`: Adds the given vector to this vector.
-   `sub(Vector other)`: Subtracts the given vector from this vector.
-   `eq(Vector other) -> bool`: Compares this vector to the given vector and returns true if they are equal in all dimensions, false otherwise.
-   `multiply(int amount)`: Multiplies all dimensions by the given amount.
