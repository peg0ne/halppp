inc => vector
get => ncurses, option, bounds, dictionary, json, ngui
get => math, files, stringextensions, list, regex, linq
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
compiler => "&& cp ../.config/*.json $HOME/.config/hide"