class TreeSitter
    Vector internal_offset = Vector()
    Vector offset = Vector()
    Vector size = Vector()
    string path = ""
    string text = ""
    List<string> lines = List<string>()
    Syntax *syntax
    TreeSitter IContainer *container, string path, List<string> text, Vector internal_offset, Syntax *s =>
        this->internal_offset = internal_offset
        this->offset = container->Offset()
        this->size = container->Size()
        this->syntax = s
        this->path = $"temp_tree_sitter.{s->file_type()}"
        this->lines = text
        this->text = join_text(text)
    ;
    fn join_text vector<string> text => string doremi join_text(List<string>(text))
    fn join_text List<string> text => string
        let s = ""
        foreach line in text do s += line + "\n"
        return s
    ;
    fn draw_internal_nodes TreeNode n, int end => 
        foreach i_n in n.nodes do draw_node(i_n, end)
    ;
    fn draw_node TreeNode n, int end =>
        let n_str = String(n.id)
        if !n_str.contains("ERROR") && !n_str.contains("MISSING") dore draw_internal_nodes(n, end)
        let line = lines.len() > n.start.y ? lines.at(n.start.y) : " "
        if n.end.y > n.start.y do n.end.x = line.size()
        if n.start.y >= size.y + internal_offset.y do return
        if n.start.y < internal_offset.y dore draw_internal_nodes(n, end)
        Ncurses::underline_until(n.start + offset - internal_offset, 256, n.end.x - n.start.x)
        Ncurses::mark_until(offset + Vector(-5, n.start.y - internal_offset.y), 256, 5)
        Ncurses::col(1)
        Ncurses::add_until(offset + Vector(line.size() + 1, n.start.y - internal_offset.y), $"◉ {n.id}", end, true)
        Ncurses::col(1,false)
        draw_internal_nodes(n, end)
    ;
pub
    fn run =>
        let end = size.x + offset.x
        let tree = syntax->cached_blocks(text)
        select root from tree dore draw_node(root, end)

        write(text, path)
        let root = parse_sitter(path)
        syntax->set_cache(text, root)
        draw_node(root, end)
        remove(path)
    ;
;