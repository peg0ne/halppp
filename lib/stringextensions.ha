fn replace_string string str, string from, string to => string
    while true
        size_t start_pos = str.find(from)
        if start_pos == -1 doremi str
        str.replace(start_pos, from.length(), to)
    ;
;

fn starts_with string str, string start => bool doremi str.rfind(start, 0) == 0