struct For
    string iterator = EMPTY
    Option<string> named_variable = None<string>()
    string until = EMPTY
    vector<Expression> lines = {}
    bool is_foreach = false
    For => do return
    For bool is_foreach =>
        this->is_foreach = is_foreach
    ;
    fn to_cpp int indent => string
        let for_str = ""
        string iter = is_foreach && named_variable.is_none() ? $"{iterator}_iterator" : iterator
        // Evaluate the foreach collection once: `foreach x in f()` must not call f() every iteration.
        // auto&& binds to lvalues by reference and extends the lifetime of temporaries.
        let container = $"{iter}_container"
        string to = is_foreach ? $"{container}.size()" : until
        for i until indent do for_str += TAB
        if is_foreach
            for_str += "\n{\n"
            for_str += $"auto&& {container} = {until}{LINE_END}"
        ;
        for_str += $"{FOR_START}{iter}{FOR_MID}{iter}{FOR_UNTIL}{to}"
        for_str += $"{FOR_AFTER_UNTIL}{iter}{FOR_END}"
        if is_foreach
            for_str += "auto "
            for_str += named_variable.is_some() ? named_variable.value_or("") : iterator
            for_str += $" = {container}.at({iter});"
        ;
        for i until lines.size() do for_str += expr_to_cpp(&lines.at(i), indent + 1)
        for_str += BLOCK_END
        if is_foreach do for_str += "}\n"
        return for_str
    ;
;