fn twice int x => int doremi x * 2
fn total<T> vector<T> items => T
    T sum = 0
    foreach i in items do sum += i
    return sum
;
