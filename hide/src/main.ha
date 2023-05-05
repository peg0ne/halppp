inc => vector
get => ncurses, option, bounds, dictionary, json, ngui
get => math, files, stringextensions, list, regex, linq
get => model


fn main =>
    Ncurses::init()
    let model = Model(argc, argv)
    loop
        Ncurses::clearScr()
        model.render()
        if model.run() do break
    ;
    Ncurses::stop()
;

compiler => "&& mkdir -p $HOME/.config/hide"
compiler => "&& cp ../.config/*.json $HOME/.config/hide"