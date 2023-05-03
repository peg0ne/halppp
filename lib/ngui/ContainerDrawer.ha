fn draw_container_impl IContainer* c =>
    if !c->Active() do return
    switch c->Type()
    case ContainerType::Base dobr c->draw()
    case ContainerType::Grouped dobr ((GroupedContainer*)c)->draw()
    case ContainerType::Vertical dobr ((VerticalLayout*)c)->draw()
    case ContainerType::Horizontal dobr ((HorizontalLayout*)c)->draw()
    case ContainerType::Main dobr ((MainContainer*)c)->draw()
    case ContainerType::Grid dobr ((GridLayout*)c)->draw()
    case ContainerType::FilledRect dobr ((FilledRect*)c)->draw()
    default 
        Ncurses::add(2,0,c->Label())
        Ncurses::add(1,0,(int)c->Type())
        Ncurses::add(0,0,"ERORR")
        Ncurses::key()
        break
    ;
;