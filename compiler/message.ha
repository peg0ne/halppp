enum MessageSeverity
    Hint,
    Error,
;
fn colored MessageSeverity severity, string msg, string recap =>
    string color = ""
    switch severity
    case MessageSeverity::Hint  dobr color = "\033[34m"
    case MessageSeverity::Error dobr color = "\033[31m"
    ;
    println($"{color}[{severity}] >> {msg} \033[0m")
    println(recap)
;
fn display_message MessageSeverity severity, string msg, string recap => do colored(severity, msg, recap)
fn hint string msg => do display_message(MessageSeverity::Hint, msg, "")
fn error string msg, string recap =>
    display_message(MessageSeverity::Error, msg, recap)
    exit(1)
;
