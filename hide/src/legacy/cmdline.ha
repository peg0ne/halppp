struct CommandLine => IComponent
    Ncurses *n
    CommandLine Ncurses *n =>
        this->anchor_x = AnchorX::Left
        this->anchor_y = AnchorY::Bottom
        this->fill_x = Fill::Full
        this->fill_y = Fill::Static
        this->size = Vector(0, 1)
        this->color = 3
        this->n = n
        this->content = {""}
    ;
    fn draw => do ((IComponent*)this)->draw(n)
    fn remove_ch => Option<Command>
        if content.at(0).size() == 0 do return None<Command>()
        content.at(0).pop_back()
        if content.at(0).size() == 0 doremi Some(Command::ModeNormal)
        return None<Command>()
    ;
    fn try_parse => Option<Command>
        let cmd = content.at(0)
        if cmd == ":q" 
            content.at(0) = ""
            return Some(Command::Exit)
        ;
        content.at(0) = ":"
        return None<Command>()
    ;
    fn run => Command
        content.at(0) = ":"
        draw()
        loop
            let key = n->key()
            switch key
            case 27 
                content.at(0) = ""
                return Command::ModeNormal
            case '\n'
                select c from try_parse() doremi c
                break
            case 127
                select c from remove_ch() doremi c
                break
            default
                string ch(1, key)
                content.at(0) += ch
                break
            ;
            draw()
        ;
    ;
;
