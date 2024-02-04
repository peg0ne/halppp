struct MapOperator
    string obj_name = EMPTY
    string expression = EMPTY
    Token operator_type = Token()
    Option<string> iterator_name = None<string>()
    MapOperator => do return
    fn to_ha int order, string operate_on => string
        let map_op_str = $"> {get_lambda_name(order)} = ()\n"
        map_op_str += $"let {obj_name}_as_opt = {operate_on}"
        map_op_str += order > 0 ? "()\n" : "\n"
        map_op_str += $"let {obj_name} = {obj_name}_as_opt"
        map_op_str += order > 0 ? ".value_unsafe()\n" : "\n"
        map_op_str += $"return "
        if order > 0 do map_op_str += $"{obj_name}_as_opt.is_some()"
        switch operator_type
            case Token::Where 
                if order > 0 do map_op_str += " && "
                map_op_str += $"{expression} ? Some({obj_name}) : None({obj_name})\n"
                break
            case Token::Select
                if order > 0 do map_op_str += $" ? Some({expression}) : None({expression})\n"
                else do map_op_str += $"Some({expression})\n"
                break
        ;
        map_op_str += "\n;\n"
        return map_op_str
    ;
    fn get_lambda_name int order => string
        let lambda_name = $"{obj_name}_lambda_z"
        for i until order do lambda_name += "z"
        return lambda_name
    ;
;

struct Map
    string assigning_value = EMPTY
    string operator_on_value = EMPTY
    string type_to_output = EMPTY
    vector<MapOperator> operations = {}
    Map => do return
    fn to_ha => string
        let iterator_obj = $"{assigning_value}_out_map_value_xzxzxzxzxzx"
        let map_str = $"{iterator_obj} in {operator_on_value}\n"
        foreach i, operation in operations
            map_str += i == 0 ? operation.to_ha(i, iterator_obj) : operation.to_ha(i, operations[i - 1].get_lambda_name(i - 1))
            if i == operations.size() - 1
                map_str += $"\nselect map_{iterator_obj}_out_sdfgsg from {operation.get_lambda_name(i)}()\n"
                map_str += $"\n{assigning_value}.push_back(map_{iterator_obj}_out_sdfgsg)\n;\n;\n"
            ;
        ;
        return map_str        
    ;
    fn to_cpp => string
        let ast = ast_create(to_ha())
        let program = Program()
        let compiler_t = Compiler(&program, ast, 0)
        let map_str = $"vector<{type_to_output}> {assigning_value};\n"
        map_str += for_construct(&compiler_t, true).to_cpp(0)
        return map_str
    ;
;
