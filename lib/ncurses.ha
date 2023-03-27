inc => ncurses.h, curses.h, wchar.h, locale.h, iostream, cstring
use => std
get => vector
compiler => "-lncursesw"

class Ncurses
    WINDOW *win
    Ncurses bool ignore_colors = false =>
        setlocale(LC_ALL, "")
        win = initscr()
        noecho()
        keypad(win, true)
        if !ignore_colors && has_colors()
            start_color()
            init_pair(1, COLOR_RED, COLOR_BLACK)
            init_pair(2, COLOR_YELLOW, COLOR_BLACK)
            init_pair(3, COLOR_GREEN, COLOR_BLACK)
            init_pair(4, COLOR_BLACK, COLOR_RED)
            init_pair(5, COLOR_BLACK, COLOR_YELLOW)
            init_pair(6, COLOR_BLACK, COLOR_GREEN)
            init_pair(7, COLOR_BLUE, COLOR_BLACK)
            init_pair(8, COLOR_CYAN, COLOR_BLACK)
            init_pair(9, COLOR_MAGENTA, COLOR_BLACK)
            init_pair(10, COLOR_BLACK, COLOR_BLUE)
            init_pair(11, COLOR_BLACK, COLOR_CYAN)
            init_pair(12, COLOR_BLACK, COLOR_MAGENTA)
        ;
    ;
    fn box_char int y, int x, int pos =>
        if pos == 0 dore add(y,x,"█")
        if pos == 1 dore add(y,x,"█")
        if pos == 2 dore add(y,x,"█ ")
        if pos == 3 dore add(y,x," ")
    ;
    fn stop_box_char int y, int x, int pos =>
        if pos == 0 dore add(y, x, "█")
        if pos == 1 dore add(y, x, "█")
        if pos == 2 dore add(y, x, "█")
        if pos == 3 dore add(y, x, " ")
    ;
    fn center_box_char int y, int x, int pos =>
        if pos == 0 dore add(y, x, "▀")
        if pos == 1 dore add(y, x, " ")
        if pos == 2 dore add(y, x, "▄")
        if pos == 3 dore add(y, x, " ")
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
    fn move_curs Vector xy => do move_curs(xy.y, xy.x)
    fn move_curs int y, int x => do move(y, x)
    fn underline_until Vector xy, short color, int len => do underline_until(xy.y, xy.x, color, len)
    fn underline_until int y, int x, short color, int len => do mvchgat(y, x, len, A_UNDERLINE, color, NULL)
    fn mark_until Vector xy, short color, int len, bool is_bold = false, bool is_dim = false => do mark_until(xy.y, xy.x, color, len, is_bold, is_dim)
    fn mark_until int y, int x, short color, int len, bool is_bold = false, bool is_dim = false =>
        if is_dim do mvchgat(y, x, len, A_DIM, color, NULL)
        elif is_bold do mvchgat(y, x, len, A_BOLD, color, NULL)
        else do mvchgat(y, x, len, A_NORMAL, color, NULL)
    ;
    fn mark Vector xy, short color => do mark_until(xy.y, xy.x, color, 1)
    fn mark int y, int x, short color => do mark_until(y, x, color, 1)
    fn invis_box Vector xy, Vector wh => do box(xy.y, xy.x, wh.y, wh.x, true)
    fn invis_box int y, int x, int h, int w => do box(y, x, h, w, true)
    fn box Vector xy, Vector wh, bool invis = false => do box(xy.y, xy.x, wh.y, wh.x, invis)
    fn box int y, int x, int h, int w, bool invis = false =>
        box_line(y, x, w, 0, invis)
        if y + 1 >= LINES do return
        for i until h-2 do box_line(y + i + 1, x, w, 1, invis)
        if y + h - 1 >= LINES do return
        box_line(y + h - 1, x, w, 2, invis)
    ;
    fn use_arrows => do keypad(win, true)
    fn col short c, bool on = true =>
        if !has_colors() do return
        on ? attron(COLOR_PAIR(c)) : attroff(COLOR_PAIR(c))
    ;
    fn bold bool on => do on ? attron(A_BOLD) : attroff(A_BOLD)
    fn clear int y, int len =>
        for i until len do add(y, i, ' ')
    ;
    fn clearScr => void
        for i until LINES do clear(i, COLS)
    ;
    fn clearLn int y => do clear(y, COLS)
    fn add Vector xy, char c, bool is_bold = false => do add(xy.y, xy.x, c, is_bold)
    fn add int y, int x, char c, bool is_bold = false =>
        if is_bold do bold(true)
        mvaddch(y,x,c)
        if is_bold do bold(false)
    ;
    fn add Vector xy, string s, bool is_bold = false => do add(xy.y, xy.x, s, is_bold)
    fn add int y, int x, string s, bool is_bold = false =>
        if is_bold do bold(true)
        char ch[s.size() + 1]
        strcpy(ch, s.c_str())
        mvaddstr(y,x,ch)
        if is_bold do bold(false)
    ;
    fn add<T> Vector xy, T s, bool is_bold = false => do add(xy.y, xy.x, $"{s}", is_bold)
    fn add<T> int y, int x, T s, bool is_bold = false => do add(y, x, $"{s}", is_bold)
    fn add_until Vector xy, string s, int limit, bool is_bold = false => do add_until(xy.y, xy.x, s, limit, is_bold)
    fn add_until int y, int x, string s, int limit, bool is_bold = false =>
        add(y, x, s.substr(0,limit-x), is_bold)
    ;
    fn v_line Vector xy, int len => do v_line(xy.y, xy.x, len)
    fn v_line int y, int x, int len =>
        for i until len do add(y + i, x, "|")
    ;
    fn h_line Vector xy, int len => do h_line(xy.y, xy.x, len)
    fn h_line int y, int x, int len =>
        for i until len do add(y, x + i, "-")
    ;
    fn key => auto doremi getch()
    fn stop =>
        curs_set(1)
        endwin()
    ;
    fn start bool nonblock = false =>
        curs_set(0)
        if nonblock do nodelay(win, TRUE)
    ;
    fn init_pair_adv short pair, short fg_p, Vector fg, short bg_p, Vector bg =>
        if !has_colors() do return
        init_color(fg_p, (short)fg.x, (short)fg.y, (short)fg.z)
        init_color(bg_p, (short)bg.x, (short)bg.y, (short)bg.z)
        init_pair(pair, fg_p, bg_p)
    ;
;