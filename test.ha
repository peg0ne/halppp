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

    extend => ClassFunctions
;

fn test string c, int h => Class
    return c
;

fn tester string c, int h =>
    return
;

fn holop =>
;

fn main => int
    cout << argc << " hello " << argv[1]
    return 0
