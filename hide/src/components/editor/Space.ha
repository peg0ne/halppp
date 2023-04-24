private fn run_space => Command
    let show = GridLayout(Vector(COLS, 4), Vector(0, LINES - 7))
    show.SetColor(-1)
    vector<string> commands = {
        "f - open file explorer",
        "t - split editor horizontally",
        "v - split editor vertically",
        "h - move to editor left",
        "l - move to editor right",
        "j - move to editor up",
        "k - move to editor down",
        "c - toggle comment",
        "P - paste word from clipboard",
        "p - open command pallete",
        "s - open file searcher",
        ""
    }
    foreach c in commands
        let ele = new IContainer(Fill::Flex)
        ele->SetContent(List<string>({c}))
        show.add_element(ele)
    ;
    for i until 4 do show.add_row()
    show.draw(n)
    show.destruct()
    let result = TextEditOrCommand(Command::Nop)
    switch n->key()
    case 'f' doremi Command::ModeFileEx
    case 't' doremi Command::SplitHorizontal
    case 'v' doremi Command::SplitVertical
    case 'h' doremi Command::EditorLeft
    case 'l' doremi Command::EditorRight
    case 'j' doremi Command::EditorUp
    case 'k' doremi Command::EditorDown
    case 'c' dobr text_editing(TextEdit::CommentToggle)
    case 'P' dobr paste_from_clip()
    case 'p'
        result = _command_pallete->show(n)
        select edit from result.textedit do text_editing(edit)
        select command from result.command doremi command
        break
    case 's' 
        select fp from Lgrep(n) do open(fp)
        break
    ;
    return Command::ModeNormal
;