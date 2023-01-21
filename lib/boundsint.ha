get => vectorint

struct Bounds
    Vector min = Vector()
    Vector max = Vector()
    Bounds => do return
    Bounds int minX, int minY, int maxX, int maxY =>
        this->min = Vector(minX, minY)
        this->max = Vector(maxX, maxY)
    ;
    fn width => int doremi max.x - min.x
    fn height => int doremi max.y - min.y
;