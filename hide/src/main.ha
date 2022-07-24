inc => vector
get => ../../lib/[ncurses, option, bounds, math]
get => model

fn main =>
    let n = Ncurses()
    let model = Model(argc, argv)
    loop
        n.clearScr()
        model.render()
        switch n.key()
        case 'q'
            n.stop()
            return 0
        case 'h'
            model.add_editor()
            break
        case 'v'
            model.add_space()
            break
        case 'f'
            model.file_ex()
            break
        default do break
        ;
    ;
;
