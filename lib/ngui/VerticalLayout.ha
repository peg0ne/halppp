get => GroupedContainer
class VerticalLayout => GroupedContainer
    VerticalLayout =>
        _type = ContainerType::Vertical
    ;
    VerticalLayout Fill f =>
        _type = ContainerType::Vertical
        _fill_x = f
        _fill_y = f
    ;
    VerticalLayout Fill f, Vector s =>
        _type = ContainerType::Vertical
        _fill_x = f
        _fill_y = f
        _size = s
    ;
    VerticalLayout Vector s, Vector o =>
        _type = ContainerType::Vertical
        _size = s
        _offset = o
    ;
    pub fn draw Ncurses *n =>
        if !is_active do return
        update()
        ((GroupedContainer*)this)->draw(n)
    ;
    pub fn update =>
        double available_space = _size.y
        int offset = 0
        int sharers = 0
        int extra = 0
        foreach c in _containers
            if !c->Active() do continue        
            switch c->FillY()
            case Fill::Static dobr available_space -= c->Size().y
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
            c->SetOffset(_offset.x, offset + _offset.y)
            if c->FillY() == Fill::Flex
                c->SetSize(_size.x, (available_space / sharers))
            ;
            if i + 1 == _containers.size()
                c->SetSize(_size.x, c->Size().y + extra)
            ;
            c->SetSize(_size.x, c->Size().y)
            offset += c->Size().y
        ;
    ;
;