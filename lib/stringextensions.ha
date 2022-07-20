inc => string, vector
use => std
get => option

class String
    string _value
    String string value =>
        this->_value = value
    ;
pub
    fn to_string => string doremi _value
    fn len => long doremi _value.size()
    fn at int at => char doremi _value.at(at)
    fn append string value => do _value += value
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
    fn to_num => Option<double>
        let num = 0.0
        let dec = 0.0
        let dec_len = 0
        let is_dec = false
        foreach c in _value
            if c == '.'
                if is_dec doremi None<double>()
                is_dec = true
                continue
            ;

            let num_opt = char_to_number(c)
            select num_val from char_to_number(c)
                if is_dec
                    dec *= 10
                    dec += num_val
                    dec_len++
                ;
                else
                    num *= 10
                    num += num_val
                ;
                continue
            ;
            return None<double>()
        ;
        for i until dec_len do dec *= 0.1
        return Some(num + dec)
    ;
    fn contains string contains => bool doremi _value.find(contains) != -1
    fn starts_with string start => bool doremi _value.rfind(start, 0) == 0
    fn substr int start => string doremi _value.substr(start)
    fn substr int start, int end => string doremi _value.substr(start, end)
;

fn is_char_number char ch => bool
    switch ch
    case '0'
    case '1'
    case '2'
    case '3'
    case '4'
    case '5'
    case '6'
    case '7'
    case '8'
    case '9' doremi true
    default doremi false
    ;
;

fn char_to_number char ch => Option<int>
    switch ch
    case '0' doremi Some(0)
    case '1' doremi Some(1)
    case '2' doremi Some(2)
    case '3' doremi Some(3)
    case '4' doremi Some(4)
    case '5' doremi Some(5)
    case '6' doremi Some(6)
    case '7' doremi Some(7)
    case '8' doremi Some(8)
    case '9' doremi Some(9)
    default doremi None<int>()
    ;
;