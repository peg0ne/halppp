get => GroupedContainer
class HorizontalLayout => GroupedContainer
    HorizontalLayout =>
        _type = ContainerType::Horizontal
    ;
    HorizontalLayout Fill f =>
        _type = ContainerType::Horizontal
        _fill_x = f
        _fill_y = f
    ;
    HorizontalLayout Fill f, Vector s =>
        _type = ContainerType::Horizontal
        _fill_x = f
        _fill_y = f
        _size = s
    ;
    HorizontalLayout Vector s, Vector o =>
        _type = ContainerType::Horizontal
        _size = s
        _offset = o
    ;
    pub fn draw Ncurses *n =>
        if !is_active do return
        update()
        ((GroupedContainer*)this)->draw(n)
    ;
    pub fn update =>
        double available_space = _size.x
        int offset = 0
        int sharers = 0
        int extra = 0
        foreach c in _containers
            if !c->Active() do continue
            switch c->FillX()
            case Fill::Static dobr available_space -= c->Size().x
            case Fill::Flex dobr sharers++
            ;
        ;
        if sharers != 0
            int space = available_space/sharers
            int diff = available_space - (space * sharers)
            extra = diff
        ;
        for i until _containers.size()
            let c = _containers.at(i)
            if !c->Active() do continue        
            c->SetOffset(offset + _offset.x, _offset.y)
            if c->FillX() == Fill::Flex
                c->SetSize((available_space / sharers), _size.y)
            ;
            if i + 1 == _containers.size()
                c->SetSize(c->Size().x + extra, _size.y)
            ;
            c->SetSize(c->Size().x, _size.y)
            offset += c->Size().x
        ;
    ;
;