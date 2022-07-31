enum SyntaxType
    Plain,
    Halp,
;

class Syntax
    SyntaxType _type = SyntaxType::Plain
    Json _definition
    Syntax => do return
    Syntax string type =>
        _definition = load_json(type + ".json")
        select name from _definition.try_get("name")
            let n = Ncurses()
            n.add(0,0,name->value_or((string)""))
            n.key()
        ;
    ;
;    
