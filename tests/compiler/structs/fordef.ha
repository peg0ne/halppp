struct For
    String iterator = EMPTY
    String until = EMPTY
    vector<Expression> lines = {}
    For =>
    ;
    fn to_cpp int indentation => string
        let for_str = EMPTY
        for i until indentation do for_str += TAB
        for_str += FOR_START + iterator
        for_str += FOR_MID + iterator
        for_str += FOR_UNTIL + until
        for_str += FOR_AFTER_UNTIL + iterator + FOR_END
        for i until lines.size() do for_str += lines.at(i).to_cpp(indentation + 1)
        for i until indentation do for_str += TAB
        for_str += BLOCK_END
        return for_str
    ;
;
