struct TreeSitterBlock
    string info = ""
    string target = ""
    Vector min = Vector()
    Vector max = Vector()
    TreeSitterBlock string block =>
        let pieces = String(block).split(' ')
        if pieces.size() < 5 do return
        this->info = pieces[0]
        let extra = pieces.size() == 6 ? 1 : 0
        if extra == 1
            this->target = pieces[1]
        ;
        this->min = Vector(
            String(pieces[2+extra]).to_num().value_or(0),
            String(pieces[1+extra]).to_num().value_or(0)
        )
        this->max = Vector(
            String(pieces[4+extra]).to_num().value_or(0),
            String(pieces[3+extra]).to_num().value_or(0)
        )
    ;
    fn as_str => string
        return $"BLOCK(info: {info}, min: {min.x},{min.y}, max: {max.x},{max.y})"
    ;
;

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
    fn is_error => bool
        let output = system_output($"tree-sitter parse {path} -q 2> /dev/null")
        if output.size() == 0 doremi false
        let s = String(output[output.size() - 1])
        return s.contains("ERROR") || s.contains("MISSING")
    ;
    fn get_tree => vector<TreeSitterBlock>
        let output = system_output($"tree-sitter parse {path} 2> /dev/null")
        let joined = join_text(output)
        let blocks = String(joined).split('(')
        let block_replacer = [] (string block) {
            return String(block).replace_into(")", "")
                ->replace_into("[", "")
                ->replace_into("]", "")
                ->replace_into("-", "")
                ->replace_into(",", "")
                ->replace_into("  ", " ")
                ->strip();
        }
        blocks = linq::take(blocks).operate_async(block_replacer).as_vec()
        return parse_blocks(blocks)
    ;
    fn parse_blocks vector<string> blocks => vector<TreeSitterBlock>
        vector<TreeSitterBlock> ts_blocks = {}
        foreach b in blocks
            let ts_block = TreeSitterBlock(b)
            if ts_block.info == "" do continue
            ts_blocks.push_back(ts_block)
        ;
        syntax->set_cache(text, ts_blocks)
        return ts_blocks
    ;
pub
    fn run =>
        let tree = syntax->cached_blocks(text)
        if tree.size() == 0
            write(text, path)
            if !is_error() dore remove(path)
            tree = get_tree()
        ;
        let end = size.x + offset.x
        foreach i,b in tree
            if b.info != "ERROR" && b.info != "MISSING" do continue
            let line = lines.len() > b.min.y ? lines.at(b.min.y) : " "
            if b.max.y > b.min.y do b.max.x = line.size()
            if b.min.y >= size.y + internal_offset.y do break
            if b.min.y < internal_offset.y do continue
            Ncurses::underline_until(b.min + offset - internal_offset, 256, b.max.x - b.min.x)
            Ncurses::mark_until(offset + Vector(-5, b.min.y - internal_offset.y), 256, 5)
            Ncurses::col(1)
            Ncurses::add_until(offset + Vector(line.size() + 1, b.min.y - internal_offset.y), $"◉ {b.info} {b.target}", end, true)
            Ncurses::col(1,false)
        ;
        remove(path)
    ;
;