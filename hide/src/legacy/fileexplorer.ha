struct FileExplorer => IComponent
    Ncurses *n
    string path = ""
    bool is_active = true
    int pos = 0
    FileExplorer Ncurses *n, string path =>
        this->n = n
        this->anchor_x = AnchorX::Left
        this->anchor_y = AnchorY::Bottom
        this->fill_x = Fill::Percent
        this->fill_y = Fill::Full
        this->size = Vector(25, 0)
        this->offset = Vector(0, 2)
        this->color = 2
        this->path = path
        this->content = list_files(".")
    ;
    fn run => Command
        loop
            switch n->key()
            case 'j' dobr move(Dir::Up)
            case 'k' dobr move(Dir::Down)
            case '\n' 
                select c from choose() doremi c
                break
            case 27 do return Command::ModeNormal
            default do break
            ;
        ;
    ;
    fn get_fp => string
        string fp = path.substr(2)
        path = "."
        content = list_files(path)
        return fp
    ;
    fn move_and_reset => Option<Command> doremi move_and_reset(None<Command>())
    fn move_and_reset Command cmd => Option<Command> doremi move_and_reset(Some(cmd))
    fn move_and_reset Option<Command> cmd => Option<Command>
        content = list_files(path)
        pos = 0
        move(Dir::Up)
        return cmd
    ;
    fn choose => Option<Command>
        let p = this->content.at(pos)
        if p == "." doremi None<Command>()
        if p == ".." && path != "."
            let i = 0
            while path.back() != '/'
                path.pop_back()
            ;
            path.pop_back()
            return move_and_reset()
        ;
        this->path += "/" + this->content.at(pos)
        this->content = list_files(path)
        if this->content.size() == 0 doremi move_and_reset(Command::SelectFile)
        return move_and_reset()
    ;
    fn move Dir dir =>
        switch dir
        case Dir::Up dobr pos = clamp(pos - 1, 0, content.size() - 1)
        case Dir::Down dobr pos = clamp(pos + 1, 0, content.size() - 1)
        ;
        draw(true)
    ;
    fn draw bool is_active =>
        if !is_active do return
        let origin = content
        vector<string> buf = {}
        foreach line in content do buf.push_back(" " + line)
        content = buf
        ((IComponent*)this)->draw(n)
        content = origin
        n->mark_until(pos, 0, 6, size.x - 1)
    ;
;
 
