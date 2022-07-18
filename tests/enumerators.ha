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
    let a = Day::Monday
    switch a
    case Day::Monday dobr cout << "m\n"
    case Day::Tuesday dobr cout << "t\n"
    case Day::Wednesday dobr cout << "w\n"
    case Day::Thursday dobr cout << "t\n"
    case Day::Friday dobr cout << "f\n"
    case Day::Saturday dobr cout << "s\n"
    case Day::Sunday dobr cout << "s\n"
    ;
    if a != Day::Monday doremi 1
    else doremi 0

    if a != Day::Tuesday doremi 0
    else
        return 0
    ;
;