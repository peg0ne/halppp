enum SyntaxType
    Plain,
    Halp,
;

struct SyntaxAst
    string token = " "
    short color = 0
    bool is_bold = false
    SyntaxAst => do return
    SyntaxAst string t, short c, bool b =>
        token = t
        color = c
        is_bold = b
    ;
;

class Syntax
    SyntaxType _type = SyntaxType::Plain
    Json _definition = Json()
    string _name = "plain"
    List<SyntaxAst> _ast = List<SyntaxAst>()
    Syntax => do return
    Syntax string type =>
        let n = Ncurses()
        _definition = load_json(type + ".json")
        select name from _definition.try_get("name")
            _name = name->value_or((string)"")
        ;
        select ast from _definition.try_get("ast")
        for i until ast->size()
            select token from ast->try_get(i)
            select t from token->try_get("token")
            select c from token->try_get("color")
                _ast.add(
                    SyntaxAst(
                    t->value_or((string)""), 
                    c->value_or(0.0), 
                    false
                    )
                )
            ;;;
        ;;
    ;
pub
    fn ast => List<SyntaxAst> doremi _ast
    fn name => string doremi _name
    fn type => SyntaxType doremi _type
;    
