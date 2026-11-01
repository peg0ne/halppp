get => files, peekable, vector, stringextensions

struct TreeNode
    string id = ""
    Vector start = Vector()
    Vector end = Vector()
    vector<TreeNode> nodes = {}
    TreeNode => do return
;

fn to_string TreeNode t => string
    let s = $"({t.id} [{t.start.y}, {t.start.x}] - [{t.end.y}, {t.end.x}]"
    foreach n in t.nodes do s += $" {n}"
    return s + ")"
;

fn parse_split Peekable<char> *p =>
    for i until 4 do p->next()
;

fn parse_pos Peekable<char> *p, Vector *v =>
    let y = 0
    let digit_str = ""
    loop
        select ch from p->next()
            if isdigit(ch) doco digit_str += ch
            if ch == ']'
                v->x = String(digit_str).to_num().value_or(0)
                v->y = y
                break
            ;
            if ch == ','
                y = String(digit_str).to_num().value_or(0)
                digit_str = ""
            ;
            continue
        ;
        break
    ;   
;

fn parse_node Peekable<char> *p => TreeNode
    let node = TreeNode()
    loop
        select ch from p->next()
            match ch
                ')' => do break
                ' ' => do continue
                '\n' => do continue
                '(' => doco node.nodes.push_back(parse_node(p))
                '[' =>
                    parse_pos(p, &node.start)
                    parse_split(p)
                    parse_pos(p, &node.end)
                    continue
                ;
                _ => doco node.id += ch
            ;
        ;
        break
    ;
    return node
;

// Single-quote for the POSIX shell; $(...) and `...` still expand inside double quotes
fn sh_quote string arg => string
    let quoted = "'"
    foreach c in arg
        if c == '\'' do quoted += "'\\''"
        else do quoted.push_back(c)
    ;
    return quoted + "'"
;
fn parse_sitter string path => TreeNode
    let content = ""
    let output = system_output($"tree-sitter parse {sh_quote(path)} 2>&1 /dev/null")
    foreach line in output do content += line
    let peekable = Peekable<char>(content)
    peekable.next()
    return parse_node(&peekable)
;
