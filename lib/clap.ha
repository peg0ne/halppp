get => option

struct Clap
private
    int _argc = 0
    char **_argv
pub
    fn has string check => bool
        foreach i until _argc
            if _argv[i] == check doremi true
        ;
        return false
    ;
    fn peek string check => Option<string>
        foreach i until _argc
            if _argv[i] != check do continue
            if i > _argc-2 do break
            return (string)_argv[i + 1]
        ;
        return None<string>()
    ;
    Clap int argc, char **argv =>
        _argc = argc
        _argv = argv
    ;
;