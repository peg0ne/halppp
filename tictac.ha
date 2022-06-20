inc => iostream
use std

class Square
    char square[9] = {'0', '1', '2', '3', '4', '5', '6', '7', '8'}

pub 
    fn display =>
        foreach i until 9
            cout << square[i] << "\t"
            if i =|= (2 : 5 : 8) do cout << "\n"
        ;
    ;

    fn checkwin => int
        foreach i until 4
            if square[4] =&= (square[i] : square[8 - 1])
                return square[i] == 'X' ? 1 : 2
            ;
        ;
        for i = 0; i < 9; i += 3
            if square[i + 1] =&= (square[i] : square[i + 2])
                return square[i] == 'X' ? 1 : 2
            ;
        ;
        foreach i until 3
            if square[i + 3] =&= (square[i] : square[i + 6])
                return square[i] == 'X' ? 1 : 2
            ;
        ;
        return 0
    ;

    fn mark int player, int box => do square[box] = player == 1 ? 'X' : 'Y';
;

fn main =>
    Square square
    int player, box, result, flag = 0
    display()

    foreach i until 9
        player = (i % 2) + 1
        cout << "\nPlayer " << player << " Enter the Box "
        cin >> box
        square[box] = player == 1 ? 'X' : 'Y'
        display()

        if checkwin() =|= (1 : 2)
            cout << "\nCongratualtions! player " << result << " has Won\n"
            dobr flag = 1
        ;
    ;
    if flag == 0 do cout << "\nSorry, The game is a draw\n"
;