named => geometry
inc => string
use => std

enum Kind
    Circle,
    Square,
;

struct Shape
    Kind kind
    int size
    Shape Kind k, int s =>
        kind = k
        size = s
    ;
    fn area => int doremi kind == Kind::Square ? size * size : 3 * size * size
;

fn make_square int s => Shape doremi Shape(Kind::Square, s)
fn describe Shape s, string prefix = "shape" => string
    return $"{prefix} {s.kind} area={s.area()}"
;
