inc => vector
get => ../../lib/[ncurses, option, bounds, dictionary, json]
get => ../../lib/[math, files, stringextensions, list, regex]
get => model

fn main =>
    let n = Ncurses()
    let model = Model(argc, argv)
    loop
        n.clearScr()
        model.render()
        if model.run() do break
    ;
    n.stop()
;

compiler => "&& mkdir -p $HOME/.config/hide"
compiler => "&& cp ../.config/json.json $HOME/.config/hide"
compiler => "&& cp ../.config/ha.json $HOME/.config/hide"
