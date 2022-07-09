get => ../lib/conditional, ../lib/ncurses
compiler => "-lncursesw"

class Square
    vector<char> sq = {'0', '1', '2', '3', '4', '5', '6', '7', '8'}
    Ncurses n = Ncurses()
pub 
    fn get_turn int player => int
        string p = player == 1 ? "1" : "2"
        n.add(0,0, "Player " + p + " Enter the box!")
        while true
            switch n.key()
                case '0': return 0
                case '1': return 1
                case '2': return 2
                case '3': return 3
                case '4': return 4
                case '5': return 5
                case '6': return 6
                case '7': return 7
                case '8': return 8
            ;
        ;
    ;
    fn display =>
        let y = 1
        foreach i until sq.size()
            n.add(y, (i % 3) * 4, sq[i])
            if any(i, {2, 5, 8}) do y++
        ;
    ;
    fn checkwin => int
        foreach i until 4
            if all(sq[4], {sq[i], sq[8 - i]}) doremi sq[i] == 'X' ? 1 : 2
        ;
        foreach i until 3
            if all(sq[(i * 3) + 1], {sq[(i * 3)], sq[(i * 3) + 2]}) doremi sq[(i * 3)] == 'X' ? 1 : 2
        ;
        foreach i until 3
            if all(sq[i + 3], {sq[i], sq[i + 6]}) doremi sq[i] == 'X' ? 1 : 2
        ;
        return 0
    ;
    fn mark int player, int box => void do sq[box] = player == 1 ? 'X' : 'Y'
    fn end => bool
        if n.key() == 'q'
            n.stop()
            return true
        ;
        return false
    ;
    fn draw =>
        n.add(4,0,"Sorry, The game is a draw")
        n.key()
    ;
    fn win int player =>
        string p = player == 1 ? "1" : "2"
        n.add(4,0,"Congratultions! player " + p + " has Won")
        n.key()
        n.stop()
    ;
;

fn run =>
    Square square
    int player, box, result, flag = 0
    square.display()

    foreach i until 9
        player = (i % 2) + 1
        box = square.get_turn(player)
        square.mark(player, box)
        square.display()
        result = square.checkwin()
        if any(result, {1, 2})
            square.win(result)
            return 0
        ;
    ;
    square.draw()
    if !square.end() do run()
;

fn main =>
    run()
;