get => vector

struct Bounds
    Vector min = Vector()
    Vector max = Vector()
    Bounds =>
    ;
    Bounds int minX, int minY, int maxX, int maxY =>
        min = Vector(minX, minY)
        max = Vector(maxX, maxY)
    ;
    fn width => int doremi max.x - min.x
    fn height => int doremi max.y - min.y
;