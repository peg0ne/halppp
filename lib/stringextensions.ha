inc => string, vector
use => std
get => option, conditional

class String
    string _value
    String string value => do this->_value = value
pub
    fn to_string => string doremi _value
    fn len => long doremi _value.size()
    fn at int at => auto doremi _value.at(at)
    fn append string value => do _value += value
    fn insert string value, int at =>
        if at == 0 dore _value = value + _value
        if at >= len() dore append(value)
        let updated = _value.substr(0, at)
        updated += value
        updated += _value.substr(at)
        _value = updated
    ;
    fn remove int at =>
        if len() == 0 do return
        if at >= len() do return 
        if at == 0 dore _value = substr(1)
        _value = substr(0, at) + substr(at + 1)
    ;
    fn pop => string doremi substr(0, _value.size() - 1)
    fn to_upper => string
        let upper = _value
        for i until upper.size() do upper[i] = toupper(upper[i])
        return upper
    ;
    fn to_lower => string
        let lower = _value
        for i until lower.size() do lower[i] = tolower(lower[i])
        return lower
    ;
    fn strip => string doremi strip(None<int>())
    fn strip int times => string doremi strip(Some(times))
    fn strip Option<int> times => string
        let stripped = _value
        let amount = _value.size()
        let rhs = false
        let lhs = false
        select t from times do amount = t
        for i until amount
            if rhs && lhs do break
            if !rhs
                if stripped.size() == 0 do break
                if any(stripped.back(), {' ', '\n', '\t'})
                    stripped = stripped.substr(0, stripped.size()-1)
                ;
                else do rhs = true
            ;
            if !lhs
                if stripped.size() == 0 do break
                if any(stripped[0], {' ', '\n', '\t'})
                    stripped = stripped.substr(1)
                ;
                else do lhs = true
            ;
        ;
        return stripped
    ;
    fn strip_end => string doremi strip_end(None<int>())
    fn strip_end int times => string doremi strip_end(Some(times))
    fn strip_end Option<int> times => string
        let stripped = _value
        let amount = _value.size()
        select t from times do amount = t
        for i until amount
            if stripped.size() == 0 do break
            if none(stripped.back(), {' ', '\n', '\t'}) do break
            stripped = stripped.substr(0, stripped.size()-1)
        ;
        return stripped
    ;
    fn strip_front => string doremi strip_front(None<int>())
    fn strip_front int times => string doremi strip_front(Some(times))    
    fn strip_front Option<int> times => string
        let stripped = _value
        let amount = _value.size()
        select t from times do amount = t
        for i until amount
            if stripped.size() == 0 do break
            if none(stripped[0], {' ', '\n', '\t'}) do break
            stripped = stripped.substr(1)
        ;
        return stripped
    ;
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
    fn split => vector<string> doremi split(None<char>())
    fn split char delimiter => vector<string> doremi split(Some(delimiter))
    fn split Option<char> delimiter => vector<string>
        vector<string> split = {}
        let delim = ' '
        select d from delimiter do delim = d
        let splitting =  _value
        loop
            let found = splitting.find(delim)
            if found == -1 do break
            split.push_back(splitting.substr(0, found))
            splitting = splitting.substr(found + 1)
        ;
        split.push_back(splitting)
        return split
    ;
    fn contains string contains => bool doremi _value.find(contains) != -1
    fn starts_with string start => bool doremi _value.rfind(start, 0) == 0
    fn ends_with string ends => bool
        if ends.size() > len() do return false
        if ends.size() == len() do return ends == _value
        let sub = substr(_value.size() - ends.size())
        return sub == ends
    ;
    fn substr int start => string doremi _value.substr(start)
    fn substr int start, int end => string doremi _value.substr(start, end)
;
named => stringutils
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