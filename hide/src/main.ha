inc => vector
get => ../../lib/[ncurses, option, bounds, math, files]
get => model

fn main =>
    let n = Ncurses()
    let model = Model(argc, argv)
    loop
        n.clearScr()
        model.render()
        if model.run() do break
    ;
;
