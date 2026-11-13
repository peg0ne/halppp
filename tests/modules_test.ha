get => ../lib/print
get => modules/[geometry, counter]
inc => vector

fn main =>
    let sq = geometry::make_square(3)
    println(geometry::describe(sq))
    println(geometry::describe(geometry::Shape(geometry::Kind::Circle, 2), "round"))
    println(twice(21))
    println(total(vector<int>{1, 2, 3, 4}))
;
