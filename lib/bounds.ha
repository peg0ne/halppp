get => vector

struct Bounds
    Vector min = Vector()
    Vector max = Vector()
    Bounds => do return
    Bounds double minX, double minY, double maxX, double maxY =>
        this->min = Vector(minX, minY)
        this->max = Vector(maxX, maxY)
    ;
    fn width => double doremi max.x - min.x
    fn height => double doremi max.y - min.y
;