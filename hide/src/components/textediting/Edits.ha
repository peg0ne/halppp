fn insert_snippet List<string> *text, Vector *pos, string snippet =>
    let s = String(text->at(pos->y))
    s.insert(snippet, pos->x)
    text->set(pos->y, s.to_string())
;
fn strip_front List<string> *text, Vector *pos, int amount =>
    let s = String(text->at(pos->y))
    text->set(pos->y, s.strip_front(amount))
;
fn insert_newline List<string> *text, Vector *pos =>
    let s = String(text->at(pos->y))
    text->set(pos->y, s.substr(0, pos->x))
    text->insert(pos->y + 1, s.substr(pos->x))
;
fn remove_char List<string> *text, Vector *pos =>
    let s = String(text->at(pos->y))
    s.remove(pos->x)
    text->set(pos->y, s.to_string())
;
fn remove_line List<string> *text, Vector *pos =>
    if text->len() <= 1 do return
    if pos->y == text->len() - 1 dore text->set(pos->y, " ")
    text->remove(pos->y)
;
fn insert_line List<string> *text, int pos, string line =>
    text->insert(pos, line)
;
fn remove_word List<string> *text, Vector *pos, bool spacebreak =>
    let s = String(text->at(pos->y))
    s.remove_word(pos->x, spacebreak)
    text->set(pos->y, s.to_string())
;
fn remove_until List<string> *text, Vector *pos =>
    text->set(pos->y, text->at(pos->y).substr(0, pos->x))
;
fn to_case List<string> *text, Vector *pos, bool upper =>
    if text->size() == 0 do return
    if text->at(pos->y).size() == 0 do return
    let ch = text->at(pos->y).at(pos->x)
    text->at_ptr(pos->y)->at(pos->x) = upper ? toupper(ch) : tolower(ch)
;
fn commenting List<string> *text, Vector *pos =>
    if text->size() == 0 do return
    if text->at(pos->y).size() == 0 dore text->set(pos->y, "//")
    let s = String(text->at(pos->y))
    if s.starts_with("//")
        text->set(pos->y, s.replace("//", "", 1))
    ;
    else do text->set(pos->y, $"//{s.to_string()}")
;