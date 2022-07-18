class String
    string _value
    String string value =>
        this->_value = value
    ;
pub
    fn len => long doremi _value.size()
    fn at int at => char doremi _value.at(at)
    fn append string value => void do _value += value
    fn replace string from, string to => string
        string replaced = _value
        loop 
            size_t start_pos = replaced.find(from)
            if start_pos == -1 doremi replaced
            replaced.replace(start_pos, from.length(), to)
        ;
    ;
    fn replace string from, string to, int amount => string
        string replaced = _value
        for i until amount
            size_t start_pos = replaced.find(from)
            if start_pos == -1 doremi replaced
            replaced.replace(start_pos, from.length(), to)
        ;
        return replaced
    ;
    fn contains string contains => bool doremi _value.find(contains) != -1
    fn starts_with string start => bool doremi _value.rfind(start, 0) == 0
    fn substr int start => string doremi _value.substr(start)
    fn substr int start, int end => string doremi _value.substr(start, end)
;