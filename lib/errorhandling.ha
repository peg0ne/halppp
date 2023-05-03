fn try_catch<Func, ...Args> Func func, Args... args => bool
    try {
        func(args...);
        return true;
    } catch (...) {
        return false;
    }
;

fn try_catch_value<T, Func, ...Args> Func func, Args... args => Option<T>
    try {
        return Some(func(args...));
    } catch (...) {
        return None<T>();
    }
;