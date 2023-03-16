# conditional

The following functions are defined:

-   `any<T>(value: T, values: vector<T>) -> bool`: returns `true` if `value` is equal to at least one element in `values`, `false` otherwise.
-   `all<T>(value: T, values: vector<T>) -> bool`: returns `true` if `value` is equal to every element in `values`, `false` otherwise.
-   `none<T>(value: T, values: vector<T>) -> bool`: returns `true` if `value` is not equal to any element in `values`, `false` otherwise.
-   `over<T>(value: T, values: vector<T>) -> bool`: returns `true` if `value` is greater than or equal to every element in `values`, `false` otherwise.
-   `under<T>(value: T, values: vector<T>) -> bool`: returns `true` if `value` is less than or equal to every element in `values`, `false` otherwise.
-   `any_less<T>(value: T, values: vector<T>) -> bool`: returns `true` if `value` is less than at least one element in `values`, `false` otherwise.
