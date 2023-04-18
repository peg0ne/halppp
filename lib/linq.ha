get => list, option

named => linq

class Linq<T>
    vector<T> list = {}
    Linq => do return
    Linq vector<T> list => do this->list = list
pub
    fn where<Func, ...Args> Func func, Args... args => Linq<T>
        vector<T> temp = {}
        foreach ele in list
            if func(ele, args...) do temp.push_back(ele)
        ;
        return Linq<T>(temp)
    ;
    fn where_with_iterator<Func, ...Args> Func func, Args... args => Linq<T>
        vector<T> temp = {}
        foreach i, ele in list
            if func(ele, i, args...) do temp.push_back(ele)
        ;
        return Linq<T>(temp)
    ;
    fn operate<Func, ...Args> Func func, Args... args => Linq<T>
        vector<T> temp = {}
        foreach ele in list
            temp.push_back(func(ele, args...))
        ;
        return Linq<T>(temp)
    ;
    fn operate_with_iterator<Func, ...Args> Func func, Args... args => Linq<T>
        vector<T> temp = {}
        foreach i, ele in list
            temp.push_back(func(ele, i, args...))
        ;
        return Linq<T>(temp)
    ;
    fn operate<R, Func, ...Args> Func func, Args... args => Linq<R>
        vector<R> temp = {}
        foreach ele in list
            temp.push_back(func(ele, args...))
        ;
        return Linq<R>(temp)
    ;
    fn operate_with_iterator<R, Func, ...Args> Func func, Args... args => Linq<R>
        vector<R> temp = {}
        foreach i, ele in list
            temp.push_back(func(ele, i, args...))
        ;
        return Linq<R>(temp)
    ;
    fn join vector<T> other => Linq<T>
        foreach ele in other do list.push_back(ele)
        return Linq<T>(list)
    ;
    fn first => Option<T> doremi list.size() != 0 ? Some(list[0]) : None<T>()
    fn first_or T other => T doremi list.size() != 0 ? list[0] : other
    fn last => Option<T> doremi list.size() != 0 ? Some(list[list.size() - 1]) : None<T>()
    fn last_or T other => T doremi list.size() != 0 ? list[list.size() - 1] : other
    fn as_vec => vector<T> doremi list
    fn as_vec_ptr => vector<T>* doremi &list
    fn as_list => List<T> doremi List<T>(list)
;

fn take<T> vector<T> list => Linq<T> doremi Linq<T>(list)
fn take<T> List<T> list => Linq<T> doremi Linq<T>(list.as_vec())
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