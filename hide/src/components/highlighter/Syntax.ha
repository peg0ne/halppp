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
    bool dim = false
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
        select is_dim from custom->try_get("dim")
            dim = is_dim->value_or(false)
        ;
        select expression from custom->try_get("expr")
            expr = regex(expression->value_or((string)""))
        ;
    ;
;

class Syntax
    SyntaxType _type = SyntaxType::Plain
    Json _definition = Json()

    bool _is_complete = false
    string _name = "plain"
    vector<SyntaxBox> _boxings = {}
    vector<SyntaxCustom> _customs = {}
    vector<string> _wordlist = {}
    
    Syntax => do return
    Syntax string type =>
        let home = "."
        select home_opt from env("HOME")
            home = home_opt
        ;
        let config = $"{home}/.config/hide/"
        _definition = load_json($"{config}{type}.json")
        select name from _definition.try_get("name")
            _name = name->value_or((string)"")
            _is_complete = true
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
        select wl from _definition.try_get("wordlist")
            for i until wl->size()
                select w from wl->try_get(i)
                    let word = w->value_or((string)"")
                    _wordlist.push_back(word)
                ;
            ;
        ;
    ;
pub
    fn wordlist => vector<string> doremi _wordlist
    fn is_complete => bool doremi _is_complete
    fn name => string doremi _name
    fn type => SyntaxType doremi _type
    fn boxing => vector<SyntaxBox> doremi _boxings
    fn custom => vector<SyntaxCustom> doremi _customs
;