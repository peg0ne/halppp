struct Expression
    Option<Condition> e_condition = None<Condition>()
    Option<For> e_for = None<For>()
    Option<Select> e_select = None<Select>()
    Option<Variable> e_declaration = None<Variable>()
    Option<MatchDef> e_matcher = None<MatchDef>()
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
    Expression Variable declaration =>
        this->e_declaration = Some(declaration)
    ;
    Expression MatchDef matcher =>
        this->e_matcher = Some(matcher)
    ;
    Expression string line => 
        this->line = Some(line)
    ;
    Expression Option<Condition> conditions, Option<For> fors, Option<Variable> declaration, Option<string> line =>
        this->e_condition = conditions
        this->e_for = fors
        this->e_declaration = declaration
        this->line = line
    ;
    fn to_cpp int indentation => string doremi expr_to_cpp(this, indentation)
;

fn expr_to_cpp Expression *self, int indent => string
    let condition = self->e_condition
    let foreacher = self->e_for
    let selects = self->e_select
    let declaration = self->e_declaration
    let matcher = self->e_matcher
    let line = self->line
    let expression = ""

    select c from condition doremi c.to_cpp(indent + 1)
    select f from foreacher doremi f.to_cpp(indent + 1)
    select s from selects doremi s.to_cpp(indent + 1)
    select d from declaration doremi d.to_cpp(indent + 1, LINE_END)
    select m from matcher doremi m.to_cpp()

    for i until indent do expression += TAB
    let line_value = line.value_or(EMPTY)
    let line_str = String(line_value)
    if line_value.size() != 0
        expression += line_value
        let is_case = line_str.starts_with("case ")
        let is_default = line_str.starts_with("default")
        if !is_case && !is_default do expression += LINE_END
    ;
    return expression
;