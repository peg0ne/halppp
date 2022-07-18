struct For
    string iterator = EMPTY
    string until = EMPTY
    vector<Expressioner> lines = {}
    For =>
    ;
    fn to_cpp int indent => string
        string for_str = EMPTY
        for i until indent do for_str += TAB
        for_str += FOR_START + iterator
        for_str += FOR_MID + iterator
        for_str += FOR_UNTIL + until
        for_str += FOR_AFTER_UNTIL + iterator + FOR_END
        for i until lines.size() do for_str += expr_to_cpp(&lines.at(i), indent + 1)
        for_str += BLOCK_END
        return for_str
    ;
;
