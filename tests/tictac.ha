get => ../lib/conditional

class Square
    vector<char> sq = {'0', '1', '2', '3', '4', '5', '6', '7', '8'}

pub 
    fn display =>
        foreach i until 9
            cout << sq[i] << "\t"
            if any(i, {2,5,8}) do cout << "\n"
        ;
    ;
    fn checkwin => int
        foreach i until 4
            if all(sq[4], {sq[i], sq[8 - 1]}) doremi sq[i] == 'X' ? 1 : 2
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
;

fn main =>
    Square square
    int player, box, result, flag = 0
    square.display()

    foreach i until 9
        player = (i % 2) + 1
        cout << "\nPlayer " << player << " Enter the Box "
        cin >> box
        square.mark(player, box)
        square.display()

        if any(square.checkwin(), {1, 2})
            cout << "\nCongratualtions! player " << result << " has Won\n"
            dobr flag = 1
        ;
    ;
    if flag == 0 do cout << "\nSorry, The game is a draw\n"
;