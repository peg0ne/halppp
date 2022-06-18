class ParentClass
    protected int x
    protected int y
;

class Class => ParentClass
    int a
    int b
    fn impl_add => int
        return a+b

pub string c
pub fn get_aplusb => int
    return impl_add()

    extend => ClassFunctions
;

fn test string c, int h => Class
    return c
;

fn tester string c, int h =>
    return
;

fn holop =>
