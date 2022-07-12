enum MessageSeverity =>
    Hint,
    Error,
;
fn display_message MessageSeverity severity, string msg =>
    print(severity)
    println(msg)
;
fn display_hint_message string msg => void do display_message(Hint, msg)
fn display_err_message string msg =>
    display_message(Error, msg)
    exit(1)
;

