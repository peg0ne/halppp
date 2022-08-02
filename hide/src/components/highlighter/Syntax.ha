enum SyntaxType
    Plain,
    Halp,
;

struct SyntaxAst
    short color = 0
    vector<string> tokens = {}
    bool is_bold = false
    SyntaxAst => do return
    SyntaxAst vector<string> t, short c, bool b =>
        tokens = t
        color = c
        is_bold = b
    ;
    SyntaxAst Json *ast =>
        select c from ast->try_get("color")
            color = c->value_or((double)0)
        ;
        select b from ast->try_get("bold")
            is_bold = b->value_or(false)
        ;
        select ts from ast->try_get("tokens")
            for i until ts->size()
                select t from ts->try_get(i)
                    tokens.push_back(t->value_or((string)""))
                ;
            ;
        ;
    ;
;

struct SyntaxBox
    vector<short> colors = {}
    string start = ""
    string end = ""
    bool mark_inner = false
    SyntaxBox => do return
    SyntaxBox Json *box =>
        select s from box->try_get("start")
            start = s->value_or((string)"")
            if start == "\\\"" do start = "\""
        ;
        select e from box->try_get("end")
            end = e->value_or((string)"")
            if end == "\\\"" do end = "\""
        ;
        select m from box->try_get("mark_inner")
            mark_inner = m->value_or(false)
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
    bool upper = false
    bool lower = false
    vector<string> extras = {}
    SyntaxCustom => do return
    SyntaxCustom Json *custom =>
        select c from custom->try_get("color")
            color = c->value_or(false)
        ;
        select u from custom->try_get("upper")
            upper = u->value_or(false)
        ;
        select l from custom->try_get("lower")
            lower = l->value_or(false)
        ;
        select es from custom->try_get("extras")
            for i until es->size()
                select e from es->try_get(i)
                    extras.push_back(e->value_or((string)""))
                ;
            ;
        ;
    ;
;

class Syntax
    SyntaxType _type = SyntaxType::Plain
    Json _definition = Json()

    string _name = "plain"
    SyntaxAst _base = SyntaxAst()
    SyntaxAst _names = SyntaxAst()
    SyntaxAst _types = SyntaxAst()
    SyntaxAst _keywords = SyntaxAst()
    SyntaxAst _operators = SyntaxAst()
    SyntaxAst _constants = SyntaxAst()
    SyntaxAst _conditions = SyntaxAst()
    vector<SyntaxBox> _boxings = {}
    vector<SyntaxCustom> _customs = {}
    
    Syntax => do return
    Syntax string type =>
        _definition = load_json(type + ".json")
        select name from _definition.try_get("name")
            _name = name->value_or((string)"")
        ;
        select base from _definition.try_get("base")
            _base = SyntaxAst(base)
        ;
        select names from _definition.try_get("names")
            _names = SyntaxAst(names)
        ;
        select types from _definition.try_get("types")
            _types = SyntaxAst(types)
        ;
        select keywords from _definition.try_get("keywords")
            _keywords = SyntaxAst(keywords)
        ;
        select operators from _definition.try_get("operators")
            _operators = SyntaxAst(operators)
        ;
        select constants from _definition.try_get("constants")
            _constants = SyntaxAst(constants)
        ;
        select conditions from _definition.try_get("conditions")
            _conditions = SyntaxAst(conditions)
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
    fn ast => List<SyntaxAst>
        List<SyntaxAst> asts = List<SyntaxAst>()
        asts.add(_base)
        asts.add(_names)
        asts.add(_types)
        asts.add(_keywords)
        asts.add(_operators)
        asts.add(_constants)
        asts.add(_conditions)
        return asts
    ;
;    

