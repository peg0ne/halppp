struct Expressioner
    ClassOption<Conditions> e_condition = ClassNone<Conditions>()
    ClassOption<For> e_for = ClassNone<For>()
    ClassOption<string> line = ClassNone<string>()
    Expressioner =>
    ;
    fn to_cpp int indentation => string
        if e_condition.is_some() doremi e_condition.value_or(Conditions(EMPTY)).to_cpp(indentation + 1)
        if e_for.is_some() doremi e_for.value_or(For()).to_cpp(indentation + 1)
        string expression = EMPTY
        for i until indentation do expression += TAB
        let line_value = line.value_or(EMPTY)
        expression += line_value.size() == 0 ? EMPTY : line_value + LINE_END
        return expression
    ;
;
