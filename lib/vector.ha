struct Vector
    int x = 0
    int y = 0
    int z = 0
    Vector => do return
    Vector int x, int y =>
        x = x
        y = y
    ;
    Vector int x, int y, int z =>
        x = x
        y = y
        z = z
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