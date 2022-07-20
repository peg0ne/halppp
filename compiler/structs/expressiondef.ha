struct Expression
    Option<Condition> e_condition = None<Condition>()
    Option<For> e_for = None<For>()
    Option<Select> e_select = None<Select>()
    Option<string> line = None<string>()
    Expression => do return
    Expression Condition conditions => 
        this->e_condition = Some(conditions)
    ;
    Expression For fors => 
        this->e_for = Some(fors)
    ;
    Expression Select selects => 
        this->e_select = Some(selects)
    ;
    Expression string line => 
        this->line = Some(line)
    ;
    Expression Option<Condition> conditions, Option<For> fors, Option<string> line =>
        this->e_condition = conditions
        this->e_for = fors
        this->line = line
    ;
    fn to_cpp int indentation => string doremi expr_to_cpp(this, indentation)
;

fn expr_to_cpp Expression *self, int indent => string
    let condition = self->e_condition
    let foreacher = self->e_for
    let line = self->line
    string expression = EMPTY

    if condition.is_some() doremi condition.value_or(Condition()).to_cpp(indent + 1)
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