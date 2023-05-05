struct Select
    string value_name = EMPTY
    string optional_value = EMPTY
    vector<Expression> lines = {}
    Select => do return
    fn to_cpp int indent => string
        let select_str = ""
        let wrapped = $"{value_name}_optional_value"
        for i until indent do select_str += TAB
        select_str += "\n{\n"
        select_str += $"auto {wrapped} = {optional_value}{LINE_END}"
        select_str += $"if({wrapped}.is_some()){BLOCK_START}"
        select_str += $"auto {value_name} = {wrapped}.value_unsafe(){LINE_END}"
        for i until lines.size() do select_str += expr_to_cpp(&lines.at(i), indent + 1)
        select_str += BLOCK_END
        select_str += "\n}\n"
        return select_str
    ;
;