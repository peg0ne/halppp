// One translation unit per .ha file for incremental builds
struct Unit
    string name = ""
    string body = ""
    Unit string name, string body =>
        this->name = name
        this->body = body
    ;
;
