inc => ncurses.h, curses.h, wchar.h, locale.h, iostream, cstring
use => std
compiler => "-lncursesw"

class Ncurses
    WINDOW *win
    Ncurses =>
        setlocale(LC_ALL, "")
        win = initscr()
        noecho()
        keypad(win, true)
        if has_colors()
            start_color()
            init_pair(1, COLOR_RED, COLOR_BLACK)
            init_pair(2, COLOR_YELLOW, COLOR_BLACK)
            init_pair(3, COLOR_GREEN, COLOR_BLACK)
            init_pair(4, COLOR_BLACK, COLOR_RED)
            init_pair(5, COLOR_BLACK, COLOR_YELLOW)
            init_pair(6, COLOR_BLACK, COLOR_GREEN)
        ;
    ;
    fn box_char int y, int x, int pos =>
        if pos == 0 dore add(y,x,"*")
        if pos == 1 dore add(y,x,"|")
        if pos == 2 dore add(y,x,"*")
        if pos == 3 dore add(y,x," ")
    ;
    fn stop_box_char int y, int x, int pos =>
        if pos == 0 dore add(y, x, "*")
        if pos == 1 dore add(y, x, "|")
        if pos == 2 dore add(y, x, "*")
        if pos == 3 dore add(y, x, " ")
    ;
    fn center_box_char int y, int x, int pos =>
        if pos == 1 dore add(y, x, " ")
        if pos == 3 dore add(y, x, " ")
        add(y, x, "-")
    ;
    fn box_line int y, int x, int len, int pos, bool invis =>
        if invis do pos = 3
        for i until len
            if i == 0 doco box_char(y, x + i, pos)
            if i == len-1 doco stop_box_char(y, x + i, pos)
            center_box_char(y, x + i, pos)
        ;
    ;
pub
    fn mark_until int y, int x, short color, int len =>
        mvchgat(y, x, len, A_BLINK, color, NULL)
    ;
    fn mark int y, int x, short color => do mark_until(y, x, color, 1)
    fn box int y, int x, int h, int w, bool invis =>
        box_line(y, x, w, 0, invis)
        if y + 1 >= LINES do return
        for i until h-2 do box_line(y + i + 1, x, w, 1, invis)
        if y + h - 1 >= LINES do return
        box_line(y + h - 1, x, w, 2, invis)
    ;
    fn box int y, int x, int h, int w => do box(y, x, h, w, false)
    fn invis_box int y, int x, int h, int w => do box(y, x, h, w, true)
    fn use_arrows => do keypad(win, true)
    fn col short c, bool on =>
        if !has_colors() do return
        on ? attron(COLOR_PAIR(c)) : attroff(COLOR_PAIR(c))
    ;
    fn col short c => do col(c, true)
    fn bold bool on => do on ? attron(A_BOLD) : attroff(A_BOLD)
    fn clear int y, int len =>
        for i until len do add(y, i, ' ')
    ;
    fn clearScr => void
        for i until LINES do clear(i, COLS)
    ;
    fn clearLn int y => do clear(y, COLS)
    fn add int y, int x, char c, bool is_bold =>
        if is_bold do bold(true)
        mvaddch(y,x,c)
        if is_bold do bold(false)
    ;
    fn add int y, int x, char c => do add(y, x, c, false)
    fn add int y, int x, string s, bool is_bold =>
        if is_bold do bold(true)
        char ch[s.size() + 1]
        strcpy(ch, s.c_str())
        mvaddstr(y,x,ch)
        if is_bold do bold(false)
    ;
    fn add int y, int x, string s => do add(y, x, s, false)
    fn add int y, int x, int s => do add(y, x, to_string(s), false)
    fn add int y, int x, short s => do add(y, x, to_string(s), false)
    fn add int y, int x, float s => do add(y, x, to_string(s), false)
    fn add int y, int x, double s => do add(y, x, to_string(s), false)
    fn add_until int y, int x, string s, int limit, bool is_bold =>
        add(y, x, s.substr(0,limit-x), is_bold)
    ;
    fn v_line int y, int x, int len =>
        for i until len do add(y + i, x, "|")
    ;
    fn h_line int y, int x, int len =>
        for i until len do add(y, x + i, "-")
    ;
    fn key => auto doremi getch()
    fn stop =>
        curs_set(1)
        endwin()
    ;
    fn start =>
        win = initscr()
        curs_set(0)
    ;
;