struct Global
    vector<Variable> variables = {}
    Global => do return
    fn to_cpp => string
        string g_str = EMPTY
        foreach v in variables
            g_str += NEWLINE
            g_str += GLOBAL + v.v_type
            g_str += SPACE + v.id
            g_str += NEWLINE
        ;
        return g_str
    ;
;
