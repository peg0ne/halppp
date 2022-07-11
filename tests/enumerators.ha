inc => iostream
use => std

enum Day =>
    Monday,
    Tuesday,
    Wednesday = 3,
    Thursday,
    Friday = 5,
    Saturday,
    Sunday,
;

fn main =>
    let a = Monday
    switch a
    case Monday: dobr cout << "m\n"
    case Tuesday: dobr cout << "t\n"
    case Wednesday: dobr cout << "w\n"
    case Thursday: dobr cout << "t\n"
    case Friday: dobr cout << "f\n"
    case Saturday: dobr cout << "s\n"
    case Sunday: dobr cout << "s\n"
    ;
;