get => option

struct Clap
    int _argc = 0
    char **_argv
    pub fn has string check => bool
        foreach i until _argc
            if _argv[i] == check
            doremi true
            ;
        ;
        return false
    ;
    pub fn peek string check => Option<string>
        foreach i until _argc
            if !(_argv[i] == check)
                continue
            ;
            if i > _argc-2 
                break
            ;
            return (string)_argv[i+1]
        ;
        return None<string>()
    ;
    Clap int argc, char **argv =>
        _argc = argc
        _argv = argv
    ;
;

fn main =>
    Clap clap(argc, argv)
    cout << clap.has("a") << "\n"
    cout << clap.peek("a").value_or("none") << "\n"
    return 0