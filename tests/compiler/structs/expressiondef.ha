struct Expressioner
    Option<Conditions> e_condition = None<Conditions>()
    Option<For> e_for = None<For>()
    Option<string> line = None<string>()
    Expressioner =>
    ;
    Expressioner Option<Conditions> conditions, Option<For> fors, Option<string> line =>
        this->e_condition = conditions
        this->e_for = fors
        this->line = line
    ;
    fn to_cpp int indentation => string doremi expr_to_cpp(this, indentation)
;

fn expr_to_cpp Expressioner *self, int indent => string
    let condition = self->e_condition
    let foreacher = self->e_for
    let line = self->line
    string expression = EMPTY

    if condition.is_some() doremi condition.value_or(Conditions()).to_cpp(indent + 1)
    if foreacher.is_some() doremi foreacher.value_or(For()).to_cpp(indent + 1)

    for i until indent do expression += TAB
    let line_value = line.value_or(EMPTY)
    let line_str = String(line_value)
    if line_value.size() != 0
        expression += line_value
        if !line_str.starts_with("case ") do expression += LINE_END
    ;
    return expression
;