struct TreeSitterBlock
    string info = ""
    Vector min = Vector()
    Vector max = Vector()
    TreeSitterBlock string block =>
        let pieces = String(block).split(' ')
        let n = Ncurses()
        if pieces.size() != 5 do return
        this->info = pieces[0]
        this->min = Vector(
            String(pieces[2]).to_num().value_or(0),
            String(pieces[1]).to_num().value_or(0)
        )
        this->max = Vector(
            String(pieces[4]).to_num().value_or(0),
            String(pieces[3]).to_num().value_or(0)
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
    Ncurses *n
    TreeSitter IContainer *container, Ncurses *n, string path, List<string> text, Vector internal_offset, string file_type =>
        this->internal_offset = internal_offset
        this->offset = container->Offset()
        this->size = container->Size()
        this->n = n
        this->path = path + $".tree.{file_type}"
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
        let output = system_output($"tree-sitter parse {path} -q")
        if output.size() == 0 doremi false
        return String(output[output.size() - 1]).contains("ERROR")
    ;
    fn get_tree => vector<TreeSitterBlock>
        let output = system_output($"tree-sitter parse {path}")
        let joined = join_text(output)
        let blocks = String(joined).split('(')
        for i until blocks.size()
            blocks[i] = String(blocks[i]).replace(")", "")
            blocks[i] = String(blocks[i]).replace("[", "")
            blocks[i] = String(blocks[i]).replace("]", "")
            blocks[i] = String(blocks[i]).replace("-", "")
            blocks[i] = String(blocks[i]).replace(",", "")
            blocks[i] = String(blocks[i]).replace("  ", " ")
            blocks[i] = String(blocks[i]).strip()
        ;
        vector<TreeSitterBlock> ts_blocks = {}
        foreach b in blocks
            let ts_block = TreeSitterBlock(b)
            if ts_block.info == "" do continue
            ts_blocks.push_back(ts_block)
        ;
        return ts_blocks
    ;
pub
    fn run =>
        write(text, path)
        if !is_error() dore remove(path)
        let tree = get_tree()
        let end = size.x + offset.x
        foreach i,b in tree
            if b.info != "ERROR" do continue
            let line = lines.len() > b.min.y ? lines.at(b.min.y) : " "
            if b.max.y > b.min.y do b.max.x = line.size()
            if b.min.y >= size.y + internal_offset.y do break
            if b.min.y < internal_offset.y do continue
            n->underline_until(b.min + offset - internal_offset, 256, b.max.x - b.min.x)
            n->mark_until(offset + Vector(-5, b.min.y - internal_offset.y), 256, 5)
            n->col(1)
            n->add_until(offset + Vector(line.size() + 1, b.min.y - internal_offset.y), $"◉ Error", end, true)
            n->col(1,false)
        ;
        remove(path)
    ;
;