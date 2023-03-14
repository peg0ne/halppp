get => peekable, stringextensions, files, print
get => json/Json

fn load_json string path => Json
    select s from read(path) doremi Json(s)
    return Json()
;
fn write_json string path, Json content =>
    if content.type() != JsonType::Object do return
    let s = content.as_j_str(false)
    write(s, path)
;