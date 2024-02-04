fn map_construct Compiler *compiler_t, string id, bool is_let => Expression
    let map_value = Map()
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
    get_or_exit(compiler_t, Token::LParen, "[Map] expected '('")
    let paren_depth = 1
    // Get the item to operate on
    loop
        let token = next_or_exit(compiler_t, "[Map] expected some variable/expression and ending ')'")
        if token.token == Token::LParen do paren_depth++
        if token.token == Token::RParen do paren_depth--
        if paren_depth == 0 do break
        map_value.operator_on_value += token.name
    ;
    // Get the map operations
    loop
        if try_get(compiler_t, Token::NewLine)
            next_or_exit(compiler_t, "[Map] unkown error")
            if try_get(compiler_t, Token::Period) dobr compiler_t->prev()
        ;
        get_or_exit(compiler_t, Token::Period, "[Map] expected '.'")
        let operator_type = next_or_exit(compiler_t, "[Map] expected operator type")
        if none(operator_type.token, {Token::Select, Token::Where}) do error($"[Map] invalid operator type {operator_type.name}", compiler_t->recap())
        get_or_exit(compiler_t, Token::LParen, "[Map] expected '('")
        map_value.operations.push_back(map_operator_construct(compiler_t, operator_type.token))
    ;
    if map_value.operations.size() == 0 do error("[Map] expected operations but got none", compiler_t->recap())
    return Expression(map_value.to_cpp(), true)
;

fn map_operator_construct Compiler *compiler_t, Token operator_type => MapOperator
    let map_operator = MapOperator()
    map_operator.operator_type = operator_type
    map_operator.obj_name = next_or_exit(compiler_t, "[Map] expected some id").name
    if try_get(compiler_t, Token::Comma)
        map_operator.iterator_name = Some(next_or_exit(compiler_t, "[Map] expected some iterator id").name)
    ;
    get_or_exit(compiler_t, Token::CoolArrow, "[Map] expected '=>'")
    let paren_depth = 1
    loop
        let token = next_or_exit(compiler_t, "[Map] expected some condition")
        if token.token == Token::LParen do paren_depth++
        if token.token == Token::RParen do paren_depth--
        if paren_depth == 0 do break
        map_operator.expression += token.name
    ;
    return map_operator
;
