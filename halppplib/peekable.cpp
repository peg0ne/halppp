#include <vector>
#include <iostream>
using namespace std;
template <typename T>
struct Option {
  private:
    T _value;
  private:
    bool _forced_none = true;
  public:
    bool is_none() {

return &_value== nullptr || _forced_none;
    }
  public:
    bool is_some() {

return !is_none();
    }
  public:
    T value_or(T value) {

return is_some() ? _value : value;
    }
  public:
    Option () {
_forced_none=true;
    }
  public:
    Option (T val) {
_value= val;
_forced_none=false;
    }
};
template <typename T>
Option<T> Some(T value) {

return Option< T>( value);
}
template <typename T>
Option<T> None() {

return Option< T>();
}
int main(int argc, char* argv[]) {
return 0;
}
template <typename T>
struct Peekable {
  private:
    vector<T> _values;
  private:
    int _index = 0;
  public:
    Peekable (vector<T> values) {
_values= values;
    }
  public:
    int size() {

return _values.size();
    }
  public:
    bool is_end() {

return _index> _values.size()-1;
    }
  public:
    bool is_begin() {

return _index==0;
    }
  public:
    Option<T> prev() {

return !is_begin() ? Some( _values.at(-- _index)) : None< T>();
    }
  public:
    Option<T> peek_prev() {

return !is_begin() ? Some( _values.at( _index-1)) : None< T>();
    }
  public:
    Option<T> next() {

return !is_end() ? Some( _values.at( _index++)) : None< T>();
    }
  public:
    Option<T> peek() {

return !is_end() ? Some( _values.at( _index+1)) : None< T>();
    }
};
