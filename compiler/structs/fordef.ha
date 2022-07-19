struct For
    string iterator = EMPTY
    string until = EMPTY
    vector<Expression> lines = {}
    bool is_foreach = false
    For => do return
    For bool is_foreach =>
        this->is_foreach = is_foreach
    ;
    fn to_cpp int indent => string
        string for_str = EMPTY
        string iter = is_foreach ? iterator + "_iterator" : iterator
        string to = is_foreach ? until + ".size()" : until
        for i until indent do for_str += TAB
        for_str += FOR_START + iter
        for_str += FOR_MID + iter
        for_str += FOR_UNTIL + to
        for_str += FOR_AFTER_UNTIL + iter + FOR_END
        if is_foreach
            for_str += "auto " + iterator
            for_str += " = " + until
            for_str += ".at(" + iter + ");"
        ;
        for i until lines.size() do for_str += expr_to_cpp(&lines.at(i), indent + 1)
        for_str += BLOCK_END
        return for_str
    ;
;
