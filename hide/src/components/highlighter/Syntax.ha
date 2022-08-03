enum SyntaxType
    Plain,
    Halp,
;

struct SyntaxBox
    vector<short> colors = {}
    string start = ""
    string end = ""
    SyntaxBox => do return
    SyntaxBox Json *box =>
        select s from box->try_get("start")
            start = s->value_or((string)"")
        ;
        select e from box->try_get("end")
            end = e->value_or((string)"")
        ;
        select cs from box->try_get("colors")
            for i until cs->size()
                select c from cs->try_get(i)
                    colors.push_back((short)c->value_or(0.0))
                ;
            ;
        ;
    ;
;

struct SyntaxCustom
    short color = 0
    int capture = 0
    bool bold = false
    regex expr
    SyntaxCustom => do return
    SyntaxCustom Json *custom =>
        select col from custom->try_get("color")
            color = col->value_or(0.0)
        ;
        select cap from custom->try_get("capture")
            capture = cap->value_or(0.0)
        ;
        select is_bold from custom->try_get("bold")
            bold = is_bold->value_or(false)
        ;
        select expression from custom->try_get("expr")
            expr = regex(expression->value_or((string)""))
        ;
    ;
;

class Syntax
    SyntaxType _type = SyntaxType::Plain
    Json _definition = Json()

    string _name = "plain"
    vector<SyntaxBox> _boxings = {}
    vector<SyntaxCustom> _customs = {}
    
    Syntax => do return
    Syntax string type =>
        _definition = load_json(type + ".json")
        select name from _definition.try_get("name")
            _name = name->value_or((string)"")
        ;
        select boxings from _definition.try_get("boxing")
            for i until boxings->size()
                select box from boxings->try_get(i)
                    _boxings.push_back(SyntaxBox(box))
                ;
            ;
        ;
        select customs from _definition.try_get("custom")
            for i until customs->size()
                select custom from customs->try_get(i)
                    _customs.push_back(SyntaxCustom(custom))
                ;
            ;
        ;
    ;
pub
    fn name => string doremi _name
    fn type => SyntaxType doremi _type
    fn boxing => vector<SyntaxBox> doremi _boxings
    fn custom => vector<SyntaxCustom> doremi _customs
;    

