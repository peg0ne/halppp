get => TreeNode

enum SyntaxType
    Plain,
    Halp,
;

struct SyntaxTemplate
    string template_name = ""
    vector<string> templates = {}
    SyntaxTemplate => do return
    SyntaxTemplate Json *temp =>
        template_name = temp->try_get_value_of("name", (string)"")
        select temps from temp->try_get("template")
            for i until temps->size()
                select t from temps->try_get(i)
                    templates.push_back(t->value_or((string)""))
                ;
            ;
        ;
    ;
;

struct SyntaxBox
    vector<short> colors = {}
    string start = ""
    string end = ""
    SyntaxBox => do return
    SyntaxBox Json *box =>
        start = box->try_get_value_of("start", (string)"")
        end = box->try_get_value_of("end", (string)"")
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
        color = custom->try_get_value_of("color", 0.0)
        capture = custom->try_get_value_of("capture", 0.0)
        bold = custom->try_get_value_of("bold", false)
        dim = custom->try_get_value_of("dim", false)
        expr = regex(custom->try_get_value_of("expr", (string)"*"))
    ;
;

struct SyntaxRule
    string type
    string value
    regex expr
    int capture
    string validation_type
    string validation_value
    SyntaxRule => do return
    SyntaxRule Json *rule =>
        type = rule->try_get_value_of("type", (string)"")
        value = rule->try_get_value_of("value", (string)"")
        expr = regex(rule->try_get_value_of("regex", (string)"*"))
        capture = rule->try_get_value_of("capture", 0.0)
        validation_type = rule->try_get_value_of("validate", (string)"")
        validation_value = rule->try_get_value_of("validation_value", (string)"")
    ;
;

class Syntax
    SyntaxType _type = SyntaxType::Plain
    Json _definition = Json()

    bool _is_complete = false
    string _cached_tree = ""
    Option<TreeNode> _cached_node = None<TreeNode>()
    string _name = "plain"
    string _file_type = ".txt"
    vector<SyntaxBox> _boxings = {}
    vector<SyntaxCustom> _customs = {}
    vector<string> _wordlist = {}
    vector<SyntaxRule> _rules = {}
    vector<SyntaxTemplate> _templates = {}
    
    Syntax => do return
    Syntax string type =>
        this->_file_type = type
        let home = "."
        select home_opt from env("HOME")
            home = home_opt
        ;
        let config = $"{home}/.config/hide/"
        _definition = load_json($"{config}{type}.json")
        load_from_json(_definition)
    ;
    Syntax Json config => do load_from_json(config)
    fn load_from_json Json config =>
        _definition = config
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
        select rules from _definition.try_get("rules")
            for i until rules->size()
                select rule from rules->try_get(i)
                    _rules.push_back(SyntaxRule(rule))
                ;
            ;
        ;
        select templates from _definition.try_get("templates")
            for i until templates->size()
                select temp from templates->try_get(i)
                    _templates.push_back(SyntaxTemplate(temp))
                ;
            ;
        ;
        select colors from _definition.try_get("colors")
            for i until colors->size()
                select color from colors->try_get(i)
                    let pair = (short)color->try_get_value_of("color", 100.0)
                    let fg = (short)color->try_get_value_of("fg", 7.0)
                    let bg = (short)color->try_get_value_of("bg", 0.0)
                    init_pair(pair, fg, bg)
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
    fn rules => vector<SyntaxRule> doremi _rules
    fn templates => vector<SyntaxTemplate> doremi _templates
    fn file_type => string doremi _file_type
    fn cached_blocks string key => Option<TreeNode>
        if key == _cached_tree doremi _cached_node
        return None<TreeNode>()
    ;
    fn set_cache string tree, TreeNode root =>
        _cached_tree = tree
        _cached_node = root
    ;
    fn destruct => do _definition.destruct()
;
