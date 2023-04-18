struct TextEditOrCommand
    Option<TextEdit> textedit = None<TextEdit>()
    Option<Command> command = None<Command>()
    TextEditOrCommand TextEdit edit => do this->textedit = edit
    TextEditOrCommand Command command => do this->command = command
;

class CommandPallete 
    int pos = 0
    string search = ""
    Dictionary<string, Command> commands = Dictionary<string, Command>()
    Dictionary<string, TextEdit> textedits = Dictionary<string, TextEdit>()
    List<string> buf = List<string>()
    IContainer pallete_found = IContainer()
    IContainer pallete_search = IContainer(Fill::Static, Vector(0, 1))
    VerticalLayout pallete_window = VerticalLayout(
        Vector(COLS/2, 10),
        Vector(COLS/4, LINES/4))
    
    CommandPallete =>
        add_commands()
        add_text_edits()
        pallete_window.SetColor(-3)
        pallete_search.SetColor(2)
        pallete_window.add(&pallete_search)
        pallete_window.add(&pallete_found)
    ;
    fn add_commands =>
        commands.add(" exit", Command::Exit)
        commands.add(" mode normal", Command::ModeNormal)
        commands.add(" mode insert", Command::ModeInsert)
        commands.add(" mode visual", Command::ModeVisual)
        commands.add(" mode file explorer", Command::ModeFileEx)
        commands.add(" mode file explorer", Command::ModeCmdHan)
        commands.add(" editor write", Command::WriteEditor)
        commands.add(" editor close", Command::CloseEditor)
        commands.add(" editor close forced", Command::CloseEditorForced)
        commands.add(" editor write and close", Command::WriteCloseEditor)
        commands.add(" editor split horizontal", Command::SplitHorizontal)
        commands.add(" editor split vertical", Command::SplitVertical)
        commands.add(" editor move left", Command::EditorLeft)
        commands.add(" editor move right", Command::EditorRight)
        commands.add(" editor move up", Command::EditorUp)
        commands.add(" editor move down", Command::EditorDown)
        commands.add(" templates", Command::EditorTemplates)
        commands.add(" search", Command::EditorSearch)
        commands.add(" replace", Command::EditorReplace)
    ;
    fn add_text_edits =>
        textedits.add(" tab", TextEdit::Tab)
        textedits.add(" untab", TextEdit::Untab)
        textedits.add(" insert new line", TextEdit::InsertNl)
        textedits.add(" remove char behind cursor", TextEdit::RemoveChar)
        textedits.add(" remove char under cursor", TextEdit::DeleteChar)
        textedits.add(" remove word", TextEdit::DeleteWord)
        textedits.add(" remove word without removing extra space", TextEdit::DeleteWordExlusive)
        textedits.add(" remove line", TextEdit::DeleteLine)
        textedits.add(" remove from cursor to end", TextEdit::DeleteFrom)
        textedits.add(" paste line/lines from buffer below", TextEdit::PasteLine)
        textedits.add(" paste line/lines from buffer on to current lien", TextEdit::PasteWord)
        textedits.add(" lower case", TextEdit::Lower)
        textedits.add(" upper case", TextEdit::Upper)
        textedits.add(" toggle comment", TextEdit::CommentToggle)
    ;
pub
    fn show Ncurses *n => TextEditOrCommand
        let match = ""
        let offset = 0
        search = ""
        pos = 0
        loop
            let offset_used = 0
            let i = 0
            pallete_search.SetLabel(" " + search)
            buf.clear()
            > is_found this (string cmd) doremi cmd.find(search) != -1
            > operation this, &i, offset (string cmd)
                if (i++ < offset) doremi false
                buf.add(cmd)
                return true
            ;
            linq::take(commands.keys())
                .join(textedits.keys())
                .where(is_found)
                .operate<bool>(operation)
            pallete_found.SetContent(buf)
            pallete_window.draw(n)
            n->mark_until(LINES/4 + 1 + pos, COLS/4, 4, COLS/2)
            let key = n->key()
            switch key
            case KEY_DOWN dobr pos++
            case KEY_UP dobr pos--
            case KEY_PPAGE dobr pos-=1000
            case KEY_NPAGE dobr pos+=1000
            case 27 doremi Command::ModeNormal
            case '\n'
                if pos >= buf.size() do break
                match = buf.at(pos)
                select cmd from commands.try_get_value(match) doremi TextEditOrCommand(cmd)
                select edit from textedits.try_get_value(match) doremi TextEditOrCommand(edit)
                break
            case '\b'
            case 127
            case KEY_BACKSPACE
                if search.size() == 0 do break
                search.pop_back()
                break
            default
                if isgraph(key) do search += key
                break
            ;
            if pos > buf.size() - 1 do pos = buf.size() - 1
            if pos > 8
                pos = 8
                offset++
            ;
            if pos < 0
                pos = 0
                if offset > 0 do offset--
            ;
        ;
        return TextEditOrCommand(Command::Nop)
    ;
;