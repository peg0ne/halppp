inc => ncurses.h, curses.h, wchar.h, locale.h, iostream
use => std
compiler => "-lncursesw"

class Ncurses
    WINDOW *win
    Ncurses =>
        setlocale(LC_ALL, "")
        win = initscr()
        noecho()
        keypad(win, false)
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
    fn box_line int y, int x, int len, int pos =>
        foreach i until len
            if i == 0 doco box_char(y, x + i, pos)
            if i == len-1 doco stop_box_char(y, x + i, pos)
            center_box_char(y, x + i, pos)
        ;
    ;
    pub fn box int y, int x, int h, int w =>
        box_line(y, x, w, 0)
        foreach i until h-2
            box_line(y + i + 1, x, w, 1)
        ;
        box_line(y + h - 1, x, w, 2)
    ;
    pub fn use_arrows => void do keypad(win, true)
    pub fn col short c, bool on =>
        if !has_colors() do return
        on ? attron(COLOR_PAIR(c)) : attroff(COLOR_PAIR(c))
    ;
    pub fn col short c => void do col(c, true)
    pub fn bold bool on => void do on ? attron(A_BOLD) : attroff(A_BOLD)
    pub fn clear int y, int len =>
        for i until len
            add(y, i, ' ')
        ;
    ;
    pub fn clearScr => void
        for i until LINES
            clear(i, COLS)
        ;
    ;
    pub fn clearLn int y => void do clear(y, COLS)
    pub fn add int y, int x, char c, bool is_bold =>
        if is_bold do bold(true)
        mvaddch(y,x,c)
        if is_bold do bold(false)
    ;
    pub fn add int y, int x, char c => void do add(y, x, c)
    pub fn add int y, int x, string s, bool is_bold =>
        let len = s.size()
        for i until len
            add(y, x + i, s[i], is_bold)
        ;
    ;
    pub fn add int y, int x, string s => void do add(y, x, s, false)
    pub fn add int y, int x, int s => void do add(y, x, to_string(s), false)
    pub fn add int y, int x, short s => void do add(y, x, to_string(s), false)
    pub fn add int y, int x, float s => void do add(y, x, to_string(s), false)
    pub fn add int y, int x, double s => void do add(y, x, to_string(s), false)
    pub fn v_line int y, int x, int len =>
        for i until len
            add(y + i, x, "|")
        ;
    ;
    pub fn h_line int y, int x, int len =>
        for i until len
            add(y, x + i, "-")
        ;
    ;
    
    pub fn key => char doremi getch()
    pub fn stop =>
        curs_set(1)
        endwin()
    ;
    pub fn start =>
        win = initscr()
        curs_set(0)
    ;
;

