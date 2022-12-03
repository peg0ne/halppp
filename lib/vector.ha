struct Vector
    double x = 0.0
    double y = 0.0
    double z = 0.0
    Vector => do return
    Vector double x, double y =>
        this->x = x
        this->y = y
    ;
    Vector double x, double y, double z =>
        this->x = x
        this->y = y
        this->z = z
    ;
    fn add Vector other =>
        x += other.x
        y += other.y
        z += other.z
    ;
    fn sub Vector other =>
        x -= other.x
        y -= other.y
        z -= other.z
    ;
    fn eq Vector other => bool
        if x != other.x doremi false
        if y != other.y doremi false
        if z != other.z doremi false
        return true
    ;
    fn multiply double amount =>
        x *= amount
        y *= amount
        z *= amount
    ;
;