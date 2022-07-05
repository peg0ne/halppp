#include <iostream>
using namespace std;
template <typename T>
struct Option {
  private:
    T _value;
  private:
    bool _forced_none;
  public:
    bool is_none() {

return &_value == nullptr || _forced_none;
    }
  public:
    bool is_some() {

return !is_none ( );
    }
  public:
    T value_or(T value) {

return is_some ( ) ? _value : value;
    }
  public:
    Option () {
    }
  public:
    Option (T val) {
_value = val;
_forced_none = false;
    }
};
template <typename T>
Option<T> Some(T value) {

return Option < T > ( value );
}
template <typename T>
Option<T> None() {

return Option < T > ( );
}
struct Clap {
  private:
    int _argc;
  private:
    char** _argv;
  public:
    bool has(string check) {
    for(int i = 0; i < _argc; i++) {
    if(_argv [ i ] == check ) {

return true;
    }
    }
return false;
    }
  public:
    Option<string> peek(string check) {
    for(int i = 0; i < _argc; i++) {
    if(! ( _argv [ i ] == check ) ) {
continue;
    }
    if(i > _argc - 2 ) {
break;
    }
return ( string ) _argv [ i + 1 ];
    }
return None < string > ( );
    }
  public:
    Clap (int argc, char** argv) {
_argc = argc;
_argv = argv;
    }
};
int main(int argc, char* argv[]) {
Clap clap ( argc , argv );
cout << clap.has ( "a" ) << "\n";
cout << clap.peek ( "a" ) .value_or ( "none" ) << "\n";
return 0;
}
