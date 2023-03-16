# Documentation for math library

## `fn clamp double value, double min, double max => double`

Returns the value clamped between the minimum and maximum values.

### Parameters

-   `value` (double): The value to be clamped.
-   `min` (double): The minimum value that the returned value can be.
-   `max` (double): The maximum value that the returned value can be.

### Returns

-   (double): The clamped value.

### Example

```python
clamp(5.5, 0.0, 10.0)  # Output: 5.5
clamp(20.0, 0.0, 10.0) # Output: 10.0
clamp(-5.0, 0.0, 10.0) # Output: 0.0
```

## `fn max double v_one, double v_two => double`

Returns the greater of the two values.

### Parameters

-   `v_one` (double): The first value to be compared.
-   `v_two` (double): The second value to be compared.

### Returns

-   (double): The greater of the two values.

### Example

```python
max(5.0, 10.0)  # Output: 10.0
max(10.0, 5.0)  # Output: 10.0
max(-5.0, -10.0) # Output: -5.0
```

## `fn min double v_one, double v_two => double`

Returns the smaller of the two values.

### Parameters

-   `v_one` (double): The first value to be compared.
-   `v_two` (double): The second value to be compared.

### Returns

-   (double): The smaller of the two values.

### Example

```python
min(5.0, 10.0)  # Output: 5.0
min(10.0, 5.0)  # Output: 5.0
min(-5.0, -10.0) # Output: -10.0
```
