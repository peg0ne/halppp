#include <iostream>
#include <vector>
using namespace std;

template <typename T>
struct Option
{
    private:
        T _value;
        bool forced_none = true;
    public:
        bool is_some() { return !(&_value == nullptr) && !forced_none; }
        bool is_none() { return &_value == nullptr || forced_none; }
        T value_or(T value) { return is_some() ? _value : value; }
        Option<T>() {}
        Option<T>(T val)
        {
            _value = val;
            forced_none = false;
        }
};
template <typename T>
Option<T> Some(T value) {return Option<T>(value);}
template <typename T>
Option<T> None() {return Option<T>();}
template<typename... Args>
Option<string> format(const char *fmt, Args... args)
{
    const size_t n = snprintf(nullptr, 0, fmt, args...);
    if (n <= 0) return None<string>();
    std::vector<char> buf(n+1);
    snprintf(buf.data(), n+1, fmt, args...);
    return Some(std::string(buf.data()));
}

void println(string s) {cout << s << "\n";}
void print(string s) {cout << s;}

int main()
{
    Option<int> e;
    auto s = format("Some: %d < expected: 7, got: %d", e.is_some(), e.value_or(7));
    print(s.value_or(""));

    auto a = Option<int>(0);
    cout << a.is_some() << " < expected: 0, got: "<< a.value_or(1) << "\n";

    auto b = Some(10);
    cout << b.is_some() << " < expected: 10, got: "<< b.value_or(5) << "\n";

    auto c = None<int>();
    cout << c.is_some() << " < expected: 2, got: " << c.value_or(2) << "\n";

    return 0;
}