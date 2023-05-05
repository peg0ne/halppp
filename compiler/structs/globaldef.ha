struct Global
    vector<Variable> variables = {}
    Global => do return
    fn to_cpp => string
        let g_str = ""
        foreach v in variables
            g_str += $"\n{GLOBAL}{v.v_type} {v.id}\n"
        ;
        return g_str
    ;
;