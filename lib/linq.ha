get => list, option

named => linq

class Linq<T>
    vector<T> list = {}
    Linq => do return
    Linq vector<T> list => do this->list = list
pub
    fn where<Func, ...Args> Func func, Args... args => Linq
        vector<T> temp = {}
        foreach ele in list
            if func(ele, args...) do temp.push_back(ele)
        ;
        return Linq(temp)
    ;
    fn operate<Func, ...Args> Func func, Args... args => Linq
        vector<T> temp = {}
        foreach ele in list
            temp.push_back(func(ele, args...))
        ;
        return Linq(temp)
    ;
;

fn take<T> vector<T> list => Linq<T> doremi Linq(list)
fn take<T> List<T> list => Linq<T> doremi Linq(list.as_vec())
fn take<T> Option<T> obj => Linq<T>
    select o from obj doremi Linq<T>({o})
    return Linq<T>()
;
fn range int amount => Linq<int>
    vector<int> temp = {}
    for i until amount do temp.push_back(i)
    return Linq<int>(temp)
;
;