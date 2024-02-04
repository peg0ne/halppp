fn map_construct Compiler *compiler_t, string id, bool is_let => Expression
    let map_value = Map()
    map_value.assigning_value = id
    get_or_exit(compiler_t, Token::LessThan, "[Map] expected '<'")
    let arrow_depth = 1
    // Get the type to output
    loop
        let token = next_or_exit(compiler_t, "[Map] expected some type defintion and ending '>'")
        if token.token == Token::LessThan do arrow_depth++
        if token.token == Token::MoreThan do arrow_depth--
        if arrow_depth == 0 do break
        map_value.type_to_output += token.name
    ;
    // Get the item to operate on
    let raw_operator = String(next_or_exit(compiler_t, "[Map] expected '('").name)
    if !raw_operator.starts_with("(") && !raw_operator.ends_with(")") do error("[Map] expected (...) expression but got {raw_operator.name}", compiler_t->recap())
    map_value.operator_on_value = raw_operator.to_string()
    // Get the map operations
    loop
        if try_get(compiler_t, Token::NewLine)
            next_or_exit(compiler_t, "[Map] unkown error")
            if !try_get(compiler_t, Token::Period) dobr compiler_t->prev()
        ;
        get_or_exit(compiler_t, Token::Period, "[Map] expected '.'")
        let operator_type = next_or_exit(compiler_t, "[Map] expected operator type")
        if none(operator_type.token, {Token::Select, Token::Where}) do error($"[Map] invalid operator type {operator_type.name}", compiler_t->recap())
        map_value.operations.push_back(map_operator_construct(compiler_t, operator_type.token))
    ;
    if map_value.operations.size() == 0 do error("[Map] expected operations but got none", compiler_t->recap())
    return Expression(map_value.to_cpp(), true)
;

fn map_operator_construct Compiler *compiler_t, Token operator_type => MapOperator
    let raw_operator = String(next_or_exit(compiler_t, "[Map] expected (...) expression").name)
    if !raw_operator.starts_with("(") && !raw_operator.ends_with(")") do error("[Map] expected (...) expression but got {raw_operator.name}", compiler_t->recap())
    raw_operator.remove(0)
    raw_operator.remove_back(1)
    
    let ast = ast_create(raw_operator.to_string())
    let program = Program()
    let compiler_temp = Compiler(&program, ast, 0)
    return map_operator_construct_internal(&compiler_temp, operator_type)
;

fn map_operator_construct_internal Compiler *compiler_t, Token operator_type => MapOperator
    let map_operator = MapOperator()
    map_operator.operator_type = operator_type
    map_operator.obj_name = next_or_exit(compiler_t, "[Map] expected some id").name
    if try_get(compiler_t, Token::Comma)
        map_operator.iterator_name = Some(next_or_exit(compiler_t, "[Map] expected some iterator id").name)
    ;
    get_or_exit(compiler_t, Token::CoolArrow, "[Map] expected '=>'")
    loop
        let token = next_or_exit(compiler_t, "[Map] expected some condition")
        if token.token == Token::Eof do break
        map_operator.expression += token.name
    ;
    return map_operator
;
