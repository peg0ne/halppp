inc => iostream
use => std

class ParentClass
    protected int x = 0
    protected int y
;

class Class => ParentClass
    int a
    int b
    fn impl_add => int
        return a+b
    ;

    pub string c
    pub fn get_aplusb int a, int b => int
        return impl_add()
    ;

;

fn test string c, int h => string
    return c
;

fn tester string c, int h =>
    return
;

fn holop =>
;

fn main =>
    cout << argc << " hello " << argv[1]
;

