struct Expression
    Option<Condition> e_condition = None<Condition>()
    Option<For> e_for = None<For>()
    Option<string> line = None<string>()
    fn to_cpp int indentation => string
        if e_condition.is_some() doremi e_condition.value_or(Condition()).to_cpp()
        if e_for.is_some() doremi e_for.value_or(For()).to_cpp()
        let expression = EMPTY
        for i until indentation do expression += TAB
        let line_value = line.value_or(EMPTY)
        expression += line_value.size() == 0 ? EMPTY : line_value + LINE_END
        return expression
    ;
;
