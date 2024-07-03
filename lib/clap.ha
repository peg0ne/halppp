get => option

struct Clap
private
    int _argc = 0
    char **_argv
pub
    fn at int index => Option<string>
        if index >= _argc doremi None<string>()
        return Some((string)_argv[index])
    ;
    fn has string check => bool
        for i until _argc
            if _argv[i] == check doremi true
        ;
        return false
    ;
    fn peek string check => Option<string>
        for i until _argc
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
