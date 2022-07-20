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
;