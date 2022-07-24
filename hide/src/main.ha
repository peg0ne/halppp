inc => vector
get => ../../lib/[ncurses, option, bounds, math]
get => model

fn main =>
    let n = Ncurses()
    let model = Model(argc, argv)
    loop
        // model.draw(&n)
        if n.key() == 'q' do break
    ;
    n.stop()
;
