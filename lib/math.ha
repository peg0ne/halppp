inc => algorithm
fn clamp double value, double min, double max => double
    if max <= min doremi min
    if value > max doremi max
    if value < min doremi min
    return value
;
fn max double v_one, double v_two => double doremi v_one > v_two ? v_one : v_two
fn min double v_one, double v_two => double doremi v_one < v_two ? v_one : v_two