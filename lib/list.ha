inc => vector, string
use => std
get => option, print

class List<T>
    vector<T> _list = {}
    List => do return
    List vector<T> list => do _list = list
pub
    fn at int at => T doremi _list.at(at)
    fn at_ptr int at => T* doremi &_list.at(at)
    fn set int at, T val => do _list.at(at) = val
    fn first => Option<T> doremi at(0)
    fn last => Option<T> doremi at(len()-1)
    fn begin => auto doremi _list.begin()
    fn end => auto doremi _list.end()
    fn len => int doremi _list.size()
    fn size => int doremi _list.size()
    fn add T ele => do _list.push_back(ele)
    fn pop => do remove(len()-1)
    fn clear => do _list.clear()
    fn remove int index =>
        if len() == 0 do return
        vector<T> buf = {}
        let i = 0
        foreach ele in _list
            if i != index do buf.push_back(ele)
            i++
        ;
        clear()
        _list = buf
    ;
;

fn to_string<T> List<T> list => string
    let s = to_string(list.len()) + " : ["
    foreach l in list do s += to_string(l) + ","
    return s + "]"
;