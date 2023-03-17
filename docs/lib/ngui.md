# NGUI

## Class Documentation: IContainer

This class represents a container that can hold other `IContainer` instances, as well as content such as labels and strings.

## Properties

-   `protected`
    -   `string _label`: The label of the container.
    -   `Option<string> _fill_str`: The fill string used to fill the container.
    -   `List<string> _content`: The list of strings contained in the container.
    -   `List<IContainer*> _containers`: The list of `IContainer` instances contained in the container.
    -   `ContainerType _type`: The type of the container.
    -   `short _color`: The color of the container.
    -   `Fill _fill_x`: The fill of the container in the x-direction.
    -   `Fill _fill_y`: The fill of the container in the y-direction.
    -   `Vector _size`: The size of the container.
    -   `Vector _offset`: The offset of the container.
    -   `bool is_active`: Indicates whether the container is currently active.

## Constructors

-   `IContainer()`: Initializes an empty container.
-   `IContainer(Fill f)`: Initializes a container with the specified fill.
-   `IContainer(Fill f, Vector s)`: Initializes a container with the specified fill and size.
-   `IContainer(Fill f, Vector s, string fill_str)`: Initializes a container with the specified fill, size, and fill string.
-   `IContainer(Vector s, Vector o)`: Initializes a container with the specified size and offset.
-   `IContainer(Fill f_x, Fill f_y, Vector s, Vector o)`: Initializes a container with the specified fills, size, and offset.

## Methods

-   `Type() -> ContainerType`: Returns the type of the container.
-   `FillY() -> Fill`: Returns the fill of the container in the y-direction.
-   `FillX() -> Fill`: Returns the fill of the container in the x-direction.
-   `Size() -> Vector`: Returns the size of the container.
-   `Offset() -> Vector`: Returns the offset of the container.
-   `Color() -> short`: Returns the color of the container.
-   `Label() -> string`: Returns the label of the container.
-   `Active() -> bool`: Returns whether the container is currently active.
-   `SetActive(bool active)`: Sets the activity of the container.
-   `SetSize(int x, int y)`: Sets the size of the container.
-   `SetOffset(int x, int y)`: Sets the offset of the container.
-   `SetColor(short col)`: Sets the color of the container.
-   `SetLabel(string label)`: Sets the label of the container.
-   `SetContent(List<string> content)`: Sets the content of the container.
-   `GetContent() -> List<string>`: Returns the content of the container.
-   `add(IContainer* c)`: Adds a child container to the container.
-   `size() -> int`: Returns the number of child containers.
-   `containers() -> List<IContainer*>*`: Returns a pointer to the list of child containers.
-   `clear()`: Clears the list of child containers.
-   `draw(Ncurses* n)`: Draws the container on the screen using the specified `Ncurses` instance.

# ContainerType Enum

This is an enum that represents the different types of containers available in the system.

## Values

-   `Base`: The default type of container.
-   `Grouped`: A container that groups together other containers.
-   `Vertical`: A container that stacks its child containers vertically.
-   `Horizontal`: A container that arranges its child containers horizontally.
-   `Main`: A container that serves as the main container of the application.
-   `Grid`: A container that arranges its child containers in a grid.

## Class GroupedContainer

This class is derived from `IContainer` and represents a container that groups multiple other containers.

## Properties

### Protected

-   `GroupedContainer` : Constructor method that sets the `_type` property to `ContainerType::Grouped`.

### Public

-   `draw(Ncurses *n)` :

## HorizontalLayout Class

The `HorizontalLayout` class is a child of the `GroupedContainer` class and implements a horizontal layout for a set of containers.

## Constructor

-   `HorizontalLayout`: creates a new instance of `HorizontalLayout` with default values.
-   `HorizontalLayout Fill f`: creates a new instance of `HorizontalLayout` with the specified fill value for both x and y dimensions.
-   `HorizontalLayout Fill f, Vector s`: creates a new instance of `HorizontalLayout` with the specified fill value for both x and y dimensions, and the specified size.
-   `HorizontalLayout Vector s, Vector o`: creates a new instance of `HorizontalLayout` with the specified size and offset values.

## Public Methods

-   `draw(Ncurses *n)`: draws the containers in the layout on the screen.
-   `update()`: updates the size and position of the containers in the layout.

## Protected Methods

-   `GroupedContainer`: constructor of the parent class with `_type` set to `ContainerType::Grouped`.

## Public Properties

-   None

## Protected Properties

-   `_type`: the type of the container, set to `ContainerType::Horizontal`.
-   `_fill_x`: the fill value for the x dimension.
-   `_fill_y`: the fill value for the y dimension.
-   `_size`: the size of the container.
-   `_offset`: the offset of the container from its parent container.

## Example Usage

```rust
let h_layout = HorizontalLayout(Fill::Flex, Vector(0,0))
let container1 = GroupedContainer()
let container2 = GroupedContainer()
h_layout.add_container(container1)
h_layout.add_container(container2)
h_layout.update()
h_layout.draw(n)
```

## VerticalLayout Class

The `VerticalLayout` class is a child of the `GroupedContainer` class and implements a vertical layout for a set of containers.

## Constructor

-   `VerticalLayout`: creates a new instance of `VerticalLayout` with default values.
-   `VerticalLayout Fill f`: creates a new instance of `VerticalLayout` with the specified fill value for both x and y dimensions.
-   `VerticalLayout Fill f, Vector s`: creates a new instance of `VerticalLayout` with the specified fill value for both x and y dimensions, and the specified size.
-   `VerticalLayout Vector s, Vector o`: creates a new instance of `VerticalLayout` with the specified size and offset values.

## Public Methods

-   `draw(Ncurses *n)`: draws the containers in the layout on the screen.
-   `update()`: updates the size and position of the containers in the layout.

## Protected Methods

-   `GroupedContainer`: constructor of the parent class with `_type` set to `ContainerType::Grouped`.

## Public Properties

-   None

## Protected Properties

-   `_type`: the type of the container, set to `ContainerType::Vertical`.
-   `_fill_x`: the fill value for the x dimension.
-   `_fill_y`: the fill value for the y dimension.
-   `_size`: the size of the container.
-   `_offset`: the offset of the container from its parent container.

## Example Usage

```rust
let v_layout = VerticalLayout(Fill::Flex, Vector(0,0))
let container1 = GroupedContainer()
let container2 = GroupedContainer()
v_layout.add_container(container1)
v_layout.add_container(container2)
v_layout.update()
v_layout.draw(n)
```

## SpiralLayout Class

The `SpiralLayout` class is a type of `VerticalLayout` that arranges its child containers in a spiral pattern.

## Constructors

### `SpiralLayout()`

Creates a new `SpiralLayout` with default settings.

### `SpiralLayout(Fill f)`

Creates a new `SpiralLayout` with the specified fill factor `f`.

### `SpiralLayout(Fill f, Vector s)`

Creates a new `SpiralLayout` with the specified fill factor `f` and size `s`.

### `SpiralLayout(Vector s, Vector o)`

Creates a new `SpiralLayout` with the specified size `s` and offset `o`.

## Public Methods

### `void add_element(IContainer* element)`

Adds the specified child container `element` to the `SpiralLayout` and arranges it in the spiral pattern.

### `void destruct()`

Destroys the `SpiralLayout` and all its child containers.

## Private Methods

### `IContainer* get_row()`

Returns the next row container in the spiral pattern.

## Member Variables

### `vector<IContainer*> _elements`

The child containers of the `SpiralLayout`.

### `vector<IContainer*> _dividers`

The row divider containers used to arrange the child containers in the spiral pattern.

# TO BE DOCUMENTED

-   STEPLAYOUT
-   MAINCONTAINER
-   BUTTON
-   GRIDLAYOUT
-   FILLEDRECT
-   CONTAINERDRAWER
