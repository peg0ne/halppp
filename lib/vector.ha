struct Vector
    int x = 0
    int y = 0
    int z = 0
    Vector => do return
    Vector int x, int y =>
        this->x = x
        this->y = y
    ;
    Vector int x, int y, int z =>
        this->x = x
        this->y = y
        this->z = z
    ;
    fn + Vector other => Vector
        let temp = Vector()
        temp.x = x + other.x
        temp.y = y + other.y
        temp.z = z + other.z
        return temp
    ;
    fn - Vector other => Vector
        let temp = Vector()
        temp.x = x - other.x
        temp.y = y - other.y
        temp.z = z - other.z
        return temp
    ;
    fn / Vector other => Vector
        let temp = Vector()
        temp.x = x / other.x
        temp.y = y / other.y
        temp.z = z / other.z
        return temp
    ;
    fn * Vector other => Vector
        let temp = Vector()
        temp.x = x * other.x
        temp.y = y * other.y
        temp.z = z * other.z
        return temp
    ;
    fn == Vector other => bool
        if x != other.x doremi false
        if y != other.y doremi false
        if z != other.z doremi false
        return true
    ;
    fn != Vector other => bool
        return x == other.x && y == other.y && z == other.z ? false : true
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
    fn multiply int amount =>
        x *= amount
        y *= amount
        z *= amount
    ;
;