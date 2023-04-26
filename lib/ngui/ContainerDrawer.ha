fn draw_container_impl IContainer* c, Ncurses *n =>
    if !c->Active() do return
    switch c->Type()
    case ContainerType::Base dobr c->draw(n)
    case ContainerType::Grouped dobr ((GroupedContainer*)c)->draw(n)
    case ContainerType::Vertical dobr ((VerticalLayout*)c)->draw(n)
    case ContainerType::Horizontal dobr ((HorizontalLayout*)c)->draw(n)
    case ContainerType::Main dobr ((MainContainer*)c)->draw(n)
    case ContainerType::Grid dobr ((GridLayout*)c)->draw(n)
    case ContainerType::FilledRect dobr ((FilledRect*)c)->draw(n)
    default 
        n->add(2,0,c->Label())
        n->add(1,0,(int)c->Type())
        n->add(0,0,"ERORR")
        n->key()
        break
    ;
;