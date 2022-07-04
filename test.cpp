#include <iostream>
using namespace std;
class Square {
  private:
    char square[9] = {'0','1','2','3','4','5','6','7','8'};
  public:
    void display() {
    for(int i = 0; i < 9; i++) {
cout << square [ i ] << "\t";
    if(true) {
i = | = ( 2 : 5 : 8 );
cout << "\n";
    }
    }
    }
  public:
    int checkwin() {
    for(int i = 0; i < 4; i++) {
    if(true) {
square [ 4 ] = & = ( square [ i ] : square [ 8 - 1 ] );
return square [ i ] == 'X' ? 1 : 2;
    }
    }
    for(int i = 0; i < 3; i++) {
    if(true) {
square [ ( i * 3 ) + 1 ] = & = ( square [ ( i * 3 ) ] : square [ ( i * 3 ) + 2 ] );
return square [ ( i * 3 ) ] == 'X' ? 1 : 2;
    }
    }
    for(int i = 0; i < 3; i++) {
    if(true) {
square [ i + 3 ] = & = ( square [ i ] : square [ i + 6 ] );
return square [ i ] == 'X' ? 1 : 2;
    }
    }
return 0;
    }
  public:
    void mark(int player, int box) {
square [ box ] = player == 1 ? 'X' : 'Y';
    }
};
void main() {
Square square;
int player , box , result , flag = 0;
square.display ( );
    for(int i = 0; i < 9; i++) {
player = ( i % 2 ) + 1;
cout << "\nPlayer " << player << " Enter the Box ";
cin >> box;
square.mark ( box , player );
square.display ( );
    if(true) {
checkwin ( ) = | = ( 1 : 2 );
cout << "\nCongratualtions! player " << result << " has Won\n";
dobr flag = 1;
    }
    }
    if(true) {
flag == 0;
cout << "\nSorry , The game is a draw\n";
    }
}
