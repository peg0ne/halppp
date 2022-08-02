enum MessageSeverity
    Hint,
    Error,
;
fn colored MessageSeverity severity, string msg, string recap =>
    string color = EMPTY
    switch severity
    case MessageSeverity::Hint  dobr color = "\033[34m"
    case MessageSeverity::Error dobr color = "\033[31m"
    ;
    println(color + "[" + to_string(severity) + "] >> " + msg + "\033[0m")
    println(recap)
;
fn display_message MessageSeverity severity, string msg, string recap => do colored(severity, msg, recap)
fn display_hint_message string msg => do display_message(MessageSeverity::Hint, msg, "")
fn display_err_message string msg, string recap =>
    display_message(MessageSeverity::Error, msg, recap)
    exit(1)
;



