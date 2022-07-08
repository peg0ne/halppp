struct Vector
    int x = 0
    int y = 0
    int z = 0
    Vector =>
    ;
    Vector int x, int y =>
        x = x
        y = y
    ;
    Vector int x, int y, int z =>
        x = x
        y = y
        z = z
    ;
    pub fn add Vector other =>
        x += other.x
        y += other.y
        z += other.z
    ;
    pub fn sub Vector other =>
        x -= other.x
        y -= other.y
        z -= other.z
    ;
;