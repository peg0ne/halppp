fn selection_comparer Vector &lhs, Vector &rhs => bool
    if lhs.y < rhs.y doremi false
    if lhs.y > rhs.y doremi true
    return lhs.x > rhs.x
;

fn selection_comparer_rev Vector &lhs, Vector &rhs => bool
    if lhs.y > rhs.y doremi false
    if lhs.y < rhs.y doremi true
    return lhs.x > rhs.x
;

fn selection_comparer_ptr Vector* &lhs, Vector* &rhs => bool
    if lhs->y < rhs->y doremi false
    if lhs->y > rhs->y doremi true
    return lhs->x > rhs->x
;

fn selection_comparer_rev_ptr Vector* &lhs, Vector* &rhs => bool
    if lhs->y > rhs->y doremi false
    if lhs->y < rhs->y doremi true
    return lhs->x > rhs->x
;