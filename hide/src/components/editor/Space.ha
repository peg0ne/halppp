private fn run_space => Command
    let show = GridLayout(Vector(COLS - 2, 4), Vector(1, LINES - 7))
    show.SetColor(-1)
    vector<string> commands = {
        "f - open file explorer",
        "t - split editor horizontally",
        "T - open integrated terminal",
        "v - split editor vertically",
        "h - move to editor left",
        "l - move to editor right",
        "j - move to editor up",
        "k - move to editor down",
        "c - toggle comment",
        "P - paste word from clipboard",
        "p - open command pallete",
        "s - open file searcher",
        "S - open project searcher",
        "-> - move forward",
        "<- - move backwards"
    }
    foreach c in commands
        let ele = new IContainer(Fill::Flex)
        ele->SetContent(List<string>({c}))
        show.add_element(ele)
    ;
    for i until 4 do show.add_row()
    show.draw()
    show.destruct()
    let result = TextEditOrCommand(Command::Nop)
    switch Ncurses::key()
    case 'f' doremi Command::ModeFileEx
    case 't' doremi Command::SplitHorizontal
    case 'T' doremi Command::Terminal
    case 'v' doremi Command::SplitVertical
    case 'h' doremi Command::EditorLeft
    case 'l' doremi Command::EditorRight
    case 'j' doremi Command::EditorUp
    case 'k' doremi Command::EditorDown
    case KEY_LEFT  dobr navigate(false)
    case KEY_RIGHT dobr navigate(true)
    case KEY_UP dobr modify_flex_size(Dir::Up)
    case KEY_DOWN dobr modify_flex_size(Dir::Down)
    case 'c' dobr text_editing(TextEdit::CommentToggle)
    case 'P' dobr paste_from_clip()
    case 'p'
        result = _command_pallete->show()
        select edit from result.textedit do text_editing(edit)
        select command from result.command
            match command
                Command::LSPSearch =>
                    select f from LSP::show_definition(find(false, false), "ha") do open(f.file_name, f.found_at_line)
                ;
                Command::FileSearch =>
                    select fp from LGREP::Lgrep() do open(fp)
                ;
                Command::ContentSearch =>
                    select fp from LGREP::Lgrep(true) do open(fp)
                ;
                _ => doremi command
            ;
        ;
        break
    case 's' 
        select fp from LGREP::Lgrep() do open(fp)
        break
    case 'S'
        select fp from LGREP::Lgrep(true) do open(fp)
        break
    ;
    return Command::ModeNormal
;
