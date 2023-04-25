#include <string>
using namespace std;
#include <vector>
#include <ncurses.h>
#include <curses.h>
#include <wchar.h>
#include <locale.h>
#include <iostream>
#include <cstring>
#include <ctype.h>
#include <fstream>
#include <stdlib.h>
#include <dirent.h>
#include <algorithm>
#include <unistd.h>
#include <sys/stat.h>
#include <regex>
struct Vector;
class Ncurses;
template <typename T>
struct Option;
struct Bounds;
template <typename T, typename U>
struct KeyValuePair;
template <typename T, typename U>
class Dictionary;
template <typename T>
struct Peekable;
class String;
enum class JsonType: int;
string to_string(JsonType enumerator);
enum class JsonToken: int;
string to_string(JsonToken enumerator);
struct JsonTokenized;
class Json;
enum class AnchorX: int;
string to_string(AnchorX enumerator);
enum class AnchorY: int;
string to_string(AnchorY enumerator);
enum class Fill: int;
string to_string(Fill enumerator);
template <typename T>
class List;
enum class ContainerType: int;
string to_string(ContainerType enumerator);
struct NGuiOutline;
class IContainer;
class GroupedContainer;
class HorizontalLayout;
class VerticalLayout;
class Button;
class FilledRect;
class MainContainer;
class GridLayout;
class SpiralLayout;
class StepLayout;
struct RegexMatch;
enum class Dir: int;
string to_string(Dir enumerator);
enum class Command: int;
string to_string(Command enumerator);
enum class Mode: int;
string to_string(Mode enumerator);
enum class TextEdit: int;
string to_string(TextEdit enumerator);
enum class SyntaxType: int;
string to_string(SyntaxType enumerator);
struct SyntaxTemplate;
struct SyntaxBox;
struct SyntaxCustom;
struct SyntaxRule;
class Syntax;
struct TreeSitterBlock;
class TreeSitter;
class Highlighter;
class IContent;
struct TextEditOrCommand;
class CommandPallete;
class Editor;
class EditorManager;
class Explorer;
class CommandLine;
class ModeView;
class Model;
string to_string(string value);
template <typename T>
Option<T> Some(T value);
template <typename T>
Option<T> None();
template <typename T>
bool any(T value, vector<T> values);
template <typename T>
bool all(T value, vector<T> values);
template <typename T>
bool none(T value, vector<T> values);
template <typename T>
bool over(T value, vector<T> values);
template <typename T>
bool under(T value, vector<T> values);
template <typename T>
bool any_less(T value, vector<T> values);
bool is_char_number(char ch);
Option<int> char_to_number(char ch);
Option<string> read(string path);
vector<string> readlines(string path);
void write(string content, string path);
bool system(string command);
vector<string> system_output(string command);
bool makedir(string name);
bool changedir(string name);
Option<string> env(string env_var);
vector<string> list_reg_files(string path);
vector<string> list_dirs(string path);
vector<string> list_files(string path);
void remove(string path);
template <typename T>
void print(T s);
template <typename T>
void println(T s);
vector<JsonTokenized> json_tokenize_json(string json);
void json_parser_panic(string message);
JsonTokenized json_peek_or_panic(Peekable<JsonTokenized>* iter);
JsonTokenized json_next_or_panic(Peekable<JsonTokenized>* iter);
JsonTokenized json_next_is_or_panic(Peekable<JsonTokenized>* iter, JsonToken token);
vector<Json*> json_parse_json(vector<JsonTokenized> tokens);
vector<Json*> json_parse_json_obj(Peekable<JsonTokenized>* iter);
vector<Json*> json_parse_json_arr(Peekable<JsonTokenized>* iter);
Json* json_parse_identifier(Peekable<JsonTokenized>* iter, JsonTokenized id, bool from_array);
Json load_json(string path);
void write_json(string path, Json content);
template <typename T>
string to_string(List<T> list);
void draw_container_impl(IContainer* c, Ncurses* n);
double clamp(double value, double min, double max);
double max(double v_one, double v_two);
double min(double v_one, double v_two);
vector<RegexMatch> re(string line, regex reg, int capture, vector<Vector> claimed);
vector<RegexMatch> re(string line, regex reg, int capture);
vector<RegexMatch> re(string line, string rex, int capture);
void error_checker(Syntax* syntax, IContainer* container, Ncurses* n, string path, List<string> text, Vector internal_offset);
void file_exists_error_check(Ncurses* n, RegexMatch match, Vector offset, Vector size, int y, string path_dir, string line);
void equals_error_check(Ncurses* n, RegexMatch match, Vector offset, Vector size, int y, string validation_value, string line);
void insert_snippet(List<string>* text, Vector* pos, string snippet);
void strip_front(List<string>* text, Vector* pos, int amount);
void insert_newline(List<string>* text, Vector* pos);
void remove_char(List<string>* text, Vector* pos);
void remove_line(List<string>* text, Vector* pos);
void insert_line(List<string>* text, int pos, string line);
void remove_word(List<string>* text, Vector* pos, bool spacebreak);
void remove_until(List<string>* text, Vector* pos);
void to_case(List<string>* text, Vector* pos, bool upper);
void commenting(List<string>* text, Vector* pos);
bool selection_comparer(Vector &lhs, Vector &rhs);
bool selection_comparer_rev(Vector &lhs, Vector &rhs);
bool selection_comparer_ptr(Vector* &lhs, Vector* &rhs);
bool selection_comparer_rev_ptr(Vector* &lhs, Vector* &rhs);
vector<string> lgrep();
Option<string> Lgrep(Ncurses* n);
int main(int argc, char* argv[]);
string to_string(string value) {
   
return  value;
}
struct Vector {
 public:
   int x = 0;
 public:
   int y = 0;
 public:
   int z = 0;
 public:
   Vector () {
      
return ;
   }
 public:
   Vector (int x, int y) {
      this-> x= x;
      this-> y= y;
   }
 public:
   Vector (int x, int y, int z) {
      this-> x= x;
      this-> y= y;
      this-> z= z;
   }
 public:
   Vector operator+(Vector other) {
         auto  temp = Vector();
      temp.x= x+ other.x;
      temp.y= y+ other.y;
      temp.z= z+ other.z;
      return  temp;
   }
 public:
   Vector operator-(Vector other) {
         auto  temp = Vector();
      temp.x= x- other.x;
      temp.y= y- other.y;
      temp.z= z- other.z;
      return  temp;
   }
 public:
   Vector operator/(Vector other) {
         auto  temp = Vector();
      temp.x= x/ other.x;
      temp.y= y/ other.y;
      temp.z= z/ other.z;
      return  temp;
   }
 public:
   Vector operator*(Vector other) {
         auto  temp = Vector();
      temp.x= x* other.x;
      temp.y= y* other.y;
      temp.z= z* other.z;
      return  temp;
   }
 public:
   bool operator==(Vector other) {
         if(x  != other.x  ) {
            
return false;
}
         if(y  != other.y  ) {
            
return false;
}
         if(z  != other.z  ) {
            
return false;
}
      return true;
   }
 public:
   bool operator!=(Vector other) {
      return  x== other.x&& y== other.y&& z== other.z ?false:true;
   }
 public:
   void add(Vector other) {
      x+= other.x;
      y+= other.y;
      z+= other.z;
   }
 public:
   void sub(Vector other) {
      x-= other.x;
      y-= other.y;
      z-= other.z;
   }
 public:
   bool eq(Vector other) {
         if(x  != other.x  ) {
            
return false;
}
         if(y  != other.y  ) {
            
return false;
}
         if(z  != other.z  ) {
            
return false;
}
      return true;
   }
 public:
   void multiply(int amount) {
      x*= amount;
      y*= amount;
      z*= amount;
   }
};
class Ncurses {
 private:
   WINDOW* win;
 public:
   Ncurses (bool ignore_colors = false) {
      setlocale (LC_ALL, "");
      win= initscr ();
      noecho ();
      keypad (win, true);
         if(! ignore_colors    &&has_colors ()    ) {
            start_color ();
            init_pair (1, COLOR_RED, COLOR_BLACK);
            init_pair (2, COLOR_YELLOW, COLOR_BLACK);
            init_pair (3, COLOR_GREEN, COLOR_BLACK);
            init_pair (4, COLOR_BLACK, COLOR_RED);
            init_pair (5, COLOR_BLACK, COLOR_YELLOW);
            init_pair (6, COLOR_BLACK, COLOR_GREEN);
            init_pair (7, COLOR_BLUE, COLOR_BLACK);
            init_pair (8, COLOR_CYAN, COLOR_BLACK);
            init_pair (9, COLOR_MAGENTA, COLOR_BLACK);
            init_pair (10, COLOR_BLACK, COLOR_BLUE);
            init_pair (11, COLOR_BLACK, COLOR_CYAN);
            init_pair (12, COLOR_BLACK, COLOR_MAGENTA);
}
   }
 private:
   void box_char(int y, int x, int pos) {
         if(pos  == 0  ) {
            
 add (y,x,"┌");
return ;
}
         if(pos  == 1  ) {
            
 add (y,x,"│");
return ;
}
         if(pos  == 2  ) {
            
 add (y,x,"└");
return ;
}
         if(pos  == 3  ) {
            
 add (y,x," ");
return ;
}
   }
 private:
   void stop_box_char(int y, int x, int pos) {
         if(pos  == 0  ) {
            
 add (y, x, "┐");
return ;
}
         if(pos  == 1  ) {
            
 add (y, x, "│");
return ;
}
         if(pos  == 2  ) {
            
 add (y, x, "┘");
return ;
}
         if(pos  == 3  ) {
            
 add (y, x, " ");
return ;
}
   }
 private:
   void center_box_char(int y, int x, int pos) {
         if(pos  == 0  ) {
            
 add (y, x, "─");
return ;
}
         if(pos  == 1  ) {
            
 add (y, x, " ");
return ;
}
         if(pos  == 2  ) {
            
 add (y, x, "─");
return ;
}
         if(pos  == 3  ) {
            
 add (y, x, " ");
return ;
}
   }
 private:
   void box_line(int y, int x, int len, int pos, bool invis) {
         if(invis    ) {
            
 pos= 3;
}
         for(int i = 0; i < len; i++) {
               if(i  == 0  ) {
                   box_char (y, x + i, pos);
continue ;
}
               if(i  == len - 1  ) {
                   stop_box_char (y, x + i, pos);
continue ;
}
            center_box_char (y, x + i, pos);
}
   }
 public:
   void move_curs(Vector xy) {
      
 move_curs (xy.y, xy.x);
   }
 public:
   void move_curs(int y, int x) {
      
 move (y, x);
   }
 public:
   void underline_until(Vector xy, short color, int len) {
      
 underline_until (xy.y, xy.x, color, len);
   }
 public:
   void underline_until(int y, int x, short color, int len) {
      
 mvchgat (y, x, len, A_UNDERLINE, color, NULL);
   }
 public:
   void mark_until(Vector xy, short color, int len, bool is_bold = false, bool is_dim = false) {
      
 mark_until (xy.y, xy.x, color, len, is_bold, is_dim);
   }
 public:
   void mark_until(int y, int x, short color, int len, bool is_bold = false, bool is_dim = false) {
         if(is_dim    ) {
            
 mvchgat (y, x, len, A_DIM, color, NULL);
}
         else if(is_bold    ) {
            
 mvchgat (y, x, len, A_BOLD, color, NULL);
}
         else {
            
 mvchgat (y, x, len, A_NORMAL, color, NULL);
}
   }
 public:
   void mark(Vector xy, short color) {
      
 mark_until (xy.y, xy.x, color, 1);
   }
 public:
   void mark(int y, int x, short color) {
      
 mark_until (y, x, color, 1);
   }
 public:
   void invis_box(Vector xy, Vector wh) {
      
 box (xy.y, xy.x, wh.y, wh.x, true);
   }
 public:
   void invis_box(int y, int x, int h, int w) {
      
 box (y, x, h, w, true);
   }
 public:
   void box(Vector xy, Vector wh, bool invis = false) {
      
 box (xy.y, xy.x, wh.y, wh.x, invis);
   }
 public:
   void box(int y, int x, int h, int w, bool invis = false) {
      box_line (y, x, w, 0, invis);
         if(y + 1  >= LINES  ) {
            
return ;
}
         for(int i = 0; i < h-2; i++) {
            
 box_line (y + i + 1, x, w, 1, invis);
}
         if(y + h - 1  >= LINES  ) {
            
return ;
}
      box_line (y + h - 1, x, w, 2, invis);
   }
 public:
   void use_arrows() {
      
 keypad (win, true);
   }
 public:
   void col(short c, bool on = true) {
         if(! has_colors ()    ) {
            
return ;
}
      on ? attron (COLOR_PAIR(c)): attroff (COLOR_PAIR(c));
   }
 public:
   void bold(bool on) {
      
 on ? attron (A_BOLD): attroff (A_BOLD);
   }
 public:
   void clear(int y, int len) {
         for(int i = 0; i < len; i++) {
            
 add (y, i, ' ');
}
   }
 public:
   void clearScr() {
         for(int i = 0; i < LINES; i++) {
            
 clear (i, COLS);
}
   }
 public:
   void clearLn(int y) {
      
 clear (y, COLS);
   }
 public:
   void add(Vector xy, char c, bool is_bold = false) {
      
 add (xy.y, xy.x, c, is_bold);
   }
 public:
   void add(int y, int x, char c, bool is_bold = false) {
         if(is_bold    ) {
            
 bold (true);
}
      mvaddch (y,x,c);
         if(is_bold    ) {
            
 bold (false);
}
   }
 public:
template <typename T>
   void add(Vector xy, T s, bool is_bold = false) {
      
 add (xy.y, xy.x, "" + to_string(s) + "", is_bold);
   }
 public:
template <typename T>
   void add(int y, int x, T s, bool is_bold = false) {
      
 add (y, x, "" + to_string(s) + "", is_bold);
   }
 public:
   void add(Vector xy, string s, bool is_bold = false) {
      
 add (xy.y, xy.x, s, is_bold);
   }
 public:
   void add(int y, int x, string s, bool is_bold = false) {
         if(is_bold    ) {
            
 bold (true);
}
      char ch[ s.size ()+ 1];
      strcpy (ch, s.c_str());
      mvaddstr (y,x,ch);
         if(is_bold    ) {
            
 bold (false);
}
   }
 public:
   void add_col(Vector xy, char c, short color, bool is_bold = false) {
      
 add_col (xy.y, xy.x, c, color, is_bold);
   }
 public:
   void add_col(int y, int x, char c, short color, bool is_bold = false) {
         if(is_bold    ) {
            
 bold (true);
}
      col (color);
      mvaddch (y,x,c);
      col (color, false);
         if(is_bold    ) {
            
 bold (false);
}
   }
 public:
template <typename T>
   void add_col(Vector xy, T s, short color, bool is_bold = false) {
      
 add_col (xy.y, xy.x, "" + to_string(s) + "", color, is_bold);
   }
 public:
template <typename T>
   void add_col(int y, int x, T s, short color, bool is_bold = false) {
      
 add_col (y, x, "" + to_string(s) + "", color, is_bold);
   }
 public:
   void add_col(Vector xy, string s, short color, bool is_bold = false) {
      
 add_col (xy.y, xy.x, s, color, is_bold);
   }
 public:
   void add_col(int y, int x, string s, short color, bool is_bold = false) {
      col (color);
      add (y, x, "" + to_string(s) + "", is_bold);
      col (color, false);
   }
 public:
   void add_until(Vector xy, string s, int limit, bool is_bold = false) {
      
 add_until (xy.y, xy.x, s, limit, is_bold);
   }
 public:
   void add_until(int y, int x, string s, int limit, bool is_bold = false) {
      add (y, x, s.substr(0,limit-x), is_bold);
   }
 public:
   void v_line(Vector xy, int len) {
      
 v_line (xy.y, xy.x, len);
   }
 public:
   void v_line(int y, int x, int len) {
         for(int i = 0; i < len; i++) {
            
 add (y + i, x, "|");
}
   }
 public:
   void h_line(Vector xy, int len) {
      
 h_line (xy.y, xy.x, len);
   }
 public:
   void h_line(int y, int x, int len) {
         for(int i = 0; i < len; i++) {
            
 add (y, x + i, "-");
}
   }
 public:
   auto key() {
      
return  getch ();
   }
 public:
   void stop() {
      curs_set (1);
      endwin ();
   }
 public:
   void start(bool nonblock = false) {
      curs_set (0);
         if(nonblock    ) {
            
 nodelay (win, TRUE);
}
   }
 public:
   void init_pair_adv(short pair, short fg_p, Vector fg, short bg_p, Vector bg) {
         if(! has_colors ()    ) {
            
return ;
}
      init_color (fg_p, (short)fg.x, (short)fg.y, (short)fg.z);
      init_color (bg_p, (short)bg.x, (short)bg.y, (short)bg.z);
      init_pair (pair, fg_p, bg_p);
   }
};
template <typename T>
struct Option {
 private:
   T _value;
 private:
   bool _forced_none = true;
 public:
   bool is_none() {
      
return  &_value== nullptr|| _forced_none;
   }
 public:
   bool is_some() {
      
return ! is_none ();
   }
 public:
   T value_or(T value) {
      
return  is_some () ? _value: value;
   }
 public:
   T value_unsafe() {
      
return  _value;
   }
 public:
   string to_string() {
      
return  is_some () ?"Some("+ std:: to_string (_value)+")":"None";
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
   
return  Option< T> (value);
}
template <typename T>
Option<T> None() {
   
return  Option< T> ();
}
struct Bounds {
 public:
   Vector min = Vector();
 public:
   Vector max = Vector();
 public:
   Bounds () {
      
return ;
   }
 public:
   Bounds (int minX, int minY, int maxX, int maxY) {
      this-> min= Vector (minX, minY);
      this-> max= Vector (maxX, maxY);
   }
 public:
   int width() {
      
return  max.x- min.x;
   }
 public:
   int height() {
      
return  max.y- min.y;
   }
};
template <typename T, typename U>
struct KeyValuePair {
 public:
   T _key;
 public:
   U _value;
 public:
   KeyValuePair (T key, U value) {
      _key= key;
      _value= value;
   }
};
template <typename T, typename U>
class Dictionary {
 private:
   vector<T> _keys = {};
 private:
   vector<U> _values = {};
 public:
   Dictionary () {
      
return ;
   }
 public:
   Option<U> operator[](T key) {
      
return  try_get_value (key);
   }
 public:
   vector<T> keys() {
      
return  _keys;
   }
 public:
   bool contains(T key) {
         for(int k_iterator = 0; k_iterator < _keys.size(); k_iterator++) {
auto k = _keys.at(k_iterator);               if(k  == key  ) {
                  
return true;
}
}
      return false;
   }
 public:
   void remove(T key) {
      vector< T> keys= {};
      vector< U> values= {};
         if(! contains (key)    ) {
            
return ;
}
         int  i = 0;
         while(true   ) {
               if(i  >= _keys.size ()  ) {
                  
 break;
}
               if(_keys.at (i)  == key  ) {
                   i++;
continue ;
}
            keys.push_back (_keys.at(i));
            values.push_back (_values.at(i));
            i++;
}
      _keys= keys;
      _values= values;
   }
 public:
   void add(T key, U value) {
         if(contains (key)    ) {
            
return ;
}
      _keys.push_back (key);
      _values.push_back (value);
   }
 public:
   void set(T key, U value) {
         if(! contains (key)    ) {
            
return ;
}
         int  i = 0;
         while(true   ) {
               if(i  >= _keys.size ()  ) {
                  
return ;
}
               if(_keys.at (i)  == key  ) {
                  _values[ i]= value;
                  return ;
}
            i++;
}
   }
 public:
   Option<U> try_get_value(T key) {
         int  i = 0;
         while(true   ) {
               if(i  >= _keys.size ()  ) {
                  
return  None< U> ();
}
               if(_keys.at (i)  == key  ) {
                  
return  Some (_values.at(i));
}
            i++;
}
   }
 public:
   Option<U*> try_get_value_ptr(T key) {
         int  i = 0;
         while(true   ) {
               if(i  >= _keys.size ()  ) {
                  
return  None< U*> ();
}
               if(_keys.at (i)  == key  ) {
                  
return  Some (&_values[i]);
}
            i++;
}
   }
 public:
   void steal(Dictionary<T,U> other) {
         for(int key_iterator = 0; key_iterator < other.keys().size(); key_iterator++) {
auto key = other.keys().at(key_iterator);               
{
auto val_optional_value = other.try_get_value(key);
if(val_optional_value.is_some()) {
auto val = val_optional_value.value_unsafe();
                  add (key, val);
}

}
}
   }
};
template <typename T>
struct Peekable {
 private:
   vector<T> _values = {};
 private:
   int _index = 0;
 public:
   Peekable () {
      
return ;
   }
 public:
   Peekable (vector<T> values) {
      _values= values;
   }
 public:
   Peekable (string text) {
         for(int c_iterator = 0; c_iterator < text.size(); c_iterator++) {
auto c = text.at(c_iterator);            _values.push_back (c);
}
   }
 public:
   int index() {
      
return  _index;
   }
 public:
   int size() {
      
return  _values.size ();
   }
 public:
   bool is_end() {
      
return  _index> _values.size ()- 1;
   }
 public:
   bool is_begin() {
      
return  _index== 0;
   }
 public:
   Option<T> at(int at) {
      
return  Some (_values.at(at));
   }
 public:
   Option<T> prev() {
      
return ! is_begin () ? at (--_index): None< T> ();
   }
 public:
   Option<T> peek_prev() {
      
return ! is_begin () ? at (_index - 1): None< T> ();
   }
 public:
   Option<T> next() {
      
return ! is_end () ? at (_index++): None< T> ();
   }
 public:
   Option<T> peek() {
      
return ! is_end () ? at (_index): None< T> ();
   }
};
template <typename T>
bool any(T value, vector<T> values) {
      for(int val_iterator = 0; val_iterator < values.size(); val_iterator++) {
auto val = values.at(val_iterator);            if(value  == val  ) {
               
return true;
}
}
   return false;
}
template <typename T>
bool all(T value, vector<T> values) {
      for(int val_iterator = 0; val_iterator < values.size(); val_iterator++) {
auto val = values.at(val_iterator);            if(value  != val  ) {
               
return false;
}
}
   return true;
}
template <typename T>
bool none(T value, vector<T> values) {
      for(int val_iterator = 0; val_iterator < values.size(); val_iterator++) {
auto val = values.at(val_iterator);            if(value  == val  ) {
               
return false;
}
}
   return true;
}
template <typename T>
bool over(T value, vector<T> values) {
      for(int val_iterator = 0; val_iterator < values.size(); val_iterator++) {
auto val = values.at(val_iterator);            if(value  == val  ) {
               
return false;
}
            if(value  < val  ) {
               
return false;
}
}
   return true;
}
template <typename T>
bool under(T value, vector<T> values) {
      for(int val_iterator = 0; val_iterator < values.size(); val_iterator++) {
auto val = values.at(val_iterator);            if(value  == val  ) {
               
return false;
}
            if(value  > val  ) {
               
return false;
}
}
   return true;
}
template <typename T>
bool any_less(T value, vector<T> values) {
      for(int val_iterator = 0; val_iterator < values.size(); val_iterator++) {
auto val = values.at(val_iterator);            if(value  > val  ) {
               
return true;
}
}
   return false;
}
class String {
 private:
   string _value;
 public:
   String (string value) {
      
 this-> _value= value;
   }
 public:
   String operator+(string text) {
      
return  String (_value + text);
   }
 public:
   String operator+(char ch) {
      
return  String (_value + string(1, ch));
   }
 public:
   char operator[](int at) {
      
return  _value.at (at);
   }
 public:
   bool operator==(string other) {
      
return  _value== other;
   }
 public:
   bool operator!=(string other) {
      
return  _value!= other;
   }
 public:
   bool operator==(String other) {
      
return  _value== other.to_string ();
   }
 public:
   bool operator!=(String other) {
      
return  _value!= other.to_string ();
   }
 public:
   string to_string() {
      
return  _value;
   }
 public:
   long len() {
      
return  _value.size ();
   }
 public:
   auto at(int at) {
      
return  _value.at (at);
   }
 public:
   void append(string value) {
      
 _value+= value;
   }
 public:
   void insert(string value, int at) {
         if(at  == 0  ) {
            
 _value= value+ _value;
return ;
}
         if(at  >= len ()  ) {
            
 append (value);
return ;
}
         auto  updated = _value.substr(0, at);
      updated+= value;
      updated+= _value.substr (at);
      _value= updated;
   }
 public:
   void remove_back(int amount) {
         for(int i = 0; i < amount; i++) {
               if(i  >= len ()  ) {
                  
return ;
}
            remove (len() - 1);
}
   }
 public:
   void remove(int at) {
         if(len ()  == 0  ) {
            
return ;
}
         if(at  >= len ()  ) {
            
return ;
}
         if(at  == 0  ) {
            
 _value= substr (1);
return ;
}
      _value= substr (0, at)+ substr (at + 1);
   }
 public:
   void remove_word(int at) {
      
 remove_word (at, false);
   }
 public:
   void remove_word(int at, bool spacebreak) {
         if(at  < 0  ||len ()  <= 0  ||at  >= len ()  ) {
            
return ;
}
         auto  ch = _value.at(at);
      remove (at);
         if(! isalpha (ch)    ) {
            
return ;
}
         while(true   ) {
               if(at  < 0  ||len ()  <= 0  ||at  >= len ()  ) {
                  
return ;
}
            ch= _value.at (at);
               if(spacebreak    &&ch  == ' '  ) {
                  
 break;
}
               if(! isalpha (ch)    ) {
                  
return ;
}
            remove (at);
}
         while(true   ) {
               if(at  < 0  ||len ()  <= 0  ||at  >= len ()  ) {
                  
return ;
}
            ch= _value.at (at);
               if(ch  != ' '  ) {
                  
return ;
}
            remove (at);
}
   }
 public:
   string pop() {
      
return  substr (0, _value.size() - 1);
   }
 public:
   string to_upper() {
         auto  upper = _value;
         for(int i = 0; i < upper.size(); i++) {
            
 upper[ i]= toupper (upper[i]);
}
      return  upper;
   }
 public:
   string to_lower() {
         auto  lower = _value;
         for(int i = 0; i < lower.size(); i++) {
            
 lower[ i]= tolower (lower[i]);
}
      return  lower;
   }
 public:
   string strip() {
      
return  strip (None<int>());
   }
 public:
   string strip(int times) {
      
return  strip (Some(times));
   }
 public:
   string strip(Option<int> times) {
         auto  stripped = _value;
         auto  amount = _value.size();
         bool  rhs = false;
         bool  lhs = false;
         
{
auto t_optional_value = times;
if(t_optional_value.is_some()) {
auto t = t_optional_value.value_unsafe();
            
 amount= t;
}

}
         for(int i = 0; i < amount; i++) {
               if(rhs    &&lhs    ) {
                  
 break;
}
               if(! rhs    ) {
                     if(stripped.size ()  == 0  ) {
                        
 break;
}
                     if(any (stripped.back(), {' ', '\n', '\t'})    ) {
                        stripped= stripped.substr (0, stripped.size()-1);
}
                     else {
                        
 rhs=true;
}
}
               if(! lhs    ) {
                     if(stripped.size ()  == 0  ) {
                        
 break;
}
                     if(any (stripped[0], {' ', '\n', '\t'})    ) {
                        stripped= stripped.substr (1);
}
                     else {
                        
 lhs=true;
}
}
}
      return  stripped;
   }
 public:
   string strip_end() {
      
return  strip_end (None<int>());
   }
 public:
   string strip_end(int times) {
      
return  strip_end (Some(times));
   }
 public:
   string strip_end(Option<int> times) {
         auto  stripped = _value;
         auto  amount = _value.size();
         
{
auto t_optional_value = times;
if(t_optional_value.is_some()) {
auto t = t_optional_value.value_unsafe();
            
 amount= t;
}

}
         for(int i = 0; i < amount; i++) {
               if(stripped.size ()  == 0  ) {
                  
 break;
}
               if(none (stripped.back(), {' ', '\n', '\t'})    ) {
                  
 break;
}
            stripped= stripped.substr (0, stripped.size()-1);
}
      return  stripped;
   }
 public:
   string strip_front() {
      
return  strip_front (None<int>());
   }
 public:
   string strip_front(int times) {
      
return  strip_front (Some(times));
   }
 public:
   string strip_front(Option<int> times) {
         auto  stripped = _value;
         auto  amount = _value.size();
         
{
auto t_optional_value = times;
if(t_optional_value.is_some()) {
auto t = t_optional_value.value_unsafe();
            
 amount= t;
}

}
         for(int i = 0; i < amount; i++) {
               if(stripped.size ()  == 0  ) {
                  
 break;
}
               if(none (stripped[0], {' ', '\n', '\t'})    ) {
                  
 break;
}
            stripped= stripped.substr (1);
}
      return  stripped;
   }
 public:
   string replace(string from, string to) {
      string replaced= _value;
      size_t last= 0;
         while(true   ) {
            size_t start_pos= replaced.find (from, last);
               if(start_pos  == - 1  ) {
                  
return  replaced;
}
            replaced.replace (start_pos, from.length(), to);
            last= start_pos+ 1;
}
   }
 public:
   string replace(string from, string to, int amount) {
      string replaced= _value;
      size_t last= 0;
         for(int i = 0; i < amount; i++) {
            size_t start_pos= replaced.find (from, last);
               if(start_pos  == - 1  ) {
                  
return  replaced;
}
            replaced.replace (start_pos, from.length(), to);
            last= start_pos+ 1;
}
      return  replaced;
   }
 public:
   Option<double> to_num() {
         bool  is_negative = false;
         auto  num = 0.0;
         auto  dec = 0.0;
         int  dec_len = 0;
         bool  is_dec = false;
         if(starts_with ("-")    ) {
            is_negative=true;
            remove (0);
}
         for(int c_iterator = 0; c_iterator < _value.size(); c_iterator++) {
auto c = _value.at(c_iterator);               if(c  == '.'  ) {
                     if(is_dec    ) {
                        
return  None< double> ();
}
                  is_dec=true;
                  continue;
}
               auto  num_opt = char_to_number(c);
               
{
auto num_val_optional_value = char_to_number(c);
if(num_val_optional_value.is_some()) {
auto num_val = num_val_optional_value.value_unsafe();
                     if(is_dec    ) {
                        dec*= 10;
                        dec+= num_val;
                        dec_len++;
}
                     else {
                        num*= 10;
                        num+= num_val;
}
                  continue;
}

}
            return  None< double> ();
}
         if(dec  == 0.0  ) {
            
return  Some (is_negative ? -num : num);
}
         for(int i = 0; i < dec_len; i++) {
            
 dec*=0.1;
}
      return  Some (is_negative ? -(num + dec) : num + dec);
   }
 public:
   vector<string> split() {
      
return  split (None<char>());
   }
 public:
   vector<string> split(char delimiter) {
      
return  split (Some(delimiter));
   }
 public:
   vector<string> split(Option<char> delimiter) {
      vector<string> split= {};
         char  delim = ' ';
         
{
auto d_optional_value = delimiter;
if(d_optional_value.is_some()) {
auto d = d_optional_value.value_unsafe();
            
 delim= d;
}

}
         auto  splitting = _value;
         while(true   ) {
               auto  found = splitting.find(delim);
               if(found  == - 1  ) {
                  
 break;
}
            split.push_back (splitting.substr(0, found));
            splitting= splitting.substr (found + 1);
}
      split.push_back (splitting);
      return  split;
   }
 public:
   bool contains(string contains) {
      
return  _value.find (contains)!=- 1;
   }
 public:
   bool starts_with(string start) {
      
return  _value.rfind (start, 0)== 0;
   }
 public:
   bool ends_with(string ends) {
         if(ends.size ()  > len ()  ) {
            
return false;
}
         if(ends.size ()  == len ()  ) {
            
return  ends== _value;
}
         auto  sub = substr(_value.size() - ends.size());
      return  sub== ends;
   }
 public:
   string substr(int start) {
      
return  _value.substr (start);
   }
 public:
   string substr(int start, int end) {
      
return  _value.substr (start, end);
   }
 public:
   Option<int> find(int from, string key) {
         if(from + 1  >= len ()  ) {
            
return  None<int> ();
}
         auto  s = _value.substr(from + 1);
         auto  found = s.find(key);
      return  found!=- 1 ? Some ((int)found + 1): None<int> ();
   }
 public:
   Option<int> find_non_alpha(int from, bool reverse) {
      return  reverse ? find_non_alpha_reverse (from): find_non_alpha (from);
   }
 public:
   Option<int> find_non_alpha(int from) {
         if(from  >= len ()  ) {
            
return  None<int> ();
}
         auto  s = _value.substr(from);
         for(int i = 0; i < s.size(); i++) {
               if(isalpha (s.at(i))    ) {
                  
 continue;
}
            return  Some (i);
}
      return  None<int> ();
   }
 public:
   Option<int> find_non_alpha_reverse(int from) {
         if(from  >= len ()  ) {
            
return  None<int> ();
}
         auto  s = _value.substr(0, from);
         for(int i = 0; i < s.size(); i++) {
               if(isalpha (s.at(s.size() - 1 - i))    ) {
                  
 continue;
}
            return  Some (i);
}
      return  None<int> ();
   }
 public:
   Option<int> find_alpha(int from, bool reverse) {
      return  reverse ? find_alpha_reverse (from): find_alpha (from);
   }
 public:
   Option<int> find_alpha(int from) {
         if(from  >= len ()  ) {
            
return  None<int> ();
}
         auto  s = _value.substr(from);
         for(int i = 0; i < s.size(); i++) {
               if(! isalpha (s.at(i))    ) {
                  
 continue;
}
            return  Some (i);
}
      return  None<int> ();
   }
 public:
   Option<int> find_alpha_reverse(int from) {
         if(from  >= len ()  ) {
            
return  None<int> ();
}
         auto  s = _value.substr(0, from);
         for(int i = 0; i < s.size(); i++) {
               if(! isalpha (s.at(s.size() - 1 - i))    ) {
                  
 continue;
}
            return  Some (i);
}
      return  None<int> ();
   }
 public:
   string escape() {
      string buf="";
         for(int c_iterator = 0; c_iterator < _value.size(); c_iterator++) {
auto c = _value.at(c_iterator);               if(c  == '"'  ) {
                  
 buf+='\\';
}
            buf+= c;
}
      return  String (buf) .replace ("\n", "\\n");
   }
 public:
   string unescape() {
         auto  s = replace("\\n", "\n");
         string  buf = "";
         int  i = 0;
         for(int c_iterator = 0; c_iterator < s.size(); c_iterator++) {
auto c = s.at(c_iterator);            i++;
               if(i  < s.size () - 1  &&s.at (i)  == '"'  ) {
                     if(c  == '\\'  ) {
                        
 continue;
}
}
            buf+= c;
}
      return  buf;
   }
};
bool is_char_number(char ch) {
      switch(ch    ) {
         case '0':
         case '1':
         case '2':
         case '3':
         case '4':
         case '5':
         case '6':
         case '7':
         case '8':
         case '9':
         
return true;
         default:
         
return false;
}
}
Option<int> char_to_number(char ch) {
      switch(ch    ) {
         case '0':
         
return  Some (0);
         case '1':
         
return  Some (1);
         case '2':
         
return  Some (2);
         case '3':
         
return  Some (3);
         case '4':
         
return  Some (4);
         case '5':
         
return  Some (5);
         case '6':
         
return  Some (6);
         case '7':
         
return  Some (7);
         case '8':
         
return  Some (8);
         case '9':
         
return  Some (9);
         default:
         
return  None<int> ();
}
}
Option<string> read(string path) {
   string content, linebuf;
   ifstream reader (path);
      if(! reader    ) {
         
return  None<string> ();
}
      while(! reader.eof ()    ) {
         getline (reader, linebuf);
         content+= linebuf+"\n";
}
   reader.close ();
      if(content  == ""  ) {
         
return  None<string> ();
}
   return  Some (content);
}
vector<string> readlines(string path) {
   vector<string> lines= {};
      auto  content_opt = read(path);
      if(content_opt.is_none ()    ) {
         
return  lines;
}
      auto  content = content_opt.value_or("");
   int start= 0;
   int end= content.find ("\n");
      while(end  != - 1  ) {
         lines.push_back (content.substr(start, end - start));
         start= end+ 1;
         end= content.find ("\n", start);
}
   lines.push_back (content.substr(start, end - start));
   return  lines;
}
void write(string content, string path) {
   ofstream file (path);
   file<< content;
   file.close ();
}
bool system(string command) {
   char command_arr[ command.size ()+ 1];
      for(int i = 0; i < command.size(); i++) {
         
 command_arr[ i]= command.at (i);
}
   command_arr[ command.size ()]='\0';
   return ! system (command_arr);
}
vector<string> system_output(string command) {
   vector<string> output= {};
   char command_arr[ command.size ()+ 1];
      for(int i = 0; i < command.size(); i++) {
         
 command_arr[ i]= command.at (i);
}
   command_arr[ command.size ()]='\0';
   FILE* fp;
   char buffer[ 1064];
      if((fp = popen(command_arr, "r"))  == NULL  ) {
         return  output;
}
      while(fgets (buffer, sizeof(buffer), fp)    ) {
         output.push_back (buffer);
}
   pclose (fp);
   return  output;
}
bool makedir(string name) {
   char name_arr[ name.size ()+ 1];
      for(int i = 0; i < name.size(); i++) {
         
 name_arr[ i]= name.at (i);
}
   name_arr[ name.size ()]='\0';
   return ! mkdir (name_arr);
}
bool changedir(string name) {
   char name_arr[ name.size ()+ 1];
      for(int i = 0; i < name.size(); i++) {
         
 name_arr[ i]= name.at (i);
}
   name_arr[ name.size ()]='\0';
   return  chdir (name_arr)>= 0;
}
Option<string> env(string env_var) {
   char env_var_arr[ env_var.size ()+ 1];
      for(int i = 0; i < env_var.size(); i++) {
         
 env_var_arr[ i]= env_var.at (i);
}
   env_var_arr[ env_var.size ()]='\0';
      auto  e = getenv(env_var_arr);
      if(e  == NULL  ) {
         
return  None<string> ();
}
   return  Some ((string)e);
}
vector<string> list_reg_files(string path) {
   vector<string> files= {};
   char path_arr[ path.size ()+ 1];
      for(int i = 0; i < path.size(); i++) {
         
 path_arr[ i]= path.at (i);
}
   path_arr[ path.size ()]='\0';
   DIR* dir;
   struct dirent* diread;
      if((dir = opendir(path_arr))  != nullptr  ) {
            while((diread = readdir(dir))  != nullptr  ) {
                  if(diread -> d_type  != DT_REG  ) {
                     
 continue;
}
               files.push_back (diread->d_name);
}
         closedir (dir);
}
   sort (files.begin(), files.end());
   return  files;
}
vector<string> list_dirs(string path) {
   vector<string> files= {};
   char path_arr[ path.size ()+ 1];
      for(int i = 0; i < path.size(); i++) {
         
 path_arr[ i]= path.at (i);
}
   path_arr[ path.size ()]='\0';
   DIR* dir;
   struct dirent* diread;
      if((dir = opendir(path_arr))  != nullptr  ) {
            while((diread = readdir(dir))  != nullptr  ) {
                  if(diread -> d_type  != DT_DIR  ) {
                     
 continue;
}
               files.push_back (diread->d_name);
}
         closedir (dir);
}
   sort (files.begin(), files.end());
   return  files;
}
vector<string> list_files(string path) {
   vector<string> files= {};
   char path_arr[ path.size ()+ 1];
      for(int i = 0; i < path.size(); i++) {
         
 path_arr[ i]= path.at (i);
}
   path_arr[ path.size ()]='\0';
   DIR* dir;
   struct dirent* diread;
      if((dir = opendir(path_arr))  != nullptr  ) {
            while((diread = readdir(dir))  != nullptr  ) {
               
 files.push_back (diread->d_name);
}
         closedir (dir);
}
   sort (files.begin(), files.end());
   return  files;
}
void remove(string path) {
   char path_arr[ path.size ()+ 1];
      for(int i = 0; i < path.size(); i++) {
         
 path_arr[ i]= path.at (i);
}
   path_arr[ path.size ()]='\0';
   remove (path_arr);
}
template <typename T>
void print(T s) {
   
 cout<< s;
}
template <typename T>
void println(T s) {
   
 cout<< s<<"\n";
}
enum class JsonType: int {
   Boolean,
   Array,
   Number,
   Object,
   String,
};
string to_string(JsonType enumerator) {
switch (enumerator) {
case JsonType::Boolean: return "Boolean";
case JsonType::Array: return "Array";
case JsonType::Number: return "Number";
case JsonType::Object: return "Object";
case JsonType::String: return "String";
default: return "UNKNOWN TYPE";
}};
enum class JsonToken: int {
   LBrace,
   RBrace,
   LBox,
   RBox,
   Colon,
   Comma,
   StringLiteral,
   NumberLiteral,
   BooleanLiteral,
};
string to_string(JsonToken enumerator) {
switch (enumerator) {
case JsonToken::LBrace: return "LBrace";
case JsonToken::RBrace: return "RBrace";
case JsonToken::LBox: return "LBox";
case JsonToken::RBox: return "RBox";
case JsonToken::Colon: return "Colon";
case JsonToken::Comma: return "Comma";
case JsonToken::StringLiteral: return "StringLiteral";
case JsonToken::NumberLiteral: return "NumberLiteral";
case JsonToken::BooleanLiteral: return "BooleanLiteral";
default: return "UNKNOWN TYPE";
}};
struct JsonTokenized {
 public:
   string literal;
 public:
   JsonToken token;
 public:
   JsonTokenized () {
      
return ;
   }
 public:
   JsonTokenized (char literal, JsonToken token) {
      this-> literal=string (1,literal);
      this-> token= token;
   }
 public:
   JsonTokenized (string literal, JsonToken token) {
      this-> literal= literal;
      this-> token= token;
   }
 public:
   string as_str() {
      
return "JsonTokenized(literal: \"" + to_string(literal) + "\", type: \"" + to_string(token) + "\")";
   }
};
vector<JsonTokenized> json_tokenize_json(string json) {
   vector< JsonTokenized> tokens= {};
      auto  iter = Peekable<char>(json);
      string  buf = "";
      bool  escaped = true;
      while(iter.peek () .is_some ()    ) {
            auto  ch = iter.next().value_or(' ');
            switch(ch    ) {
               case '{':
               tokens.push_back (JsonTokenized(ch, JsonToken::LBrace));
               break;
               case '}':
               tokens.push_back (JsonTokenized(ch, JsonToken::RBrace));
               break;
               case '[':
               tokens.push_back (JsonTokenized(ch, JsonToken::LBox));
               break;
               case ']':
               tokens.push_back (JsonTokenized(ch, JsonToken::RBox));
               break;
               case ':':
               tokens.push_back (JsonTokenized(ch, JsonToken::Colon));
               break;
               case ',':
               tokens.push_back (JsonTokenized(ch, JsonToken::Comma));
               break;
               case '"':
                  while(iter.peek () .is_some ()    ) {
                        auto  ch = iter.next().value_or(' ');
                        if(ch  == '"'  &&! escaped    ) {
                           
 break;
}
                     buf+=string (1,ch);
                        if(ch  == '\\'  ) {
                           
 escaped=true;
}
                        else {
                           
 escaped=false;
}
}
               tokens.push_back (JsonTokenized(buf, JsonToken::StringLiteral));
               buf="";
               break;
               case '\n':
               case ' ':
               
 break;
               default:
               buf=string (1,ch);
                  while(iter.peek () .is_some ()    ) {
                        auto  ch = iter.peek().value_or(' ');
                        if(ch  == '.'  &&String (buf) .to_num () .is_some ()    ) {
                           buf+=string (1,ch);
                           iter.next ();
                           continue;
}
                        if(! isalnum (ch)    ) {
                           
 break;
}
                     buf+=string (1,ch);
                     iter.next ();
}
                  if(buf  == "true" || buf  == "false"     ) {
                     tokens.push_back (JsonTokenized(buf, JsonToken::BooleanLiteral));
}
                  
{
auto num_optional_value = String(buf).to_num();
if(num_optional_value.is_some()) {
auto num = num_optional_value.value_unsafe();
                     tokens.push_back (JsonTokenized(buf, JsonToken::NumberLiteral));
}

}
               buf="";
               break;
}
}
   return  tokens;
}
class Json {
 private:
   string _name = "";
 private:
   JsonType _type = JsonType::Object;
 private:
   vector<Json*> _values = {};
 private:
   string _text_value = "";
 private:
   double _number_value = 0.0;
 private:
   bool _bool_value = false;
 public:
   Json () {
      
return ;
   }
 public:
   Json (string json_string) {
         auto  tokens = json_tokenize_json(json_string);
      _values= json_parse_json (tokens);
      _type= JsonType:: Object;
   }
 public:
   Json (string id, JsonType type) {
      this-> _name= id;
      this-> _type= type;
   }
 public:
   Json (string id, string value) {
      this-> _name= id;
      this-> _type= JsonType:: String;
      bool escaped=false;
      this-> _text_value="";
         for(int ch_iterator = 0; ch_iterator < value.size(); ch_iterator++) {
auto ch = value.at(ch_iterator);               if(ch  == '"'  &&! escaped    ) {
                  
 _text_value+="\\";
}
            _text_value+=string (1, ch);
            escaped= ch=='\\';
}
   }
 public:
   Json (string id, int value) {
      this-> _name= id;
      this-> _type= JsonType:: Number;
      this-> _number_value= value;
   }
 public:
   Json (string id, float value) {
      this-> _name= id;
      this-> _type= JsonType:: Number;
      this-> _number_value= value;
   }
 public:
   Json (string id, double value) {
      this-> _name= id;
      this-> _type= JsonType:: Number;
      this-> _number_value= value;
   }
 public:
   Json (string id, bool value) {
      this-> _name= id;
      this-> _type= JsonType:: Boolean;
      this-> _bool_value= value;
   }
 public:
   Json (string id, vector<Json*> values, JsonType type) {
      this-> _name= id;
      this-> _type= type;
      this-> _values= values;
   }
 public:
   Option<Json*> operator[](string id) {
         for(int value_iterator = 0; value_iterator < _values.size(); value_iterator++) {
auto value = _values.at(value_iterator);               if(value -> name ()  == id  ) {
                  
return  value;
}
}
      return  None< Json*> ();
   }
 public:
   void add(Json* value) {
      
 _values.push_back (value);
   }
 public:
template <typename T>
   void add(T value) {
      
 _values.push_back (new Json("", value));
   }
 public:
template <typename T>
   void try_add(string name, T value) {
         if(try_get (name) .is_some ()    ) {
            
return ;
}
      _values.push_back (new Json(name, value));
   }
 public:
   double value_or(double value) {
         if(_type  == JsonType :: Number  ) {
            
return  _number_value;
}
      return  value;
   }
 public:
   string value_or(string value) {
         if(_type  == JsonType :: String  ) {
            
return  String (_text_value) .replace ("\\\"", "\"");
}
      return  value;
   }
 public:
   bool value_or(bool value) {
         if(_type  == JsonType :: Boolean  ) {
            
return  _bool_value;
}
      return  value;
   }
 public:
   int size() {
      
return  _values.size ();
   }
 public:
   void pop() {
      
 _values.pop_back ();
   }
 public:
template <typename T>
   T try_get_value_of(string name, T value) {
         if(_type  == JsonType :: Array  ) {
            
return  value;
}
         
{
auto j_optional_value = try_get(name);
if(j_optional_value.is_some()) {
auto j = j_optional_value.value_unsafe();
            
return  j-> value_or (value);
}

}
      return  value;
   }
 public:
   Option<Json*> try_get(int at) {
         if(_type  != JsonType :: Array  ) {
            
return  None< Json*> ();
}
         if(at  < 0  ||at  >= _values.size ()  ) {
            
return  None< Json*> ();
}
      return  Some (_values.at(at));
   }
 public:
   Option<Json*> try_get(string name) {
         if(_type  == JsonType :: Array  ) {
            
return  None< Json*> ();
}
         for(int o_iterator = 0; o_iterator < _values.size(); o_iterator++) {
auto o = _values.at(o_iterator);               if(name  == o -> name ()  ) {
                  
return  o;
}
}
      return  None< Json*> ();
   }
 public:
   string name() {
      
return  _name;
   }
 public:
   JsonType type() {
      
return  _type;
   }
 public:
   string type_as_str() {
      
return  to_string (_type);
   }
 public:
   string value_as_str() {
      
return  as_j_str (false);
   }
 public:
   string as_j_str() {
      
return  as_j_str (true);
   }
 public:
   string as_j_str(bool add_name) {
         auto  buf = add_name?"\"" + to_string(_name) + "\": ":"";
         switch(_type    ) {
            case JsonType::String:
             buf+="\"" + to_string(_text_value) + "\"";
break ;
            case JsonType::Number:
             buf+= String ("" + to_string(_number_value) + "") .replace (",", ".");
break ;
            case JsonType::Boolean:
             buf+= _bool_value ?"true":"false";
break ;
            case JsonType::Array:
            buf+="[";
               for(int i = 0; i < _values.size(); i++) {
auto e = _values.at(i);                  buf+= e-> as_j_str (false);
                     if(i  < _values.size () - 1  ) {
                        buf+=", ";
}
}
            buf+="]";
            break;
            case JsonType::Object:
            buf+="{";
               for(int i = 0; i < _values.size(); i++) {
auto e = _values.at(i);                  buf+= e-> as_j_str ();
                     if(i  < _values.size () - 1  ) {
                        buf+=", ";
}
}
            buf+="}";
            break;
}
      return  buf;
   }
 public:
   void destruct() {
         for(int v_iterator = 0; v_iterator < _values.size(); v_iterator++) {
auto v = _values.at(v_iterator);            v-> destruct ();
            delete (v);
}
   }
};
void json_parser_panic(string message) {
   println ("\033[31mJSONPANIC >> " + to_string(message) + "\033[0m");
   exit (1);
}
JsonTokenized json_peek_or_panic(Peekable<JsonTokenized>* iter) {
      
{
auto peek_optional_value = iter->peek();
if(peek_optional_value.is_some()) {
auto peek = peek_optional_value.value_unsafe();
         
return  peek;
}

}
   json_parser_panic ("Expected token got EOF. (check missing pairs ()/\"\"/{}/[])");
   return  JsonTokenized ();
}
JsonTokenized json_next_or_panic(Peekable<JsonTokenized>* iter) {
      
{
auto next_optional_value = iter->next();
if(next_optional_value.is_some()) {
auto next = next_optional_value.value_unsafe();
         
return  next;
}

}
   json_parser_panic ("Expected token got EOF. (check missing pairs ()/\"\"/{}/[])");
   return  JsonTokenized ();
}
JsonTokenized json_next_is_or_panic(Peekable<JsonTokenized>* iter, JsonToken token) {
      
{
auto next_optional_value = iter->next();
if(next_optional_value.is_some()) {
auto next = next_optional_value.value_unsafe();
            if(next.token  == token  ) {
               
return  next;
}
         json_parser_panic ("Expected token " + to_string(token) + " got " + to_string(next.token) + "");
}

}
   json_parser_panic ("Expected token " + to_string(token) + " got EOF");
   return  JsonTokenized ();
}
vector<Json*> json_parse_json(vector<JsonTokenized> tokens) {
      auto  iter = Peekable<JsonTokenized>(tokens);
   json_next_is_or_panic (&iter, JsonToken::LBrace);
   return  json_parse_json_obj (&iter);
}
vector<Json*> json_parse_json_obj(Peekable<JsonTokenized>* iter) {
   vector< Json*> objects= {};
      while(true   ) {
            auto  current = json_next_or_panic(iter);
            if(current.token  == JsonToken :: RBrace  ) {
               
 break;
}
            switch(current.token    ) {
               case JsonToken::StringLiteral:
               objects.push_back (json_parse_identifier(iter, current, false));
               break;
               case JsonToken::Comma:
               
 break;
               default:
                json_parser_panic ("Unallowed token in object " + to_string(current.token) + "");
break ;
}
}
   return  objects;
}
vector<Json*> json_parse_json_arr(Peekable<JsonTokenized>* iter) {
   vector< Json*> objects= {};
      int  i = 0;
      while(true   ) {
            auto  current = json_peek_or_panic(iter);
            if(current.token  == JsonToken :: RBox  ) {
                iter-> next ();
break ;
}
            switch(current.token    ) {
               case JsonToken::StringLiteral:
               case JsonToken::NumberLiteral:
               case JsonToken::BooleanLiteral:
               case JsonToken::LBrace:
               case JsonToken::LBox:
               objects.push_back (
                json_parse_identifier(
                    iter,
                    JsonTokenized(
                        "" + to_string(i++) + "",
                        JsonToken::StringLiteral
                    ),
                    true
                )
            );
               break;
               case JsonToken::Comma:
                iter-> next ();
break ;
               default:
                json_parser_panic ("Unallowed token in array " + to_string(current.token) + "");
break ;
}
}
   return  objects;
}
Json* json_parse_identifier(Peekable<JsonTokenized>* iter, JsonTokenized id, bool from_array) {
      if(! from_array    ) {
         
 json_next_is_or_panic (iter, JsonToken::Colon);
}
      auto  value = json_next_or_panic(iter);
      if(value.token  == JsonToken :: StringLiteral  ) {
         return new  Json (id.literal, value.literal);
}
      else if(value.token  == JsonToken :: NumberLiteral  ) {
         return new  Json (id.literal, String(value.literal).to_num().value_or(0.0));
}
      else if(value.token  == JsonToken :: BooleanLiteral  ) {
         return new  Json (id.literal, value.literal == "true");
}
      else if(value.token  == JsonToken :: LBrace  ) {
         return new  Json (id.literal, json_parse_json_obj(iter), JsonType::Object);
}
      else if(value.token  == JsonToken :: LBox  ) {
         return new  Json (id.literal, json_parse_json_arr(iter), JsonType::Array);
}
   json_parser_panic ("Expected Value got " + to_string(value.token) + "");
   return new  Json ();
}
Json load_json(string path) {
      
{
auto s_optional_value = read(path);
if(s_optional_value.is_some()) {
auto s = s_optional_value.value_unsafe();
         
return  Json (s);
}

}
   return  Json ();
}
void write_json(string path, Json content) {
      if(content.type ()  != JsonType :: Object  ) {
         
return ;
}
      auto  s = content.as_j_str(false);
   write (s, path);
}
enum class AnchorX: int {
   Left,
   Right,
};
string to_string(AnchorX enumerator) {
switch (enumerator) {
case AnchorX::Left: return "Left";
case AnchorX::Right: return "Right";
default: return "UNKNOWN TYPE";
}};
enum class AnchorY: int {
   Top,
   Bottom,
};
string to_string(AnchorY enumerator) {
switch (enumerator) {
case AnchorY::Top: return "Top";
case AnchorY::Bottom: return "Bottom";
default: return "UNKNOWN TYPE";
}};
enum class Fill: int {
   Flex,
   Static,
};
string to_string(Fill enumerator) {
switch (enumerator) {
case Fill::Flex: return "Flex";
case Fill::Static: return "Static";
default: return "UNKNOWN TYPE";
}};
template <typename T>
class List {
 private:
   vector<T> _list = {};
 public:
   List () {
      
return ;
   }
 public:
   List (vector<T> list) {
      
 _list= list;
   }
 public:
   T operator[](int at) {
      
return  _list[ at];
   }
 public:
   T at(int at) {
      
return  _list.at (at);
   }
 public:
   T* at_ptr(int at) {
      
return  &_list.at (at);
   }
 public:
   void set(int at, T val) {
      
 _list.at (at)= val;
   }
 public:
   Option<T> first() {
      
return  at (0);
   }
 public:
   Option<T> last() {
      
return  at (len()-1);
   }
 public:
   auto begin() {
      
return  _list.begin ();
   }
 public:
   auto end() {
      
return  _list.end ();
   }
 public:
   int len() {
      
return  _list.size ();
   }
 public:
   int size() {
      
return  _list.size ();
   }
 public:
   void add(T ele) {
      
 _list.push_back (ele);
   }
 public:
   void pop() {
      
 remove (len()-1);
   }
 public:
   void clear() {
      
 _list.clear ();
   }
 public:
   vector<T>* as_vec_ptr() {
      
return  &_list;
   }
 public:
   void insert(int at, T element) {
         if(len ()  == 0  ) {
            
 add (element);
return ;
}
         if(at  >= len ()  ) {
            
 add (element);
return ;
}
      vector< T> buf= {};
         int  i = 0;
         for(int ele_iterator = 0; ele_iterator < _list.size(); ele_iterator++) {
auto ele = _list.at(ele_iterator);               if(i  == at  ) {
                  
 buf.push_back (element);
}
            buf.push_back (ele);
            i++;
}
      clear ();
      _list= buf;
   }
 public:
   void remove(int index) {
         if(len ()  == 0  ) {
            
return ;
}
      vector< T> buf= {};
         int  i = 0;
         for(int ele_iterator = 0; ele_iterator < _list.size(); ele_iterator++) {
auto ele = _list.at(ele_iterator);               if(i  != index  ) {
                  
 buf.push_back (ele);
}
            i++;
}
      clear ();
      _list= buf;
   }
};
template <typename T>
string to_string(List<T> list) {
      auto  s = to_string(list.len())+" : [";
      for(int l_iterator = 0; l_iterator < list.size(); l_iterator++) {
auto l = list.at(l_iterator);         
 s+= to_string (l)+",";
}
   return  s+"]";
}
enum class ContainerType: int {
   Base,
   Grouped,
   Vertical,
   Horizontal,
   Main,
   Grid,
};
string to_string(ContainerType enumerator) {
switch (enumerator) {
case ContainerType::Base: return "Base";
case ContainerType::Grouped: return "Grouped";
case ContainerType::Vertical: return "Vertical";
case ContainerType::Horizontal: return "Horizontal";
case ContainerType::Main: return "Main";
case ContainerType::Grid: return "Grid";
default: return "UNKNOWN TYPE";
}};
struct NGuiOutline {
 public:
   string ld_corner = "└";
 public:
   string rd_corner = "┘";
 public:
   string lu_corner = "┌";
 public:
   string ru_corner = "┐";
 public:
   string vertical = "│";
 public:
   string horizontal = "─";
 public:
   NGuiOutline () {
      
return ;
   }
 public:
   NGuiOutline (string ld_corner, string rd_corner, string lu_corner, string ru_corner, string vertical, string horizontal) {
      this-> ld_corner= ld_corner;
      this-> rd_corner= rd_corner;
      this-> lu_corner= lu_corner;
      this-> ru_corner= ru_corner;
      this-> vertical= vertical;
      this-> horizontal= horizontal;
   }
};
class IContainer {
 protected:
   string _label = "";
 protected:
   Option<string> _fill_str = None<string>();
 protected:
   List<string> _content = List<string>();
 protected:
   List<IContainer*> _containers = List<IContainer*>();
 protected:
   ContainerType _type = ContainerType::Base;
 protected:
   short _color = 0;
 protected:
   Fill _fill_x = Fill::Flex;
 protected:
   Fill _fill_y = Fill::Flex;
 protected:
   Vector _size = Vector(0,0);
 protected:
   Vector _offset = Vector(0,0);
 protected:
   bool is_active = true;
 protected:
   bool is_outline = false;
 protected:
   NGuiOutline outline = NGuiOutline();
 public:
   IContainer () {
      
return ;
   }
 public:
   IContainer (Fill f) {
      _fill_x= f;
      _fill_y= f;
   }
 public:
   IContainer (Fill f, Vector s) {
      _fill_x= f;
      _fill_y= f;
      _size= s;
   }
 public:
   IContainer (Fill f, Vector s, string fill_str) {
      _fill_x= f;
      _fill_y= f;
      _size= s;
      _fill_str= fill_str;
   }
 public:
   IContainer (Vector s, Vector o) {
      _size= s;
      _offset= o;
   }
 public:
   IContainer (Fill f_x, Fill f_y, Vector s, Vector o) {
      _fill_x= f_x;
      _fill_y= f_y;
      _size= s;
      _offset= o;
   }
 public:
   ContainerType Type() {
      
return  _type;
   }
 public:
   Fill FillY() {
      
return  _fill_y;
   }
 public:
   Fill FillX() {
      
return  _fill_x;
   }
 public:
   Vector Size() {
      
return  _size;
   }
 public:
   Vector Offset() {
      
return  _offset;
   }
 public:
   short Color() {
      
return  _color;
   }
 public:
   string Label() {
      
return  _label;
   }
 public:
   bool Active() {
      
return  is_active;
   }
 public:
   void SetActive(bool active) {
      
 is_active= active;
   }
 public:
   void SetSize(int x, int y) {
      
 _size= Vector (x,y);
   }
 public:
   void SetOffset(int x, int y) {
      
 _offset= Vector (x,y);
   }
 public:
   void SetColor(short col) {
      
 _color= col;
   }
 public:
   void SetLabel(string label) {
      
 _label= label;
   }
 public:
   void SetContent(List<string> content) {
      _content.clear ();
      _content= content;
   }
 public:
   void ToggleOutline() {
      
 is_outline=! is_outline;
   }
 public:
   List<string> GetContent() {
      
return  _content;
   }
 public:
   void add(IContainer* c) {
      
 _containers.add (c);
   }
 public:
   int size() {
      
return  _containers.len ();
   }
 public:
   List<IContainer*>* containers() {
      
return  &_containers;
   }
 public:
   void clear() {
      
 _containers= {};
   }
 public:
   void draw_outline(Ncurses* n) {
         if(is_outline    ) {
            n-> add (_offset.y-1, _offset.x-1, outline.lu_corner);
               for(int i = 0; i < _size.x; i++) {
                  
 n-> add (_offset.y-1, _offset.x+i, outline.horizontal);
}
            n-> add (_offset.y-1, _offset.x-1 + _size.x + 1, outline.ru_corner);
               for(int i = 0; i < _size.y; i++) {
                  n-> add (_offset.y+i, _offset.x-1, outline.vertical);
                  n-> add (_offset.y+i, _offset.x-1 + _size.x + 1, outline.vertical);
}
            n-> add (_offset.y-1 + _size.y + 1, _offset.x-1, outline.ld_corner);
               for(int i = 0; i < _size.x; i++) {
                  
 n-> add (_offset.y-1 + _size.y + 1, _offset.x+i, outline.horizontal);
}
            n-> add (_offset.y-1 + _size.y + 1, _offset.x-1 + _size.x + 1, outline.rd_corner);
}
   }
 public:
   void draw(Ncurses* n) {
         if(! is_active    ) {
            
return ;
}
      n-> col (_color < 0 ? -_color : _color);
         if(_color  >= 0  ) {
            
 n-> invis_box (_offset, _size);
}
         else {
            
 n-> box (_offset - Vector(1,1), _size + Vector(2,2));
}
         
{
auto filling_optional_value = _fill_str;
if(filling_optional_value.is_some()) {
auto filling = filling_optional_value.value_unsafe();
               for(int i = 0; i < _size.y; i++) {
                  
 n-> add (_offset.y + i, _offset.x, filling);
}
}

}
      n-> add_until (_offset, _label, _size.x + _offset.x, true);
         int  i = 0;
         for(int s_iterator = 0; s_iterator < _content.size(); s_iterator++) {
auto s = _content.at(s_iterator);               if(i  >= _size.y  ) {
                  
 break;
}
            n-> add_until (_offset.y + i++, _offset.x, s, _size.x + _offset.x, false);
}
      n-> col (_color < 0 ? -_color : _color, false);
   }
};
class GroupedContainer: public IContainer {
 public:
   GroupedContainer () {
      _type= ContainerType:: Grouped;
   }
 public:
   void draw(Ncurses* n) {
         if(! is_active    ) {
            
return ;
}
      ((IContainer*)this)-> draw (n);
         for(int c_iterator = 0; c_iterator < _containers.size(); c_iterator++) {
auto c = _containers.at(c_iterator);            
 draw_container_impl (c,n);
}
   }
};
class HorizontalLayout: public GroupedContainer {
 public:
   HorizontalLayout () {
      _type= ContainerType:: Horizontal;
   }
 public:
   HorizontalLayout (Fill f) {
      _type= ContainerType:: Horizontal;
      _fill_x= f;
      _fill_y= f;
   }
 public:
   HorizontalLayout (Fill f, Vector s) {
      _type= ContainerType:: Horizontal;
      _fill_x= f;
      _fill_y= f;
      _size= s;
   }
 public:
   HorizontalLayout (Vector s, Vector o) {
      _type= ContainerType:: Horizontal;
      _size= s;
      _offset= o;
   }
 public:
   void draw(Ncurses* n) {
         if(! is_active    ) {
            
return ;
}
      update ();
      ((GroupedContainer*)this)-> draw (n);
   }
 public:
   void update() {
      double available_space= _size.x;
      int offset= 0;
      int sharers= 0;
      int extra= 0;
         for(int c_iterator = 0; c_iterator < _containers.size(); c_iterator++) {
auto c = _containers.at(c_iterator);               if(! c -> Active ()    ) {
                  
 continue;
}
               switch(c -> FillX ()    ) {
                  case Fill::Static:
                   available_space-= c-> Size () .x;
break ;
                  case Fill::Flex:
                   sharers++;
break ;
}
}
         if(sharers  != 0  ) {
            int space= available_space/ sharers;
            int diff= available_space- (space * sharers);
            extra= diff;
}
         for(int i = 0; i < _containers.size(); i++) {
               auto  c = _containers.at(i);
               if(! c -> Active ()    ) {
                  
 continue;
}
            c-> SetOffset (offset + _offset.x, _offset.y);
               if(c -> FillX ()  == Fill :: Flex  ) {
                  c-> SetSize ((available_space / sharers), _size.y);
}
               if(i + 1  == _containers.size ()  ) {
                  c-> SetSize (c->Size().x + extra, _size.y);
}
            c-> SetSize (c->Size().x, _size.y);
            offset+= c-> Size () .x;
}
   }
};
class VerticalLayout: public GroupedContainer {
 public:
   VerticalLayout () {
      _type= ContainerType:: Vertical;
   }
 public:
   VerticalLayout (Fill f) {
      _type= ContainerType:: Vertical;
      _fill_x= f;
      _fill_y= f;
   }
 public:
   VerticalLayout (Fill f, Vector s) {
      _type= ContainerType:: Vertical;
      _fill_x= f;
      _fill_y= f;
      _size= s;
   }
 public:
   VerticalLayout (Vector s, Vector o) {
      _type= ContainerType:: Vertical;
      _size= s;
      _offset= o;
   }
 public:
   void draw(Ncurses* n) {
         if(! is_active    ) {
            
return ;
}
      update ();
      ((GroupedContainer*)this)-> draw (n);
   }
 public:
   void update() {
      double available_space= _size.y;
      int offset= 0;
      int sharers= 0;
      int extra= 0;
         for(int c_iterator = 0; c_iterator < _containers.size(); c_iterator++) {
auto c = _containers.at(c_iterator);               if(! c -> Active ()    ) {
                  
 continue;
}
               switch(c -> FillY ()    ) {
                  case Fill::Static:
                   available_space-= c-> Size () .y;
break ;
                  case Fill::Flex:
                   sharers++;
break ;
}
}
         if(sharers  != 0  ) {
            int space= available_space/ sharers;
            int diff= available_space- (space * sharers);
            extra= diff;
}
         for(int i = 0; i < _containers.size(); i++) {
               auto  c = _containers.at(i);
               if(! c -> Active ()    ) {
                  
 continue;
}
            c-> SetOffset (_offset.x, offset + _offset.y);
               if(c -> FillY ()  == Fill :: Flex  ) {
                  c-> SetSize (_size.x, (available_space / sharers));
}
               if(i + 1  == _containers.size ()  ) {
                  c-> SetSize (_size.x, c->Size().y + extra);
}
            c-> SetSize (_size.x, c->Size().y);
            offset+= c-> Size () .y;
}
   }
};
class Button: public IContainer {
 private:
   bool _selected = false;
 public:
   Button () {
      this-> _type= ContainerType:: Base;
      this-> _fill_x= Fill:: Flex;
      this-> _fill_y= Fill:: Static;
      this-> _size= Vector (0,3);
      this-> _label="Button";
   }
 public:
   Button (int width) {
      this-> _type= ContainerType:: Base;
      this-> _fill_x= Fill:: Static;
      this-> _fill_y= Fill:: Static;
      this-> _size= Vector (width, 3);
      this-> _label="Button";
   }
 public:
   void hover() {
      
 _selected=true;
   }
 public:
   void unhover() {
      
 _selected=false;
   }
 public:
   void draw(Ncurses* n) {
      n-> col (_selected);
      n-> box (_offset.y, _offset.x, _size.y, _size.x);
         auto  pos_y = _size.y/2;
         auto  pos_x = (_size.x/2)-(_label.size()/2);
      n-> add (_offset.y + pos_y, _offset.x + pos_x, _label);
      n-> col (_selected, false);
   }
};
class FilledRect: public IContainer {
 private:
   string _fill = " ";
 public:
   FilledRect (string fill) {
      this-> _fill= fill;
   }
 public:
   FilledRect (string fill, Vector size) {
      this-> _fill_x= size.x!= 0 ? Fill:: Static: Fill:: Flex;
      this-> _fill_y= size.y!= 0 ? Fill:: Static: Fill:: Flex;
      this-> _fill= fill;
      this-> _size= size;
   }
 public:
   void draw(Ncurses* n) {
      n-> col (_color);
         for(int i = 0; i < _size.y; i++) {
               for(int j = 0; j < _size.x; j++) {
                  n-> add (_offset.y + i, _offset.x + j, _fill);
}
}
      n-> col (_color, false);
   }
};
class MainContainer: public VerticalLayout {
 public:
   MainContainer () {
      _type= ContainerType:: Main;
      _size= Vector (COLS, LINES);
      _offset= Vector (0,0);
   }
 public:
   MainContainer (Vector padding) {
      _type= ContainerType:: Main;
      _size= Vector (COLS - (padding.x * 2), LINES - (padding.y * 2));
      _offset= padding;
   }
 public:
   void update() {
      _size= Vector (COLS - (_offset.x * 2), LINES - (_offset.y * 2));
      ((VerticalLayout*)this)-> update ();
   }
 public:
   void draw(Ncurses* n) {
         if(! is_active    ) {
            
return ;
}
      update ();
      ((IContainer*)this)-> draw (n);
         for(int c_iterator = 0; c_iterator < _containers.size(); c_iterator++) {
auto c = _containers.at(c_iterator);            
 draw_container_impl (c,n);
}
   }
};
class GridLayout: public VerticalLayout {
 private:
   vector<IContainer*> _grid_elements = {};
 private:
   vector<HorizontalLayout*> _rows = {};
 public:
   GridLayout () {
      _type= ContainerType:: Grid;
   }
 public:
   GridLayout (Fill f) {
      _type= ContainerType:: Grid;
      _fill_x= f;
      _fill_y= f;
   }
 public:
   GridLayout (Fill f, Vector s) {
      _type= ContainerType:: Grid;
      _fill_x= f;
      _fill_y= f;
      _size= s;
   }
 public:
   GridLayout (Vector s, Vector o) {
      _type= ContainerType:: Grid;
      _size= s;
      _offset= o;
   }
 public:
   void draw(Ncurses* n) {
         if(! is_active    ) {
            
return ;
}
      arrange_elements ();
      ((VerticalLayout*)this)-> draw (n);
   }
 public:
   HorizontalLayout* add_row() {
         auto  row = new HorizontalLayout(Fill::Flex);
      add (row);
      _rows.push_back (row);
      arrange_elements ();
      return  row;
   }
 public:
   void add_element(IContainer* element) {
      _grid_elements.push_back (element);
      arrange_elements ();
   }
 public:
   void arrange_elements() {
         if(_rows.size ()  == 0  ) {
            
return ;
}
         for(int row_iterator = 0; row_iterator < _rows.size(); row_iterator++) {
auto row = _rows.at(row_iterator);            
 row-> clear ();
}
         for(int i = 0; i < _grid_elements.size(); i++) {
auto ele = _grid_elements.at(i);            _rows[ i % _rows.size ()]-> add (ele);
}
   }
 public:
   void destruct() {
         for(int row_iterator = 0; row_iterator < _rows.size(); row_iterator++) {
auto row = _rows.at(row_iterator);            
 delete (row);
}
         for(int ele_iterator = 0; ele_iterator < _grid_elements.size(); ele_iterator++) {
auto ele = _grid_elements.at(ele_iterator);            
 delete (ele);
}
      _grid_elements.clear ();
      _rows.clear ();
   }
};
void draw_container_impl(IContainer* c, Ncurses* n) {
      if(! c -> Active ()    ) {
         
return ;
}
      switch(c -> Type ()    ) {
         case ContainerType::Base:
          c-> draw (n);
break ;
         case ContainerType::Grouped:
          ((GroupedContainer*)c)-> draw (n);
break ;
         case ContainerType::Vertical:
          ((VerticalLayout*)c)-> draw (n);
break ;
         case ContainerType::Horizontal:
          ((HorizontalLayout*)c)-> draw (n);
break ;
         case ContainerType::Main:
          ((MainContainer*)c)-> draw (n);
break ;
         case ContainerType::Grid:
          ((GridLayout*)c)-> draw (n);
break ;
         default:
         n-> add (2,0,c->Label());
         n-> add (1,0,(int)c->Type());
         n-> add (0,0,"ERORR");
         n-> key ();
         break;
}
}
class SpiralLayout: public VerticalLayout {
 private:
   vector<IContainer*> _elements = {};
 private:
   vector<IContainer*> _dividers = {};
 public:
   SpiralLayout () {
      _type= ContainerType:: Vertical;
   }
 public:
   SpiralLayout (Fill f) {
      _type= ContainerType:: Vertical;
      _fill_x= f;
      _fill_y= f;
   }
 public:
   SpiralLayout (Fill f, Vector s) {
      _type= ContainerType:: Vertical;
      _fill_x= f;
      _fill_y= f;
      _size= s;
   }
 public:
   SpiralLayout (Vector s, Vector o) {
      _type= ContainerType:: Vertical;
      _size= s;
      _offset= o;
   }
 private:
   IContainer* get_row() {
         auto  div = (
            _dividers.size() % 2 == 0
                ? (IContainer*)new HorizontalLayout(Fill::Flex)
                : (IContainer*)new VerticalLayout(Fill::Flex)
        );
      _dividers.push_back (div);
      return  div;
   }
 public:
   void add_element(IContainer* element) {
         auto  row = get_row();
      row-> add (element);
         if(_dividers.size ()  == 1  ) {
            
 add (row);
}
         else if(_dividers.size ()  > 3  ) {
            _dividers[ _dividers.size ()- 2]-> containers ()-> insert (0, row);
}
         else {
            
 _dividers[ _dividers.size ()- 2]-> add (row);
}
   }
 public:
   void destruct() {
         for(int div_iterator = 0; div_iterator < _dividers.size(); div_iterator++) {
auto div = _dividers.at(div_iterator);            
 delete (div);
}
      _dividers.clear ();
   }
};
class StepLayout: public HorizontalLayout {
 private:
   vector<IContainer*> _elements = {};
 private:
   vector<IContainer*> _dividers = {};
 public:
   StepLayout () {
      _type= ContainerType:: Horizontal;
   }
 public:
   StepLayout (Fill f) {
      _type= ContainerType:: Horizontal;
      _fill_x= f;
      _fill_y= f;
   }
 public:
   StepLayout (Fill f, Vector s) {
      _type= ContainerType:: Horizontal;
      _fill_x= f;
      _fill_y= f;
      _size= s;
   }
 public:
   StepLayout (Vector s, Vector o) {
      _type= ContainerType:: Horizontal;
      _size= s;
      _offset= o;
   }
 private:
   IContainer* get_row() {
         auto  div = new HorizontalLayout(Fill::Flex);
      _dividers.push_back (div);
      return  div;
   }
 public:
   void add_element(IContainer* element) {
         auto  row = get_row();
      row-> add (element);
         if(_dividers.size ()  == 1  ) {
            
 add (row);
}
         else {
            
 _dividers[ _dividers.size ()- 2]-> add (row);
}
   }
 public:
   void destruct() {
         for(int div_iterator = 0; div_iterator < _dividers.size(); div_iterator++) {
auto div = _dividers.at(div_iterator);            
 delete (div);
}
      _dividers.clear ();
   }
};
double clamp(double value, double min, double max) {
      if(max  <= min  ) {
         
return  min;
}
      if(value  > max  ) {
         
return  max;
}
      if(value  < min  ) {
         
return  min;
}
   return  value;
}
double max(double v_one, double v_two) {
   
return  v_one> v_two ? v_one: v_two;
}
double min(double v_one, double v_two) {
   
return  v_one< v_two ? v_one: v_two;
}
struct RegexMatch {
 public:
   string match;
 public:
   int position = 0;
 public:
   RegexMatch () {
      
return ;
   }
 public:
   RegexMatch (string match, int pos) {
      this-> match= match;
      this-> position= pos;
   }
};
vector<RegexMatch> re(string line, regex reg, int capture, vector<Vector> claimed) {
   vector< RegexMatch> matches_str= {};
   sregex_iterator current (line.begin(), line.end(), reg);
   sregex_iterator last;
      while(current  != last  ) {
         smatch match=* current;
            if(match.str (capture) .size ()  != 0  ) {
                  auto  pos = match.position(capture);
                  bool  already_claimed = false;
                  for(int claim_iterator = 0; claim_iterator < claimed.size(); claim_iterator++) {
auto claim = claimed.at(claim_iterator);                        auto  in_start = pos>=claim.x;
                        auto  in_end = pos<=claim.y;
                        if(in_start    &&in_end    ) {
                            already_claimed=true;
break ;
}
}
                  if(! already_claimed    ) {
                     matches_str.push_back (RegexMatch(match.str(capture), match.position(capture)));
}
}
         current++;
}
   return  matches_str;
}
vector<RegexMatch> re(string line, regex reg, int capture) {
   vector< RegexMatch> matches_str= {};
   sregex_iterator current (line.begin(), line.end(), reg);
   sregex_iterator last;
      while(current  != last  ) {
         smatch match=* current;
            if(match.str (capture) .size ()  != 0  ) {
               matches_str.push_back (RegexMatch(match.str(capture), match.position(capture)));
}
         current++;
}
   return  matches_str;
}
vector<RegexMatch> re(string line, string rex, int capture) {
   vector< RegexMatch> matches_str= {};
   regex reg (rex);
   sregex_iterator current (line.begin(), line.end(), reg);
   sregex_iterator last;
      while(current  != last  ) {
         smatch match=* current;
            if(match.str (capture) .size ()  != 0  ) {
               matches_str.push_back (RegexMatch(match.str(capture), match.position(capture)));
}
         current++;
}
   return  matches_str;
}
enum class Dir: int {
   Up,
   Down,
   Left,
   Right,
};
string to_string(Dir enumerator) {
switch (enumerator) {
case Dir::Up: return "Up";
case Dir::Down: return "Down";
case Dir::Left: return "Left";
case Dir::Right: return "Right";
default: return "UNKNOWN TYPE";
}};
enum class Command: int {
   Exit,
   ModeNormal,
   ModeVisual,
   ModeInsert,
   ModeFileEx,
   ModeCmdHan,
   SelectFile,
   CloseEditor,
   CloseEditorForced,
   WriteEditor,
   WriteCloseEditor,
   SplitVertical,
   SplitHorizontal,
   MoveCursor,
   EditorLeft,
   EditorRight,
   EditorUp,
   EditorDown,
   EditorTemplates,
   EditorSearch,
   EditorReplace,
   Nop,
};
string to_string(Command enumerator) {
switch (enumerator) {
case Command::Exit: return "Exit";
case Command::ModeNormal: return "ModeNormal";
case Command::ModeVisual: return "ModeVisual";
case Command::ModeInsert: return "ModeInsert";
case Command::ModeFileEx: return "ModeFileEx";
case Command::ModeCmdHan: return "ModeCmdHan";
case Command::SelectFile: return "SelectFile";
case Command::CloseEditor: return "CloseEditor";
case Command::CloseEditorForced: return "CloseEditorForced";
case Command::WriteEditor: return "WriteEditor";
case Command::WriteCloseEditor: return "WriteCloseEditor";
case Command::SplitVertical: return "SplitVertical";
case Command::SplitHorizontal: return "SplitHorizontal";
case Command::MoveCursor: return "MoveCursor";
case Command::EditorLeft: return "EditorLeft";
case Command::EditorRight: return "EditorRight";
case Command::EditorUp: return "EditorUp";
case Command::EditorDown: return "EditorDown";
case Command::EditorTemplates: return "EditorTemplates";
case Command::EditorSearch: return "EditorSearch";
case Command::EditorReplace: return "EditorReplace";
case Command::Nop: return "Nop";
default: return "UNKNOWN TYPE";
}};
enum class Mode: int {
   Normal,
   Insert,
   Visual,
   CmdHan,
   FileEx,
};
string to_string(Mode enumerator) {
switch (enumerator) {
case Mode::Normal: return "Normal";
case Mode::Insert: return "Insert";
case Mode::Visual: return "Visual";
case Mode::CmdHan: return "CmdHan";
case Mode::FileEx: return "FileEx";
default: return "UNKNOWN TYPE";
}};
enum class TextEdit: int {
   Tab,
   Untab,
   Insert,
   InsertNl,
   RemoveChar,
   DeleteChar,
   DeleteWord,
   DeleteWordExlusive,
   DeleteFrom,
   DeleteLine,
   PasteLine,
   PasteWord,
   Upper,
   Lower,
   CommentToggle,
};
string to_string(TextEdit enumerator) {
switch (enumerator) {
case TextEdit::Tab: return "Tab";
case TextEdit::Untab: return "Untab";
case TextEdit::Insert: return "Insert";
case TextEdit::InsertNl: return "InsertNl";
case TextEdit::RemoveChar: return "RemoveChar";
case TextEdit::DeleteChar: return "DeleteChar";
case TextEdit::DeleteWord: return "DeleteWord";
case TextEdit::DeleteWordExlusive: return "DeleteWordExlusive";
case TextEdit::DeleteFrom: return "DeleteFrom";
case TextEdit::DeleteLine: return "DeleteLine";
case TextEdit::PasteLine: return "PasteLine";
case TextEdit::PasteWord: return "PasteWord";
case TextEdit::Upper: return "Upper";
case TextEdit::Lower: return "Lower";
case TextEdit::CommentToggle: return "CommentToggle";
default: return "UNKNOWN TYPE";
}};
enum class SyntaxType: int {
   Plain,
   Halp,
};
string to_string(SyntaxType enumerator) {
switch (enumerator) {
case SyntaxType::Plain: return "Plain";
case SyntaxType::Halp: return "Halp";
default: return "UNKNOWN TYPE";
}};
struct SyntaxTemplate {
 public:
   string template_name = "";
 public:
   vector<string> templates = {};
 public:
   SyntaxTemplate () {
      
return ;
   }
 public:
   SyntaxTemplate (Json* temp) {
      template_name= temp-> try_get_value_of ("name", (string)"");
         
{
auto temps_optional_value = temp->try_get("template");
if(temps_optional_value.is_some()) {
auto temps = temps_optional_value.value_unsafe();
               for(int i = 0; i < temps->size(); i++) {
                     
{
auto t_optional_value = temps->try_get(i);
if(t_optional_value.is_some()) {
auto t = t_optional_value.value_unsafe();
                        templates.push_back (t->value_or((string)""));
}

}
}
}

}
   }
};
struct SyntaxBox {
 public:
   vector<short> colors = {};
 public:
   string start = "";
 public:
   string end = "";
 public:
   SyntaxBox () {
      
return ;
   }
 public:
   SyntaxBox (Json* box) {
      start= box-> try_get_value_of ("start", (string)"");
      end= box-> try_get_value_of ("end", (string)"");
         
{
auto cs_optional_value = box->try_get("colors");
if(cs_optional_value.is_some()) {
auto cs = cs_optional_value.value_unsafe();
               for(int i = 0; i < cs->size(); i++) {
                     
{
auto c_optional_value = cs->try_get(i);
if(c_optional_value.is_some()) {
auto c = c_optional_value.value_unsafe();
                        colors.push_back ((short)c->value_or(0.0));
}

}
}
}

}
   }
};
struct SyntaxCustom {
 public:
   short color = 0;
 public:
   int capture = 0;
 public:
   bool bold = false;
 public:
   bool dim = false;
 public:
   regex expr;
 public:
   SyntaxCustom () {
      
return ;
   }
 public:
   SyntaxCustom (Json* custom) {
      color= custom-> try_get_value_of ("color", 0.0);
      capture= custom-> try_get_value_of ("capture", 0.0);
      bold= custom-> try_get_value_of ("bold", false);
      dim= custom-> try_get_value_of ("dim", false);
      expr= regex (custom->try_get_value_of("expr", (string)"*"));
   }
};
struct SyntaxRule {
 public:
   string type;
 public:
   string value;
 public:
   regex expr;
 public:
   int capture;
 public:
   string validation_type;
 public:
   string validation_value;
 public:
   SyntaxRule () {
      
return ;
   }
 public:
   SyntaxRule (Json* rule) {
      type= rule-> try_get_value_of ("type", (string)"");
      value= rule-> try_get_value_of ("value", (string)"");
      expr= regex (rule->try_get_value_of("regex", (string)"*"));
      capture= rule-> try_get_value_of ("capture", 0.0);
      validation_type= rule-> try_get_value_of ("validate", (string)"");
      validation_value= rule-> try_get_value_of ("validation_value", (string)"");
   }
};
class Syntax {
 private:
   SyntaxType _type = SyntaxType::Plain;
 private:
   Json _definition = Json();
 private:
   bool _is_complete = false;
 private:
   string _cached_tree = "";
 private:
   vector<TreeSitterBlock> _cached_t_block = {};
 private:
   string _name = "plain";
 private:
   string _file_type = ".txt";
 private:
   vector<SyntaxBox> _boxings = {};
 private:
   vector<SyntaxCustom> _customs = {};
 private:
   vector<string> _wordlist = {};
 private:
   vector<SyntaxRule> _rules = {};
 private:
   vector<SyntaxTemplate> _templates = {};
 public:
   Syntax () {
      
return ;
   }
 public:
   Syntax (string type) {
      this-> _file_type= type;
         string  home = ".";
         
{
auto home_opt_optional_value = env("HOME");
if(home_opt_optional_value.is_some()) {
auto home_opt = home_opt_optional_value.value_unsafe();
            home= home_opt;
}

}
         string  config = "" + to_string(home) + "/.config/hide/";
      _definition= load_json ("" + to_string(config) + "" + to_string(type) + ".json");
         
{
auto name_optional_value = _definition.try_get("name");
if(name_optional_value.is_some()) {
auto name = name_optional_value.value_unsafe();
            _name= name-> value_or ((string)"");
            _is_complete=true;
}

}
         
{
auto boxings_optional_value = _definition.try_get("boxing");
if(boxings_optional_value.is_some()) {
auto boxings = boxings_optional_value.value_unsafe();
               for(int i = 0; i < boxings->size(); i++) {
                     
{
auto box_optional_value = boxings->try_get(i);
if(box_optional_value.is_some()) {
auto box = box_optional_value.value_unsafe();
                        _boxings.push_back (SyntaxBox(box));
}

}
}
}

}
         
{
auto customs_optional_value = _definition.try_get("custom");
if(customs_optional_value.is_some()) {
auto customs = customs_optional_value.value_unsafe();
               for(int i = 0; i < customs->size(); i++) {
                     
{
auto custom_optional_value = customs->try_get(i);
if(custom_optional_value.is_some()) {
auto custom = custom_optional_value.value_unsafe();
                        _customs.push_back (SyntaxCustom(custom));
}

}
}
}

}
         
{
auto wl_optional_value = _definition.try_get("wordlist");
if(wl_optional_value.is_some()) {
auto wl = wl_optional_value.value_unsafe();
               for(int i = 0; i < wl->size(); i++) {
                     
{
auto w_optional_value = wl->try_get(i);
if(w_optional_value.is_some()) {
auto w = w_optional_value.value_unsafe();
                           auto  word = w->value_or((string)"");
                        _wordlist.push_back (word);
}

}
}
}

}
         
{
auto rules_optional_value = _definition.try_get("rules");
if(rules_optional_value.is_some()) {
auto rules = rules_optional_value.value_unsafe();
               for(int i = 0; i < rules->size(); i++) {
                     
{
auto rule_optional_value = rules->try_get(i);
if(rule_optional_value.is_some()) {
auto rule = rule_optional_value.value_unsafe();
                        _rules.push_back (SyntaxRule(rule));
}

}
}
}

}
         
{
auto templates_optional_value = _definition.try_get("templates");
if(templates_optional_value.is_some()) {
auto templates = templates_optional_value.value_unsafe();
               for(int i = 0; i < templates->size(); i++) {
                     
{
auto temp_optional_value = templates->try_get(i);
if(temp_optional_value.is_some()) {
auto temp = temp_optional_value.value_unsafe();
                        _templates.push_back (SyntaxTemplate(temp));
}

}
}
}

}
   }
 public:
   vector<string> wordlist() {
      
return  _wordlist;
   }
 public:
   bool is_complete() {
      
return  _is_complete;
   }
 public:
   string name() {
      
return  _name;
   }
 public:
   SyntaxType type() {
      
return  _type;
   }
 public:
   vector<SyntaxBox> boxing() {
      
return  _boxings;
   }
 public:
   vector<SyntaxCustom> custom() {
      
return  _customs;
   }
 public:
   vector<SyntaxRule> rules() {
      
return  _rules;
   }
 public:
   vector<SyntaxTemplate> templates() {
      
return  _templates;
   }
 public:
   string file_type() {
      
return  _file_type;
   }
 public:
   vector<TreeSitterBlock> cached_blocks(string key) {
         if(key  == _cached_tree  ) {
            
return  _cached_t_block;
}
      return  {};
   }
 public:
   void set_cache(string tree, vector<TreeSitterBlock> blocks) {
      _cached_tree= tree;
      _cached_t_block= blocks;
   }
};
struct TreeSitterBlock {
 public:
   string info = "";
 public:
   string target = "";
 public:
   Vector min = Vector();
 public:
   Vector max = Vector();
 public:
   TreeSitterBlock (string block) {
         auto  pieces = String(block).split(' ');
         auto  n = Ncurses();
         if(pieces.size ()  < 5  ) {
            
return ;
}
      this-> info= pieces[ 0];
         auto  extra = pieces.size()==6?1:0;
         if(extra  == 1  ) {
            this-> target= pieces[ 1];
}
      this-> min= Vector (
            String(pieces[2+extra]).to_num().value_or(0),
            String(pieces[1+extra]).to_num().value_or(0)
        );
      this-> max= Vector (
            String(pieces[4+extra]).to_num().value_or(0),
            String(pieces[3+extra]).to_num().value_or(0)
        );
   }
 public:
   string as_str() {
      return "BLOCK(info: " + to_string(info) + ", min: " + to_string(min.x) + "," + to_string(min.y) + ", max: " + to_string(max.x) + "," + to_string(max.y) + ")";
   }
};
class TreeSitter {
 private:
   Vector internal_offset = Vector();
 private:
   Vector offset = Vector();
 private:
   Vector size = Vector();
 private:
   string path = "";
 private:
   string text = "";
 private:
   List<string> lines = List<string>();
 private:
   Ncurses* n;
 private:
   Syntax* syntax;
 public:
   TreeSitter (IContainer* container, Ncurses* n, string path, List<string> text, Vector internal_offset, Syntax* s) {
      this-> internal_offset= internal_offset;
      this-> offset= container-> Offset ();
      this-> size= container-> Size ();
      this-> n= n;
      this-> syntax= s;
      this-> path="temp_tree_sitter." + to_string(s->file_type()) + "";
      this-> lines= text;
      this-> text= join_text (text);
   }
 private:
   string join_text(vector<string> text) {
      
return  join_text (List<string>(text));
   }
 private:
   string join_text(List<string> text) {
         string  s = "";
         for(int line_iterator = 0; line_iterator < text.size(); line_iterator++) {
auto line = text.at(line_iterator);            
 s+= line+"\n";
}
      return  s;
   }
 private:
   bool is_error() {
         auto  output = system_output("tree-sitter parse " + to_string(path) + " -q 2> /dev/null");
         if(output.size ()  == 0  ) {
            
return false;
}
         auto  s = String(output[output.size() - 1]);
      return  s.contains ("ERROR")|| s.contains ("MISSING");
   }
 private:
   vector<TreeSitterBlock> get_tree() {
         auto  output = system_output("tree-sitter parse " + to_string(path) + " 2> /dev/null");
         auto  joined = join_text(output);
         auto  blocks = String(joined).split('(');
         for(int i = 0; i < blocks.size(); i++) {
            blocks[ i]= String (blocks[i]) .replace (")", "");
            blocks[ i]= String (blocks[i]) .replace ("[", "");
            blocks[ i]= String (blocks[i]) .replace ("]", "");
            blocks[ i]= String (blocks[i]) .replace ("-", "");
            blocks[ i]= String (blocks[i]) .replace (",", "");
            blocks[ i]= String (blocks[i]) .replace ("  ", " ");
            blocks[ i]= String (blocks[i]) .strip ();
}
      return  parse_blocks (blocks);
   }
 private:
   vector<TreeSitterBlock> parse_blocks(vector<string> blocks) {
      vector< TreeSitterBlock> ts_blocks= {};
         for(int b_iterator = 0; b_iterator < blocks.size(); b_iterator++) {
auto b = blocks.at(b_iterator);               auto  ts_block = TreeSitterBlock(b);
               if(ts_block.info  == ""  ) {
                  
 continue;
}
            ts_blocks.push_back (ts_block);
}
      syntax-> set_cache (text, ts_blocks);
      return  ts_blocks;
   }
 public:
   void run() {
         auto  tree = syntax->cached_blocks(text);
         if(tree.size ()  == 0  ) {
            write (text, path);
               if(! is_error ()    ) {
                  
 remove (path);
return ;
}
            tree= get_tree ();
}
         auto  end = size.x+offset.x;
         for(int i = 0; i < tree.size(); i++) {
auto b = tree.at(i);               if(b.info  != "ERROR"  &&b.info  != "MISSING"  ) {
                  
 continue;
}
               auto  line = lines.len()>b.min.y?lines.at(b.min.y):" ";
               if(b.max.y  > b.min.y  ) {
                  
 b.max.x= line.size ();
}
               if(b.min.y  >= size.y + internal_offset.y  ) {
                  
 break;
}
               if(b.min.y  < internal_offset.y  ) {
                  
 continue;
}
            n-> underline_until (b.min + offset - internal_offset, 256, b.max.x - b.min.x);
            n-> mark_until (offset + Vector(-5, b.min.y - internal_offset.y), 256, 5);
            n-> col (1);
            n-> add_until (offset + Vector(line.size() + 1, b.min.y - internal_offset.y), "◉ " + to_string(b.info) + " " + to_string(b.target) + "", end, true);
            n-> col (1,false);
}
      remove (path);
   }
};
void error_checker(Syntax* syntax, IContainer* container, Ncurses* n, string path, List<string> text, Vector internal_offset) {
   init_pair (256, 196, 239);
   TreeSitter (container, n, path, text, internal_offset, syntax) .run ();
      if(! syntax -> is_complete ()    ) {
         
return ;
}
      auto  content = container->GetContent();
      int  y = 0;
      auto  rules = syntax->rules();
      auto  offset = container->Offset();
      auto  size = container->Size();
      auto  end = size.x+offset.x;
      string  path_dir = "";
      auto  path_split = String(path).split('/');
   path_split.pop_back ();
      for(int p_iterator = 0; p_iterator < path_split.size(); p_iterator++) {
auto p = path_split.at(p_iterator);         
 path_dir+= p+"/";
}
      for(int line_iterator = 0; line_iterator < content.size(); line_iterator++) {
auto line = content.at(line_iterator);            if(y  >= size.y  ) {
               
 break;
}
            auto  s = String(line);
            for(int rule_iterator = 0; rule_iterator < rules.size(); rule_iterator++) {
auto rule = rules.at(rule_iterator);                  if(rule.type  == "starts_with"  &&! s.starts_with (rule.value)    ) {
                     
 continue;
}
                  if(rule.type  == "contains"  &&! s.contains (rule.value)    ) {
                     
 continue;
}
                  auto  matches = re(line, rule.expr, rule.capture);
                  for(int match_iterator = 0; match_iterator < matches.size(); match_iterator++) {
auto match = matches.at(match_iterator);                        if(rule.validation_type  == "file_exists"  ) {
                            file_exists_error_check (n, match, offset, size, y, path_dir, line);
continue ;
}
                        if(rule.validation_type  == "equals"  ) {
                            equals_error_check (n, match, offset, size, y, rule.validation_value, line);
continue ;
}
}
}
         y++;
}
}
void file_exists_error_check(Ncurses* n, RegexMatch match, Vector offset, Vector size, int y, string path_dir, string line) {
      auto  start = match.position+offset.x;
      auto  end = size.x+offset.x;
      auto  len = match.match.size();
      if(start  > end  ) {
         
return ;
}
      if(start + len  > end  ) {
         
 len= end- start;
}
      
{
auto home_optional_value = env("HOME");
if(home_optional_value.is_some()) {
auto home = home_optional_value.value_unsafe();
            
{
auto f_optional_value = read("" + to_string(home) + "/.local/lib/halppp/" + to_string(match.match) + ".ha");
if(f_optional_value.is_some()) {
auto f = f_optional_value.value_unsafe();
               
return ;
}

}
            
{
auto f_optional_value = read("" + to_string(path_dir) + "" + to_string(match.match) + ".ha");
if(f_optional_value.is_some()) {
auto f = f_optional_value.value_unsafe();
               
return ;
}

}
         n-> underline_until (y + offset.y, start, 256, len);
         n-> mark_until (y + offset.y, offset.x-5, 256, 5);
}

}
   n-> col (1);
   n-> add_until (y + offset.y, line.size() + offset.x + 1, "◉ CANNOT FIND FILE " + to_string(match.match) + "", end, true);
   n-> col (1,false);
}
void equals_error_check(Ncurses* n, RegexMatch match, Vector offset, Vector size, int y, string validation_value, string line) {
      if(match.match  == validation_value  ) {
         
return ;
}
      auto  start = match.position+offset.x;
      auto  end = size.x+offset.x;
      auto  len = match.match.size();
      if(start  > end  ) {
         
return ;
}
      if(start + len  > end  ) {
         
 len= end- start;
}
   n-> underline_until (y + offset.y, start, 256, len);
   n-> mark_until (y + offset.y, offset.x-5, 256, 5);
   n-> col (1);
   n-> add_until (y + offset.y, line.size() + offset.x + 1, "◉ Invalid token found \"" + to_string(match.match) + "\" expected \"" + to_string(validation_value) + "\"", end, true);
   n-> col (1,false);
}
class Highlighter {
 private:
   Syntax _syntax;
 public:
   Highlighter () {
      
return ;
   }
 public:
   Highlighter (string filename) {
         auto  split = String(filename).split('.');
         auto  type = split.at(split.size()-1);
      _syntax= Syntax (type);
   }
 public:
   Syntax syntax() {
      
return  _syntax;
   }
 public:
   vector<string> wordlist() {
      
return  _syntax.wordlist ();
   }
 public:
   void error_check(IContainer* container, Ncurses* n, string path, List<string> text, Vector internal_offset) {
      
 error_checker (&_syntax, container, n, path, text, internal_offset);
   }
 public:
   void highlight(IContainer* container, Ncurses* n) {
      
 highlight (container, n, false, 0);
   }
 public:
   void highlight(IContainer* container, Ncurses* n, bool is_label, int x_offset) {
         if(! _syntax.is_complete ()    ) {
            
return ;
}
         auto  content = container->GetContent();
         if(is_label    ) {
            content.clear ();
            content.add (container->Label());
}
         int  y = 0;
         auto  boxes = _syntax.boxing();
         auto  custom = _syntax.custom();
         auto  offset = container->Offset();
         auto  size = container->Size();
      offset.x+= x_offset;
         auto  end = size.x+offset.x;
         for(int line_iterator = 0; line_iterator < content.size(); line_iterator++) {
auto line = content.at(line_iterator);               if(y  >= size.y  ) {
                  
 break;
}
               if(_syntax.name ()  == "halppp"  &&String (line) .strip ()  == ";"  ) {
                     auto  found = line.find(";");
                     for(int i = 0; i < size.y; i++) {
                           if(y - (i+1)  < 0  ) {
                              
 break;
}
                           auto  above = content.at(y-(i+1));
                           if(found  >= above.size ()  ||above.at (found)  == ' '  ) {
                              attron (A_DIM);
                              n-> add (y + offset.y - (i + 1), found + offset.x, '.');
                              attroff (A_DIM);
}
                           else {
                              
 break;
}
}
}
               for(int part_iterator = 0; part_iterator < custom.size(); part_iterator++) {
auto part = custom.at(part_iterator);                     auto  matches = re(line, part.expr, part.capture);
                     for(int match_iterator = 0; match_iterator < matches.size(); match_iterator++) {
auto match = matches.at(match_iterator);                           auto  start = match.position+offset.x;
                           auto  len = match.match.size();
                           if(start  > end  ) {
                              
 continue;
}
                           if(start + len  > end  ) {
                              len= end- start;
}
                        n-> mark_until (
                        y + offset.y,
                        start,
                        part.color, 
                        len,
                        part.bold,
                        part.dim);
}
}
               for(int box_iterator = 0; box_iterator < boxes.size(); box_iterator++) {
auto box = boxes.at(box_iterator);                  highlight_pairs (n, line, box.start,
                    box.end,
                    y + offset.y,
                    offset.x, box.colors, end);
}
            y++;
}
   }
 public:
   void highlight_pairs(Ncurses* n, string line, string match, string end, int y, int x, vector<short> colors, int max_x) {
      h_pairs_imp (n, line, match, end, Vector(x,y), 0, 0, colors, max_x);
   }
 public:
   Option<int> h_pairs_imp(Ncurses* n, string line, string match, string end, Vector xy, int depth, int start, vector<short> colors, int max_x) {
         if(colors.size ()  <= 0  ) {
            
return  None<int> ();
}
         if(start  >= line.size ()  ) {
            
return  None<int> ();
}
         auto  first = line.find(match, start);
         if(first  == - 1  ) {
            
return  None<int> ();
}
         if(first + 1  >= line.size ()  ) {
            
return  None<int> ();
}
         if(xy.x + first  < max_x  ) {
            n-> mark (xy.y, xy.x + first, colors[depth % colors.size()]);
}
         auto  next = line.find(match, first + 1);
         auto  next_end = line.find(end, first + 1);
         if(next_end  == - 1  ) {
            
return  None<int> ();
}
         else if(next  > next_end  ) {
               if(xy.x + next_end  < max_x  ) {
                  n-> mark (xy.y, xy.x + next_end, colors[depth % colors.size()]);
}
            h_pairs_imp (n, line, match, end, xy, 0, first + 1, colors, max_x);
}
         else if(next  < next_end  ) {
               auto  keep = h_pairs_imp(n, line, match, end, xy, depth + 1, first + 1, colors, max_x);
               while(true   ) {
                     
{
auto find_optional_value = keep;
if(find_optional_value.is_some()) {
auto find = find_optional_value.value_unsafe();
                           if(find  == - 1  ) {
                              
return  None<int> ();
}
                           if(find + 1  >= line.size ()  ) {
                              
return  None<int> ();
}
                        next_end= line.find (end, find + 1);
                           auto  next_start = line.find(match, find + 1);
                           if(next_end  < next_start  ) {
                                 if(xy.x + next_end  < max_x  ) {
                                    n-> mark (xy.y, xy.x + next_end, colors[depth % colors.size()]);
}
                              break;
}
                        keep= h_pairs_imp (n, line, match, end, xy, depth + 1, find + 1, colors, max_x);
                        continue;
}

}
                  break;
}
}
      return  Some ((int)next_end);
   }
};
class IContent {
 protected:
   Option<Highlighter*> _highlighter = None<Highlighter*>();
 protected:
   List<string> _text = List<string>();
 protected:
   IContainer* _origin;
 protected:
   Ncurses* n;
 public:
   void draw() {
      _origin-> SetContent (_text);
      _origin-> draw (n);
   }
 public:
   IContainer* origin() {
      
return  _origin;
   }
};
void insert_snippet(List<string>* text, Vector* pos, string snippet) {
      auto  s = String(text->at(pos->y));
   s.insert (snippet, pos->x);
   text-> set (pos->y, s.to_string());
}
void strip_front(List<string>* text, Vector* pos, int amount) {
      auto  s = String(text->at(pos->y));
   text-> set (pos->y, s.strip_front(amount));
}
void insert_newline(List<string>* text, Vector* pos) {
      auto  s = String(text->at(pos->y));
   text-> set (pos->y, s.substr(0, pos->x));
   text-> insert (pos->y + 1, s.substr(pos->x));
}
void remove_char(List<string>* text, Vector* pos) {
      auto  s = String(text->at(pos->y));
   s.remove (pos->x);
   text-> set (pos->y, s.to_string());
}
void remove_line(List<string>* text, Vector* pos) {
      if(text -> len ()  <= 1  ) {
         
return ;
}
      if(pos -> y  == text -> len () - 1  ) {
         
 text-> set (pos->y, " ");
return ;
}
   text-> remove (pos->y);
}
void insert_line(List<string>* text, int pos, string line) {
   text-> insert (pos, line);
}
void remove_word(List<string>* text, Vector* pos, bool spacebreak) {
      auto  s = String(text->at(pos->y));
      if(pos -> x  < s.len ()  &&s [ pos -> x ]  == ' '  ) {
            while(pos -> x  < s.len ()  &&s [ pos -> x ]  == ' '  ) {
               s.remove (pos->x);
}
}
      else {
         
 s.remove_word (pos->x, spacebreak);
}
   text-> set (pos->y, s.to_string());
}
void remove_until(List<string>* text, Vector* pos) {
   text-> set (pos->y, text->at(pos->y).substr(0, pos->x));
}
void to_case(List<string>* text, Vector* pos, bool upper) {
      if(text -> size ()  == 0  ) {
         
return ;
}
      if(text -> at (pos->y) .size ()  == 0  ) {
         
return ;
}
      auto  ch = text->at(pos->y).at(pos->x);
   text-> at_ptr (pos->y)-> at (pos->x)= upper ? toupper (ch): tolower (ch);
}
void commenting(List<string>* text, Vector* pos) {
      if(text -> size ()  == 0  ) {
         
return ;
}
      if(text -> at (pos->y) .size ()  == 0  ) {
         
 text-> set (pos->y, "//");
return ;
}
      auto  s = String(text->at(pos->y));
      if(s.starts_with ("//")    ) {
         text-> set (pos->y, s.replace("//", "", 1));
}
      else {
         
 text-> set (pos->y, "//" + to_string(s.to_string()) + "");
}
}
bool selection_comparer(Vector &lhs, Vector &rhs) {
      if(lhs.y  < rhs.y  ) {
         
return false;
}
      if(lhs.y  > rhs.y  ) {
         
return true;
}
   return  lhs.x> rhs.x;
}
bool selection_comparer_rev(Vector &lhs, Vector &rhs) {
      if(lhs.y  > rhs.y  ) {
         
return false;
}
      if(lhs.y  < rhs.y  ) {
         
return true;
}
   return  lhs.x> rhs.x;
}
bool selection_comparer_ptr(Vector* &lhs, Vector* &rhs) {
      if(lhs -> y  < rhs -> y  ) {
         
return false;
}
      if(lhs -> y  > rhs -> y  ) {
         
return true;
}
   return  lhs-> x> rhs-> x;
}
bool selection_comparer_rev_ptr(Vector* &lhs, Vector* &rhs) {
      if(lhs -> y  > rhs -> y  ) {
         
return false;
}
      if(lhs -> y  < rhs -> y  ) {
         
return true;
}
   return  lhs-> x> rhs-> x;
}
vector<string> lgrep() {
      auto  files = list_reg_files(".");
      auto  dirs = list_dirs(".");
      int  current = 0;
      while((current++)  < dirs.size ()  ) {
            auto  dir = dirs.at(current-1);
            if(dir  == "." || dir  == ".."     ) {
               
 continue;
}
            if(String (dir) .ends_with ("/.")    ) {
               
 continue;
}
            if(String (dir) .ends_with ("/..")    ) {
               
 continue;
}
            auto  new_files = list_reg_files(dir);
            auto  new_dirs = list_dirs(dir);
            for(int f_iterator = 0; f_iterator < new_files.size(); f_iterator++) {
auto f = new_files.at(f_iterator);               
 files.push_back ("" + to_string(dir) + "/" + to_string(f) + "");
}
            for(int d_iterator = 0; d_iterator < new_dirs.size(); d_iterator++) {
auto d = new_dirs.at(d_iterator);               
 dirs.push_back ("" + to_string(dir) + "/" + to_string(d) + "");
}
}
   return  files;
}
Option<string> Lgrep(Ncurses* n) {
      int  key = 0;
      int  pos = 0;
      auto  buf = List<string>();
      string  search = "";
      auto  files = List<string>(lgrep());
      auto  base = HorizontalLayout(Vector(COLS/6*4, LINES/2), Vector(COLS/6, LINES/4));
      auto  search_bar = IContainer(Fill::Static, Vector(0,1));
      auto  content = IContainer();
      auto  left = VerticalLayout(Fill::Flex);
      auto  spacer = IContainer(Fill::Static, Vector(2,0), "│");
      auto  left_spacer = IContainer(Fill::Static, Vector(1,0));
      auto  view = IContainer();
   base.SetColor (-2);
   spacer.SetColor (2);
   base.add (&left_spacer);
   base.add (&left);
   base.add (&spacer);
   base.add (&view);
   left.add (&search_bar);
   left.add (&content);
      int  offset = 0;
      while(true   ) {
         search_bar.SetLabel (search);
         buf.clear ();
            for(int i = 0; i < files.size(); i++) {
auto file = files.at(i);                  if(file.find (search)  == - 1  ) {
                     
 continue;
}
                  if(i  < offset  ) {
                     
 continue;
}
               buf.add (file);
}
         content.SetContent (buf);
            if(pos  >= buf.size ()  ) {
               view.SetContent (List<string>());
               base.draw (n);
}
            else {
               view.SetContent (readlines(buf.at(pos)));
                  auto  h = Highlighter(buf.at(pos));
               base.draw (n);
               h.highlight (&view, n);
}
         n-> mark_until (content.Offset().y + pos,
            content.Offset().x,
            5, content.Size().x);
         key= n-> key ();
            switch(key    ) {
               case 27:
               
return  None<string> ();
               case KEY_DOWN:
                pos++;
break ;
               case KEY_UP:
                pos--;
break ;
               case KEY_PPAGE:
                pos-= 1000;
break ;
               case KEY_NPAGE:
                pos+= 1000;
break ;
               case '\n':
                  if(pos  >= buf.size ()  ) {
                     
 break;
}
               return  buf.at (pos);
               case '\b':
               case 127:
               case KEY_BACKSPACE:
                  if(search.size ()  == 0  ) {
                     
 break;
}
               search.pop_back ();
               break;
               default:
                  if(key  == '.' || key  == '/' || key  == ' '     ) {
                     
 search+= key;
}
                  else if(isalpha (key)    ) {
                     
 search+= key;
}
               break;
}
            if(pos  > buf.size () - 1  ) {
               
 pos= buf.size ()- 1;
}
            if(pos  > content.Size () .y - 1  ) {
               pos= content.Size () .y- 1;
               offset++;
}
            if(pos  < 0  ) {
               pos= 0;
                  if(offset  > 0  ) {
                     
 offset--;
}
}
}
}
struct TextEditOrCommand {
 public:
   Option<TextEdit> textedit = None<TextEdit>();
 public:
   Option<Command> command = None<Command>();
 public:
   TextEditOrCommand (TextEdit edit) {
      
 this-> textedit= edit;
   }
 public:
   TextEditOrCommand (Command command) {
      
 this-> command= command;
   }
};
class CommandPallete {
 private:
   int pos = 0;
 private:
   string search = "";
 private:
   Dictionary<string,Command> commands = Dictionary<string,Command>();
 private:
   Dictionary<string,TextEdit> textedits = Dictionary<string,TextEdit>();
 private:
   List<string> buf = List<string>();
 private:
   IContainer pallete_found = IContainer();
 private:
   IContainer pallete_search = IContainer(Fill::Static, Vector(0, 1));
 private:
   VerticalLayout pallete_window = VerticalLayout(
        Vector(COLS/2, 10),
        Vector(COLS/4, LINES/4));
 public:
   CommandPallete () {
      add_commands ();
      add_text_edits ();
      pallete_window.SetColor (-3);
      pallete_search.SetColor (2);
      pallete_window.add (&pallete_search);
      pallete_window.add (&pallete_found);
   }
 private:
   void add_commands() {
      commands.add (" exit", Command::Exit);
      commands.add (" mode normal", Command::ModeNormal);
      commands.add (" mode insert", Command::ModeInsert);
      commands.add (" mode visual", Command::ModeVisual);
      commands.add (" mode file explorer", Command::ModeFileEx);
      commands.add (" mode file explorer", Command::ModeCmdHan);
      commands.add (" editor write", Command::WriteEditor);
      commands.add (" editor close", Command::CloseEditor);
      commands.add (" editor close forced", Command::CloseEditorForced);
      commands.add (" editor write and close", Command::WriteCloseEditor);
      commands.add (" editor split horizontal", Command::SplitHorizontal);
      commands.add (" editor split vertical", Command::SplitVertical);
      commands.add (" editor move left", Command::EditorLeft);
      commands.add (" editor move right", Command::EditorRight);
      commands.add (" editor move up", Command::EditorUp);
      commands.add (" editor move down", Command::EditorDown);
      commands.add (" templates", Command::EditorTemplates);
      commands.add (" search", Command::EditorSearch);
      commands.add (" replace", Command::EditorReplace);
   }
 private:
   void add_text_edits() {
      textedits.add (" tab", TextEdit::Tab);
      textedits.add (" untab", TextEdit::Untab);
      textedits.add (" insert new line", TextEdit::InsertNl);
      textedits.add (" remove char behind cursor", TextEdit::RemoveChar);
      textedits.add (" remove char under cursor", TextEdit::DeleteChar);
      textedits.add (" remove word", TextEdit::DeleteWord);
      textedits.add (" remove word without removing extra space", TextEdit::DeleteWordExlusive);
      textedits.add (" remove line", TextEdit::DeleteLine);
      textedits.add (" remove from cursor to end", TextEdit::DeleteFrom);
      textedits.add (" paste line/lines from buffer below", TextEdit::PasteLine);
      textedits.add (" paste line/lines from buffer on to current lien", TextEdit::PasteWord);
      textedits.add (" lower case", TextEdit::Lower);
      textedits.add (" upper case", TextEdit::Upper);
      textedits.add (" toggle comment", TextEdit::CommentToggle);
   }
 public:
   TextEditOrCommand show(Ncurses* n) {
         string  match = "";
         int  offset = 0;
      search="";
      pos= 0;
         while(true   ) {
               int  offset_used = 0;
            pallete_search.SetLabel (" " + search);
            buf.clear ();
               for(int i = 0; i < commands.keys().size(); i++) {
auto command = commands.keys().at(i);                     if(command.find (search)  == - 1  ) {
                        
 continue;
}
                     if(i  < offset  ) {
                         offset_used++;
continue ;
}
                  buf.add (command);
}
               for(int i = 0; i < textedits.keys().size(); i++) {
auto edit = textedits.keys().at(i);                     if(edit.find (search)  == - 1  ) {
                        
 continue;
}
                     if(i  < offset - offset_used  ) {
                        
 continue;
}
                  buf.add (edit);
}
            pallete_found.SetContent (buf);
            pallete_window.draw (n);
            n-> mark_until (LINES/4 + 1 + pos, COLS/4, 4, COLS/2);
               auto  key = n->key();
               switch(key    ) {
                  case KEY_DOWN:
                   pos++;
break ;
                  case KEY_UP:
                   pos--;
break ;
                  case KEY_PPAGE:
                   pos-= 1000;
break ;
                  case KEY_NPAGE:
                   pos+= 1000;
break ;
                  case 27:
                  
return  Command:: ModeNormal;
                  case '\n':
                     if(pos  >= buf.size ()  ) {
                        
 break;
}
                  match= buf.at (pos);
                     
{
auto cmd_optional_value = commands.try_get_value(match);
if(cmd_optional_value.is_some()) {
auto cmd = cmd_optional_value.value_unsafe();
                        
return  TextEditOrCommand (cmd);
}

}
                     
{
auto edit_optional_value = textedits.try_get_value(match);
if(edit_optional_value.is_some()) {
auto edit = edit_optional_value.value_unsafe();
                        
return  TextEditOrCommand (edit);
}

}
                  break;
                  case '\b':
                  case 127:
                  case KEY_BACKSPACE:
                     if(search.size ()  == 0  ) {
                        
 break;
}
                  search.pop_back ();
                  break;
                  default:
                     if(key  == ',' || key  == ' ' || key  == '/' || key  == ':' || key  == '.' || key  == '_' || key  == '-' || key  == '<' || key  == '>'     ) {
                        
 search+= key;
}
                     else if(isalpha (key)    ) {
                        
 search+= key;
}
                  break;
}
               if(pos  > buf.size () - 1  ) {
                  
 pos= buf.size ()- 1;
}
               if(pos  > 8  ) {
                  pos= 8;
                  offset++;
}
               if(pos  < 0  ) {
                  pos= 0;
                     if(offset  > 0  ) {
                        
 offset--;
}
}
}
      return  TextEditOrCommand (Command::Nop);
   }
};
class Editor: public IContent {
 private:
   string _path = "";
 private:
   bool _num_diff = false;
 private:
   bool _check_errors = false;
 private:
   String _modifier = String("");
 private:
   List<Vector> _selections = List<Vector>();
 private:
   Vector _selector = Vector(0,0);
 private:
   Vector _offset = Vector(0,0);
 private:
   Vector _global_size = Vector(COLS,LINES);
 private:
   IContainer* _header = new IContainer(Fill::Static, Vector(0,1));
 private:
   IContainer* _lines = new IContainer(Fill::Static, Vector(5,0));
 private:
   IContainer* _content = new IContainer();
 private:
   HorizontalLayout* _base = new HorizontalLayout();
 private:
   vector<string>* _shared_buffer;
 private:
   IContainer* _status_line;
 private:
   CommandPallete* _command_pallete;
 private:
   Mode _current_mode = Mode::Normal;
 public:
   Editor (Ncurses* n, string path, vector<string>* shared_buffer, IContainer* status_line, CommandPallete* command_pallete) {
      _origin=new  VerticalLayout ();
      _highlighter= Some (new Highlighter(path));
      _status_line= status_line;
      _command_pallete= command_pallete;
      _lines-> SetColor (3);
      _header-> SetColor (5);
      _content-> SetColor (0);
      _base-> add (_lines);
      _base-> add (_content);
      _origin-> add (_header);
      _origin-> add (_base);
      _shared_buffer= shared_buffer;
      open (path);
      this-> n= n;
   }
 private:
   string json_path() {
      
return "" + to_string(_path) + ".json";
   }
 private:
   void content_change(TextEdit edit) {
         auto  j = load_json(json_path());
      Json* entry=new  Json ();
      entry-> try_add ("text", _text.at(_selector.y));
      entry-> try_add ("type", (int)edit);
      entry-> try_add ("posy", _selector.y);
      entry-> try_add ("posx", _selector.x);
      j.try_add ("undo", JsonType::Array);
      j.try_add ("redo", JsonType::Array);
         
{
auto undo_optional_value = j["undo"];
if(undo_optional_value.is_some()) {
auto undo = undo_optional_value.value_unsafe();
            undo-> add (entry);
            sort_selections ();
               for(int selection_iterator = 0; selection_iterator < _selections.size(); selection_iterator++) {
auto selection = _selections.at(selection_iterator);                  Json* sel_entry=new  Json ();
                  sel_entry-> try_add ("text", _text.at(selection.y));
                  sel_entry-> try_add ("type", (int)edit);
                  sel_entry-> try_add ("posy", selection.y);
                  sel_entry-> try_add ("posx", selection.x);
                  undo-> add (sel_entry);
}
}

}
      write_json (json_path(), j);
      j.destruct ();
   }
 private:
   void redo() {
      
 undo (false);
   }
 private:
   void undo(bool is_undo = true) {
         auto  getter = is_undo?"undo":"redo";
         auto  setter = is_undo?"redo":"undo";
         auto  j = load_json(json_path());
         auto  entry = new Json();
         
{
auto obj_optional_value = j[getter];
if(obj_optional_value.is_some()) {
auto obj = obj_optional_value.value_unsafe();
               auto  last = obj->size()-1;
               
{
auto u_optional_value = obj->try_get(last);
if(u_optional_value.is_some()) {
auto u = u_optional_value.value_unsafe();
                     auto  text = u->try_get_value_of("text", (string)"");
                     auto  type = u->try_get_value_of("type", 0.0);
                     auto  posy = u->try_get_value_of("posy", 0.0);
                     auto  posx = u->try_get_value_of("posx", 0.0);
                     
{
auto store_optional_value = j[setter];
if(store_optional_value.is_some()) {
auto store = store_optional_value.value_unsafe();
                        entry-> add (new Json("text", text));
                        entry-> add (new Json("type", type));
                        entry-> add (new Json("posy", posy));
                        entry-> add (new Json("posx", posx));
                        store-> add (entry);
                        undo_handler (text, (TextEdit)type, Vector(posx, posy), is_undo);
}

}
                  obj-> pop ();
                  write_json (json_path(), j);
                  entry-> destruct ();
                  delete (entry);
}

}
}

}
   }
 private:
   void undo_handler(string text, TextEdit type, Vector pos, bool is_undo) {
      _selector= pos;
         switch(type    ) {
            case TextEdit::PasteLine:
               if(! is_undo    ) {
                   _text.insert (pos.y+1, text);
break ;
}
            _text.remove (pos.y+1);
            break;
            case TextEdit::DeleteLine:
               if(is_undo    ) {
                   _text.insert (pos.y, text);
break ;
}
            _text.remove (pos.y);
            break;
            case TextEdit::InsertNl:
               if(is_undo    ) {
                  _text.set (pos.y, text);
                  _text.remove (pos.y + 1);
}
               else {
                  
 insert_nl (&_selector, 0);
}
            break;
            default:
             _text.set (pos.y, text);
break ;
}
   }
 public:
   string path() {
      
return  _path;
   }
 public:
   Vector Offset() {
      
return  _origin-> Offset ();
   }
 public:
   bool is_active() {
      
return  _origin-> Active ();
   }
 public:
   void set_active(bool active) {
      
 _origin-> SetActive (active);
   }
 public:
   void set_syntax(string syntax) {
         
{
auto h_optional_value = _highlighter;
if(h_optional_value.is_some()) {
auto h = h_optional_value.value_unsafe();
            
 delete (h);
}

}
      _highlighter= Some (new Highlighter("temp." + to_string(syntax) + ""));
   }
 public:
   void open(string path) {
      remove (json_path());
         if(_path  != path  ) {
            _offset= Vector (0,0);
            _selector= Vector (0,0);
            _selections.clear ();
            _path= path;
               
{
auto h_optional_value = _highlighter;
if(h_optional_value.is_some()) {
auto h = h_optional_value.value_unsafe();
                  
 delete (h);
}

}
            _highlighter= Some (new Highlighter(path));
            _header-> SetLabel ("| " + to_string(_path) + "");
            remove (json_path());
}
      _text= readlines (_path);
      _content-> SetContent (_text);
   }
 public:
   Editor* close() {
      set_active (false);
      remove (json_path());
      delete (_header);
      delete (_lines);
      delete (_content);
      delete (_base);
         
{
auto h_optional_value = _highlighter;
if(h_optional_value.is_some()) {
auto h = h_optional_value.value_unsafe();
            
 delete (h);
}

}
      return  this;
   }
 public:
   void move_to(int pos) {
         auto  diff = pos-1-_selector.y;
         auto  dir = diff>0?Dir::Down:Dir::Up;
         if(dir  == Dir :: Up  ) {
            
 diff*=- 1;
}
      move (dir, diff, false);
   }
 public:
   Vector get_internal_offset() {
         auto  size = _content->Size();
         auto  x = size.x-1;
         auto  y = size.y-1;
         if(_selector.x  < 0  ) {
            
 _selector.x= 0;
}
         if(_selector.y  < 0  ) {
            
 _selector.y= 0;
}
         if(_selector.y  > y + _offset.y  ) {
            _offset.y= _selector.y- y;
}
         if(_selector.x  > x + _offset.x  ) {
            _offset.x= _selector.x- x;
}
         if(_selector.x  < _offset.x  ) {
            _offset.x= _selector.x;
}
         if(_selector.y  < _offset.y  ) {
            _offset.y= _selector.y;
}
      return  _offset;
   }
 public:
   void draw(short color = 5) {
         if(! is_active ()    ) {
            
return ;
}
         auto  is_current = color==6;
         auto  internal_offset = get_internal_offset();
      _header-> SetColor (color);
      _header-> SetLabel ("| " + to_string(_path) + "");
      _header-> draw (n);
      vector<string> progress= {"▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"};
         auto  percent = _text.size()-1==0?1:(double)_selector.y/(double)(_text.size() - 1);
      int current= 7* percent;
         auto  cp = progress[min(current,7)];
      _status_line-> SetLabel (" ◁ " + to_string(_path) + " $ [" + to_string(_selector.x) + "," + to_string(_selector.y + 1) + "] " + to_string(cp) + "" + to_string(cp) + "");
      _status_line-> draw (n);
      List<string> vec= List<string> ();
         for(int i = 0; i < _text.size(); i++) {
               auto  num = i+1+internal_offset.y;
               if(_num_diff    &&num  != _selector.y + 1  ) {
                  num= _selector.y- num+ 1;
                     if(num  < 0  ) {
                        
 num*=- 1;
}
}
               if(num  > _text.size ()  ) {
                  
 break;
}
            vec.add (to_string(num));
}
      _lines-> SetContent (vec);
      _lines-> draw (n);
      List<string> buf= List<string> ();
         for(int i = 0; i < _text.size(); i++) {
               if(i  < internal_offset.y  ) {
                  
 continue;
}
               auto  text = _text.at(i);
               if(internal_offset.x  >= text.size ()  ) {
                   buf.add ("");
continue ;
}
            text= text.substr (internal_offset.x);
            buf.add (text);
}
      _content-> SetContent (buf);
      _content-> draw (n);
         
{
auto highlighter_optional_value = _highlighter;
if(highlighter_optional_value.is_some()) {
auto highlighter = highlighter_optional_value.value_unsafe();
            highlighter-> highlight (_content, n);
            highlighter-> highlight (_status_line, n, true, -2);
               if(_check_errors    ) {
                  
 highlighter-> error_check (_content, n, _path, _text, internal_offset);
}
}

}
      mark_selections (is_current, internal_offset);
   }
 public:
   void mark_selections(bool is_current, Vector internal_offset) {
         if(is_current    ) {
               auto  offset = _content->Offset();
               auto  y = offset.y+_selector.y-internal_offset.y;
               auto  x = offset.x+_selector.x-internal_offset.x;
               for(int s_iterator = 0; s_iterator < _selections.size(); s_iterator++) {
auto s = _selections.at(s_iterator);                  n-> mark (
                    offset.y + s.y - internal_offset.y,
                    offset.x + s.x - internal_offset.x, 5);
}
            n-> mark_until (y, offset.x - 5, 2, 5, true);
               if(_current_mode  == Mode :: Insert  ) {
                  
 n-> move_curs (y, x);
}
               else {
                  
 n-> mark (y, x, 4);
}
}
   }
 public:
   string to_complete_str() {
         string  content = "";
         for(int i = 0; i < _text.len(); i++) {
            content+= _text.at (i);
               if(i  < _text.len () - 1  ) {
                  
 content+="\n";
}
}
      return  String (content) .strip_end ();
   }
 public:
   bool has_changes() {
         if(_path  == ""  ) {
            
return false;
}
         if(_text.len ()  == 0  ) {
            
return false;
}
         
{
auto content_optional_value = read(_path);
if(content_optional_value.is_some()) {
auto content = content_optional_value.value_unsafe();
            return  String (content) .strip_end ()!= to_complete_str ();
}

}
      return true;
   }
 public:
   void write_content() {
      
 write (to_complete_str(), _path);
   }
 public:
   void sort_selections() {
      
 sort (_selections.begin(), _selections.end(), &selection_comparer);
   }
 public:
   void sort_selections_rev() {
      
 sort (_selections.begin(), _selections.end(), &selection_comparer_rev);
   }
 public:
   void add_selector(bool is_word = false) {
      _selections.add (_selector);
         if(! is_word    ) {
            
 try_move (Vector(0,1), &_selector);
}
         else {
            
 find ();
}
   }
 public:
   void select_line() {
         auto  line = _text.at(_selector.y);
         if(line.size ()  == 0  ) {
            
return ;
}
         if(_selector.x  == line.size () - 1  &&_selector.y  < _text.size () - 1  ) {
            _selector.y++;
            line= _text.at (_selector.y);
               if(line.size ()  == 0  ) {
                  
return ;
}
}
         for(int i = 0; i < _selections.size(); i++) {
               if(_selections.at (_selections.size() - 1 - i) .y  == _selector.y  ) {
                  _selections.remove (_selections.size() - 1 - i);
}
}
         for(int i = 0; i < line.size(); i++) {
            _selections.add (Vector(i, _selector.y));
}
      _selector.x= line.size ()- 1;
   }
 public:
   void select_word() {
      _selections.clear ();
         auto  x = _selector.x;
      move_word_impl (Dir::Right, &_selector, true);
         for(int i = 0; i < _selector.x-x; i++) {
            _selections.add (Vector(_selector.x - i, _selector.y));
}
      _selector.x= x;
   }
 public:
   void text_editing(TextEdit te) {
      
 text_editing (te, None<string>(), false);
   }
 public:
   void text_editing(TextEdit te, bool is_multi) {
      
 text_editing (te, None<string>(), is_multi);
   }
 public:
   void text_editing(TextEdit te, string text) {
      
 text_editing (te, Some(text), false);
   }
 public:
   void text_editing(TextEdit te, Option<string> text_opt, bool is_multi) {
         if(_text.size ()  == 0  ) {
            
 _text.add ("");
}
      content_change (te);
      List< Vector*> selections= List< Vector*> ({&_selector});
         string  text = "";
         
{
auto t_optional_value = text_opt;
if(t_optional_value.is_some()) {
auto t = t_optional_value.value_unsafe();
            
 text= t;
}

}
         for(int i = 0; i < _selections.size(); i++) {
            selections.add (_selections.at_ptr(i));
}
      sort (selections.begin(), selections.end(), &selection_comparer_ptr);
         int  index = 0;
         switch(te    ) {
            case TextEdit::Tab:
               for(int s_iterator = 0; s_iterator < selections.size(); s_iterator++) {
auto s = selections.at(s_iterator);                  
 tab (s);
}
            break;
            case TextEdit::Untab:
               for(int s_iterator = 0; s_iterator < selections.size(); s_iterator++) {
auto s = selections.at(s_iterator);                  
 untab (s);
}
            break;
            case TextEdit::Insert:
               for(int s_iterator = 0; s_iterator < selections.size(); s_iterator++) {
auto s = selections.at(s_iterator);                  
 insert_text (text, s);
}
            break;
            case TextEdit::InsertNl:
            sort (selections.begin(), selections.end(), &selection_comparer_rev_ptr);
               for(int s_iterator = 0; s_iterator < selections.size(); s_iterator++) {
auto s = selections.at(s_iterator);                  
 insert_nl (s, index++);
}
            break;
            case TextEdit::RemoveChar:
               for(int s_iterator = 0; s_iterator < selections.size(); s_iterator++) {
auto s = selections.at(s_iterator);                  
 remove_ch (s, true);
}
            break;
            case TextEdit::DeleteChar:
               for(int s_iterator = 0; s_iterator < selections.size(); s_iterator++) {
auto s = selections.at(s_iterator);                  
 remove_ch (s);
}
            break;
            case TextEdit::DeleteLine:
               for(int s_iterator = 0; s_iterator < selections.size(); s_iterator++) {
auto s = selections.at(s_iterator);                  
 delete_line (s, is_multi);
}
            move (Dir::Right, 0);
            break;
            case TextEdit::DeleteFrom:
               for(int s_iterator = 0; s_iterator < selections.size(); s_iterator++) {
auto s = selections.at(s_iterator);                  
 delete_from (s);
}
            break;
            case TextEdit::DeleteWord:
               for(int s_iterator = 0; s_iterator < selections.size(); s_iterator++) {
auto s = selections.at(s_iterator);                  
 delete_word (s, true);
}
            break;
            case TextEdit::DeleteWordExlusive:
               for(int s_iterator = 0; s_iterator < selections.size(); s_iterator++) {
auto s = selections.at(s_iterator);                  
 delete_word (s);
}
            break;
            case TextEdit::PasteLine:
            sort (selections.begin(), selections.end(), &selection_comparer_rev_ptr);
               for(int s_iterator = 0; s_iterator < selections.size(); s_iterator++) {
auto s = selections.at(s_iterator);                  
 paste_line (s);
}
            break;
            case TextEdit::PasteWord:
               for(int s_iterator = 0; s_iterator < selections.size(); s_iterator++) {
auto s = selections.at(s_iterator);                  
 paste_word (s);
}
            break;
            case TextEdit::Upper:
            case TextEdit::Lower:
               for(int s_iterator = 0; s_iterator < selections.size(); s_iterator++) {
auto s = selections.at(s_iterator);                  
 change_case (s, te);
}
            break;
            case TextEdit::CommentToggle:
               for(int s_iterator = 0; s_iterator < selections.size(); s_iterator++) {
auto s = selections.at(s_iterator);                  
 comment_toggle (s);
}
            break;
            default:
            
 break;
}
   }
 public:
   string find(bool is_reverse = false, bool should_move = true) {
         if(_text.size ()  == 0  ) {
            
return "";
}
         auto  s = _text.at(_selector.y);
         if(s.size ()  == 0  ) {
            
return "";
}
         auto  matches = re(s, R"(([A-z_]*))", 1);
         string  matching = "";
         for(int match_iterator = 0; match_iterator < matches.size(); match_iterator++) {
auto match = matches.at(match_iterator);               if(match.position  > _selector.x  ) {
                  
 continue;
}
               if(match.match.size () + match.position  < _selector.x  ) {
                  
 continue;
}
            matching= match.match;
            break;
}
         if(should_move    ) {
            
 find (matching, is_reverse);
}
      return  matching;
   }
 public:
   bool find(string matching) {
      
return  find (matching, "", false, false);
   }
 public:
   bool find(string matching, string replace) {
      
return  find (matching, replace, false, true);
   }
 public:
   bool find(string matching, bool is_reverse) {
      
return  find (matching, "", is_reverse, false);
   }
 public:
   bool find(string matching, string replace, bool is_reverse, bool is_replace) {
         if(_text.size ()  == 0  ) {
            
return false;
}
         if(matching  == ""  ) {
            
return false;
}
         int  y = 0;
         auto  reg = regex("(^|\\W)(" + to_string(matching) + ")($|\\W)");
         auto  s = _text.at(_selector.y);
         auto  matches = re(s, reg, 2);
         for(int match_iterator = 0; match_iterator < matches.size(); match_iterator++) {
auto match = matches.at(match_iterator);               if(match.position  <= _selector.x  &&! is_reverse    ) {
                  
 continue;
}
               else if(match.position  == _selector.x  ) {
                  
 continue;
}
            _selector.x= match.position;
               if(is_replace    ) {
                     for(int i = 0; i < matching.size(); i++) {
                        remove_ch (&_selector);
}
                  insert_text (replace, &_selector, false);
                  return true;
}
            return false;
}
         if(! is_reverse    ) {
               for(int line_iterator = 0; line_iterator < _text.size(); line_iterator++) {
auto line = _text.at(line_iterator);                     if(y  <= _selector.y  ) {
                         y++;
continue ;
}
                  matches= re (line, reg, 2);
                     if(matches.size ()  > 0  ) {
                        _selector.x= matches[ 0] .position;
                        _selector.y= y;
                           if(is_replace    ) {
                                 for(int i = 0; i < matching.size(); i++) {
                                    remove_ch (&_selector);
}
                              insert_text (replace, &_selector, false);
                              return true;
}
                        return false;
}
                  y++;
}
}
         else {
            y= _text.size ()- 1;
               for(int i = 0; i < _text.size(); i++) {
                     if(y  >= _selector.y  ) {
                         y--;
continue ;
}
                  matches= re (_text.at(y), reg, 2);
                     if(matches.size ()  > 0  ) {
                        _selector.x= matches[ matches.size ()- 1] .position;
                        _selector.y= y;
                           if(is_replace    ) {
                                 for(int i = 0; i < matching.size(); i++) {
                                    remove_ch (&_selector);
}
                              insert_text (replace, &_selector, false);
                              return true;
}
                        return false;
}
                  y--;
}
}
      return false;
   }
 public:
   void tab(Vector* pos) {
         auto  v = new Vector(0, pos->y);
      insert_snippet (&_text, v, "    ");
      delete (v);
      try_move (Vector(4,0), pos);
   }
 public:
   void untab(Vector* pos) {
      strip_front (&_text, pos, 4);
         if(pos -> x  < 4  ) {
            
 try_move (Vector(-pos->x, 0), pos);
}
         else {
            
 try_move (Vector(-4,0), pos);
}
   }
 public:
   void insert_nl(Vector* pos, int amount) {
      pos-> y+= amount;
      insert_newline (&_text, pos);
      pos-> y++;
      pos-> x= 0;
   }
 public:
   void insert_text(string text, Vector* pos, bool suggestions = true) {
         if(_text.size ()  == 0  ) {
            
 _text.add (" ");
}
         switch(text [ 0 ]    ) {
            case '(':
             text+=')';
break ;
            case '<':
             text+='>';
break ;
            case '{':
             text+='}';
break ;
            case '[':
             text+=']';
break ;
}
      insert_snippet (&_text, pos, text);
      try_move (Vector(1, 0), pos);
         if(! suggestions    ||text  == " "  ||_selections.size ()  > 0  ) {
            
return ;
}
         auto  suggestion = find(false, false);
         if(suggestion.size ()  == 0  ) {
            
return ;
}
         for(int ch_iterator = 0; ch_iterator < suggestion.size(); ch_iterator++) {
auto ch = suggestion.at(ch_iterator);               if(! isalpha (ch)    &&ch  != '_'  ) {
                  
return ;
}
}
         auto  reg = regex("(^|\\W)(" + to_string(suggestion) + "[\\w_]*)");
         auto  offset = _content->Offset();
         auto  internal_offset = get_internal_offset();
         auto  y = _selector.y-internal_offset.y;
         auto  x = offset.x+_selector.x-internal_offset.x;
         int  width = 0;
      vector<string> unique_matches= {};
         
{
auto highlighter_optional_value = _highlighter;
if(highlighter_optional_value.is_some()) {
auto highlighter = highlighter_optional_value.value_unsafe();
               auto  wordlist = highlighter->wordlist();
               for(int word_iterator = 0; word_iterator < wordlist.size(); word_iterator++) {
auto word = wordlist.at(word_iterator);                     auto  stringified = String(word);
                     if(! stringified.starts_with (suggestion)    ) {
                        
 continue;
}
                  unique_matches.push_back (stringified.to_string());
                     if(stringified.len ()  > width  ) {
                        
 width= stringified.len ();
}
}
}

}
         for(int line_iterator = 0; line_iterator < _text.size(); line_iterator++) {
auto line = _text.at(line_iterator);               auto  matches = re(line, reg, 2);
               for(int match_iterator = 0; match_iterator < matches.size(); match_iterator++) {
auto match = matches.at(match_iterator);                     if(match.match  == suggestion  ) {
                        
 continue;
}
                     bool  found_already = false;
                     for(int um_iterator = 0; um_iterator < unique_matches.size(); um_iterator++) {
auto um = unique_matches.at(um_iterator);                           if(um  == match.match  ) {
                              
 found_already=true;
}
}
                     if(found_already    ) {
                        
 continue;
}
                  unique_matches.push_back (match.match);
                     if(match.match.size ()  > width  ) {
                        
 width= match.match.size ();
}
}
}
         if(unique_matches.size ()  == 0  ) {
            
return ;
}
      draw ();
         int  selected = 0;
         bool  reverse = false;
         auto  space_below = _content->Size().y-1-y;
         if(space_below  < 5  ) {
            space_below= _content-> Size () .y/ 2;
            reverse=true;
}
         auto  max_size = min(unique_matches.size(), space_below);
         if(x + width  >= _content -> Size () .x + offset.x  ) {
            width= _content-> Size () .x+ offset.x- x- 1;
}
         while(true   ) {
               int  matching_index = 0;
               auto  positioned_y = reverse?y-max_size:y;
               for(int um_iterator = 0; um_iterator < unique_matches.size(); um_iterator++) {
auto um = unique_matches.at(um_iterator);                     if(matching_index + 1 + positioned_y  >= _content -> Size () .y  ) {
                        
 break;
}
                     auto  y = offset.y+positioned_y+matching_index-reverse+1;
                  n-> add (y, x - 1, "│", 1);
                  n-> add (y, x + width, "│", 1);
                  n-> col (selected == matching_index ? 4 : 0);
                  n-> add_until (
                    y, x, um,
                    _content->Size().x + offset.x - 1,
                    false);
                     for(int i = 0; i < width-um.size(); i++) {
                           if(x + um.size () + i  >= _content -> Size () .x + offset.x  ) {
                              
 break;
}
                        n-> add (y, x + um.size() + i, " ");
}
                  n-> col (selected == matching_index ? 4 : 0, false);
                  matching_index++;
}
               string  box_str = "";
               for(int i = 0; i < width; i++) {
                  
 box_str+="─";
}
            n-> add_col (offset.y + positioned_y - reverse, x - 1, "┌" + to_string(box_str) + "┐", 1);
            n-> add_col (offset.y + positioned_y - reverse + matching_index + 1, x - 1, "└" + to_string(box_str) + "┘", 1);
               auto  key = n->key();
               switch(key    ) {
                  case KEY_BTAB:
                  case 27:
                  
return ;
                  case '\t':
                  case '\n':
                  insert_text (String(unique_matches[selected]).replace(suggestion, "", 1), &_selector, false);
                  move (Dir::Right, unique_matches[selected].size() - suggestion.size() - 1, true);
                  return ;
                  case KEY_UP:
                   selected= max (selected - 1, 0);
break ;
                  case KEY_DOWN:
                   selected= min (selected + 1, max_size - 1);
break ;
                  case KEY_LEFT:
                  
 move (Dir::Left);
return ;
                  case KEY_RIGHT:
                  
 move (Dir::Right);
return ;
                  case KEY_HOME:
                  
 move (Dir::Left, 100000, false);
return ;
                  case KEY_END:
                  
 move (Dir::Right, 100000, false);
return ;
                  case KEY_PPAGE:
                   selected= 0;
break ;
                  case KEY_NPAGE:
                   selected= max_size- 1;
break ;
                  case '\b':
                  case 127:
                  case KEY_BACKSPACE:
                  
 text_editing (TextEdit::RemoveChar);
return ;
                  default:
                  
 text_editing (TextEdit::Insert, string(1, key));
return ;
}
}
   }
 public:
   void remove_ch(Vector* pos, bool should_move = false) {
         if(should_move    ) {
               if(pos -> x  == 0  ) {
                     if(pos -> y  == 0  ||_selections.len ()  != 0  ) {
                        
return ;
}
                  text_editing (TextEdit::DeleteLine);
                  move (Dir::Up, 1);
                  move (Dir::Right, 100000, false);
                  text_editing (TextEdit::PasteWord);
                  return ;
}
            try_move (Vector(-1, 0), pos);
}
         if(_current_mode  == Mode :: Visual  &&pos -> x  == 0  &&_text.at (pos->y) .size ()  == 0  ) {
            text_editing (TextEdit::DeleteLine);
}
         else {
            
 remove_char (&_text, pos);
}
   }
 public:
   void delete_line(Vector* pos, bool is_multi = false) {
         if(! is_multi    ) {
            
 _shared_buffer-> clear ();
}
      _shared_buffer-> push_back (_text.at(pos->y));
      remove_line (&_text, pos);
   }
 public:
   void yank_line(Vector* pos, bool is_multi = false) {
         if(_text.len ()  == 0  ) {
            
return ;
}
         if(! is_multi    ) {
            
 _shared_buffer-> clear ();
}
      _shared_buffer-> push_back (_text.at(pos->y));
   }
 public:
   void paste_line(Vector* pos) {
         if(_shared_buffer -> size ()  == 0  ) {
               auto  clipboard = system_output("xclip -o -selection clipboard 2> /dev/null");
               for(int i = 0; i < clipboard.size(); i++) {
                     if(i  != 0  ) {
                        
 content_change (TextEdit::PasteLine);
}
                  insert_line (&_text, ++pos->y, String(clipboard.at(i)).strip_end());
}
            return ;
}
         for(int i = 0; i < _shared_buffer->size(); i++) {
               if(i  != 0  ) {
                  
 content_change (TextEdit::PasteLine);
}
            insert_line (&_text, ++pos->y, _shared_buffer->at(i));
}
   }
 public:
   void paste_word(Vector* pos) {
         if(_shared_buffer -> size ()  == 0  ) {
               auto  clipboard = system_output("xclip -o -selection clipboard 2> /dev/null");
               if(clipboard.size ()  == 0  ) {
                  
return ;
}
               if(pos -> x  != 0  ) {
                  
 pos-> x++;
}
            insert_snippet (&_text, pos, String(clipboard.at(0)).strip_end());
            return ;
}
         if(pos -> x  != 0  ) {
            
 pos-> x++;
}
      insert_snippet (&_text, pos, _shared_buffer->at(0));
   }
 public:
   void shift_line(Dir dir) {
         if(_selections.size ()  > 0  ) {
            
return ;
}
      text_editing (TextEdit::DeleteLine);
         if(dir  == Dir :: Up  ) {
            
 move (Dir::Up, 2);
}
      text_editing (TextEdit::PasteLine);
   }
 public:
   void delete_word(Vector* pos, bool spacebreak = false) {
      
 remove_word (&_text, pos, spacebreak);
   }
 public:
   void delete_from(Vector* pos) {
         auto  s = _text.at(pos->y);
      _shared_buffer-> clear ();
      _shared_buffer-> push_back (_text.at(pos->y).substr(pos->x));
      remove_until (&_text, pos);
   }
 public:
   void yank_from() {
         auto  s = _text.at(_selector.y);
      _shared_buffer-> clear ();
      _shared_buffer-> push_back (_text.at(_selector.y).substr(_selector.x));
   }
 public:
   void change_case(Vector* pos, TextEdit edit) {
         switch(edit    ) {
            case TextEdit::Upper:
             to_case (&_text, pos, true);
break ;
            case TextEdit::Lower:
             to_case (&_text, pos, false);
break ;
}
   }
 public:
   void comment_toggle(Vector* pos) {
      
 commenting (&_text, pos);
   }
 public:
   void try_move(Vector dir, Vector* pos, bool can_line_swap = true) {
         if(_text.size ()  == 0  ) {
            
return ;
}
         auto  y = pos->y;
         auto  x = pos->x;
         auto  is_insert = _current_mode==Mode::Insert;
         auto  h = max(1, (int)_text.size())-1;
      pos-> y= clamp (y + dir.y, 0, h);
      pos-> x= clamp (x + dir.x, 0, (int)_text.at(pos->y).size() - 1 + is_insert);
         auto  w = max(1, _text.at(pos->y).size())-1+is_insert;
         if(dir.x  < 0  &&y  > 0  &&x  == 0  &&can_line_swap    ) {
            pos-> y--;
            pos-> x= max (1, _text.at(pos->y).size())- 1+ is_insert;
}
         else if(dir.x  > 0  &&y  < h  &&x  == w  &&can_line_swap    ) {
            pos-> y++;
            pos-> x= 0;
}
   }
 public:
   void move(Dir dir, int multiply = 1, bool can_line_swap = true) {
      Vector vec= Vector ();
         switch(dir    ) {
            case Dir::Up:
             vec= Vector (0, -1);
break ;
            case Dir::Down:
             vec= Vector (0, 1);
break ;
            case Dir::Left:
             vec= Vector (-1, 0);
break ;
            case Dir::Right:
             vec= Vector (1, 0);
break ;
}
      vec.multiply (multiply);
      try_move (vec, &_selector, can_line_swap);
      vector< Vector> buf= {};
         for(int i = 0; i < _selections.size(); i++) {
               auto  s = _selections.at_ptr(i);
            try_move (vec, s, can_line_swap);
               if(s -> x  == _selector.x  &&s -> y  == _selector.y  ) {
                  
 continue;
}
            buf.push_back (_selections.at(i));
}
      _selections= buf;
   }
 public:
   void move_word(Dir dir, bool spacebreak = false) {
      move_word_impl (dir, &_selector, spacebreak);
      vector< Vector> buf= {};
         for(int i = 0; i < _selections.size(); i++) {
               auto  s = _selections.at_ptr(i);
            move_word_impl (dir, s, spacebreak);
               if(s -> x  == _selector.x  &&s -> y  == _selector.y  ) {
                  
 continue;
}
            buf.push_back (_selections.at(i));
}
      _selections= buf;
   }
 public:
   void move_word_impl(Dir dir, Vector* pos, bool spacebreak) {
         while(true   ) {
               auto  last_line = pos->y==_text.len()-1;
               auto  last_char = pos->x==_text.at(pos->y).size()-1;
               if(last_line    &&last_char    ) {
                  
return ;
}
               auto  s = String(_text.at(pos->y));
               auto  opt = s.find_alpha(pos->x, dir == Dir::Left);
               
{
auto f_optional_value = opt;
if(f_optional_value.is_some()) {
auto f = f_optional_value.value_unsafe();
                     if(f  != 0  ) {
                        
 break;
}
                     else if(dir  == Dir :: Right  ) {
                         try_move (Vector(1, 0), pos);
continue ;
}
                     else {
                         try_move (Vector(-1, 0), pos);
continue ;
}
}

}
            break;
}
         if(spacebreak    ) {
            
 try_move (Vector(-1, 0), pos);
return ;
}
         while(true   ) {
               auto  last_line = pos->y==_text.len()-1;
               auto  last_char = pos->x==_text.at(pos->y).size()-1;
               if(last_line    &&last_char    ) {
                  
return ;
}
               auto  s = String(_text.at(pos->y));
               auto  opt = s.find_non_alpha(pos->x, dir == Dir::Left);
               
{
auto c_optional_value = opt;
if(c_optional_value.is_some()) {
auto c = c_optional_value.value_unsafe();
                     if(c  != 0  ) {
                        
 break;
}
                     else if(dir  == Dir :: Right  ) {
                         try_move (Vector(1, 0), pos);
continue ;
}
                     else {
                         try_move (Vector(-1, 0), pos);
continue ;
}
}

}
            break;
}
         if(dir  == Dir :: Left  ) {
            
 try_move (Vector(-1, 0), pos);
}
   }
 public:
   void templates() {
         
{
auto h_optional_value = _highlighter;
if(h_optional_value.is_some()) {
auto h = h_optional_value.value_unsafe();
            _selections.clear ();
               auto  templates = h->syntax().templates();
               auto  container = HorizontalLayout(Vector(COLS/6*4, LINES/2), Vector(COLS/6, LINES/4));
               auto  content = List<string>();
               for(int t_iterator = 0; t_iterator < templates.size(); t_iterator++) {
auto t = templates.at(t_iterator);                  
 content.add (t.template_name);
}
            container.SetColor (-2);
            container.SetContent (content);
               if(templates.size ()  == 0  ) {
                  
return ;
}
               int  template_index = 0;
               while(true   ) {
                  container.draw (n);
                  n-> mark_until (
                container.Offset() + Vector(0, template_index),
                4, container.Size().x, true);
                     auto  key = n->key();
                     if(key  == '\n'  ) {
                        
 break;
}
                     if(key  == 27  ) {
                        
return ;
}
                     switch(key    ) {
                        case KEY_UP:
                         template_index--;
break ;
                        case KEY_DOWN:
                         template_index++;
break ;
}
                     if(template_index  < 0  ) {
                        
 template_index= 0;
}
                     if(template_index  >= templates.size ()  ) {
                        
 template_index= templates.size ()- 1;
}
}
               auto  temp = templates[template_index];
            _modifier= String ("");
            _current_mode= Mode:: Insert;
            draw (6);
               for(int t_iterator = 0; t_iterator < temp.templates.size(); t_iterator++) {
auto t = temp.templates.at(t_iterator);                     auto  s = String(t);
                     if(s.starts_with ("%")    ) {
                        text_editing (TextEdit::InsertNl);
                        draw (6);
                        continue;
}
                     while(s.starts_with ("$")    ) {
                           while(true   ) {
                                 auto  key = n->key();
                                 if(key  == 127  ) {
                                    
 break;
}
                                 else if(key  == '\n' || key  == ' '     ) {
                                     draw (6);
break ;
}
                                 else if(key  == KEY_BACKSPACE  ) {
                                    text_editing (TextEdit::RemoveChar);
                                    draw (6);
}
                                 else if(isgraph (key)    ) {
                                    text_editing (TextEdit::Insert, string(1, key));
                                    draw (6);
}
}
                        s.remove (0);
                           if(s.len ()  == 0  ) {
                              
 break;
}
                           while(! s.starts_with ("$")    ) {
                              content_change (TextEdit::Insert);
                              insert_text (string(1, s.at(0)), &_selector, false);
                              draw (6);
                              s.remove (0);
                                 if(s.len ()  == 0  ) {
                                    
 break;
}
}
                           if(s.len ()  == 0  ) {
                              
 break;
}
}
                  content_change (TextEdit::Insert);
                     for(int ch_iterator = 0; ch_iterator < s.to_string().size(); ch_iterator++) {
auto ch = s.to_string().at(ch_iterator);                        
 insert_text (string(1, ch), &_selector, false);
}
                  draw (6);
}
            _current_mode= Mode:: Normal;
}

}
   }
 public:
   Command run(Mode mode, bool internal_run = false) {
      _current_mode= mode;
         if(internal_run    ) {
            draw (6);
               if(_global_size.x  != COLS  ||_global_size.y  != LINES  ) {
                  _global_size= Vector (COLS,LINES);
                  return  Command:: Nop;
}
}
         auto  cmd = Command::Nop;
         auto  key = n->key();
         if(! run_all (key)    ) {
               switch(_current_mode    ) {
                  case Mode::Normal:
                   cmd= run_nor (key);
break ;
                  case Mode::Insert:
                   cmd= run_ins (key);
break ;
                  case Mode::Visual:
                   cmd= run_vis (key);
break ;
                  default:
                  
 break;
}
}
      return  cmd== Command:: Nop ? run (_current_mode, true): cmd;
   }
 public:
   bool run_all(int key) {
      MEVENT event;
         switch(key    ) {
            case '\t':
             text_editing (TextEdit::Tab);
break ;
            case KEY_BTAB:
             text_editing (TextEdit::Untab);
break ;
            case KEY_LEFT:
             move (Dir::Left);
break ;
            case KEY_RIGHT:
             move (Dir::Right);
break ;
            case KEY_DOWN:
             move (Dir::Down);
break ;
            case KEY_UP:
             move (Dir::Up);
break ;
            case KEY_NPAGE:
             move (Dir::Down, _content->Size().y);
break ;
            case KEY_PPAGE:
             move (Dir::Up, _content->Size().y);
break ;
            case KEY_HOME:
             move (Dir::Left, 100000, false);
break ;
            case KEY_END:
             move (Dir::Right, 100000, false);
break ;
            case KEY_SPREVIOUS:
            case KEY_SR:
             shift_line (Dir::Up);
break ;
            case KEY_SNEXT:
            case KEY_SF:
             shift_line (Dir::Down);
break ;
            case KEY_MOUSE:
               if(getmouse (&event)  != OK  ) {
                  
 break;
}
               if(event.bstate & (BUTTON1_CLICKED)    ) {
                     if(event.x  < _content -> Offset () .x  ) {
                        
 break;
}
                     if(event.y  < _content -> Offset () .y  ) {
                        
 break;
}
                     if(_text.size ()  == 0  ) {
                        
 break;
}
                  _selections.clear ();
                  _selector.x= event.x- _content-> Offset () .x+ _offset.x;
                  _selector.y= event.y- _content-> Offset () .y+ _offset.y;
                  move (Dir::Down, 0);
}
               if(event.bstate & (BUTTON4_PRESSED)    ) {
                  move (Dir::Up);
                  _offset= Vector (_offset.x, _selector.y - _content->Size().y / 2);
                     if(_offset.y  < 0  ) {
                        
 _offset.y= 0;
}
}
               if(event.bstate & (BUTTON5_PRESSED)    ) {
                  move (Dir::Down);
                  _offset= Vector (_offset.x, _selector.y - _content->Size().y / 2);
                     if(_offset.y  < 0  ) {
                        
 _offset.y= 0;
}
}
            break;
            default:
            
return false;
}
      return true;
   }
 public:
   Command run_base(int key) {
         switch(key    ) {
            case ':':
            
return  Command:: ModeCmdHan;
            case ' ':
            
return  run_space ();
            case 'j':
             move (Dir::Up);
break ;
            case 'k':
             move (Dir::Down);
break ;
            case 'l':
             move (Dir::Right);
break ;
            case 'h':
             move (Dir::Left);
break ;
            case 'n':
             text_editing (TextEdit::Lower);
break ;
            case 'N':
             text_editing (TextEdit::Upper);
break ;
            case 'e':
             move_word (Dir::Right, true);
break ;
            case 'w':
             move_word (Dir::Right);
break ;
            case 'b':
             move_word (Dir::Left);
break ;
            case 'u':
             undo ();
break ;
            case 'r':
             redo ();
break ;
            case 'f':
             find ();
break ;
            case 'F':
             find (true);
break ;
            case 'p':
             text_editing (TextEdit::PasteLine);
break ;
            case 'P':
             text_editing (TextEdit::PasteWord);
break ;
            case ';':
             _selections.clear ();
break ;
            default:
            
 break;
}
      return  Command:: Nop;
   }
 public:
   Command run_nor(int key) {
         auto  cmd = run_base(key);
      int _= 0;
         if(cmd  != Command :: Nop  ) {
            
return  cmd;
}
         switch(key    ) {
            case 27:
             _modifier= String ("");
break ;
            case 'v':
            _modifier= String ("");
            return  Command:: ModeVisual;
            case 'a':
            _modifier= String ("");
            _= system ("printf '\e[5 q'");
            _current_mode= Mode:: Insert;
            move (Dir::Right);
            draw (6);
            return  Command:: ModeInsert;
            case 'i':
            _modifier= String ("");
            _= system ("printf '\e[5 q'");
            _current_mode= Mode:: Insert;
            draw (6);
            return  Command:: ModeInsert;
            case 'C':
            text_editing (TextEdit::DeleteFrom);
            _= system ("printf '\e[5 q'");
            _current_mode= Mode:: Insert;
            draw (6);
            return  Command:: ModeInsert;
            case 'c':
            run_d ();
            _= system ("printf '\e[5 q'");
            _current_mode= Mode:: Insert;
            draw (6);
            return  Command:: ModeInsert;
            case 'x':
             text_editing (TextEdit::DeleteChar);
break ;
            case 'M':
             add_selector (true);
break ;
            case 'm':
             add_selector ();
break ;
            case 'D':
             text_editing (TextEdit::DeleteFrom);
break ;
            case 'd':
             run_d ();
break ;
            case 's':
             run_s ();
break ;
            case 'R':
             run_r ();
break ;
            case 'Y':
             yank_from ();
break ;
            case 'y':
             run_y ();
break ;
            case 'z':
             run_z ();
break ;
            case 'o':
             _num_diff=! _num_diff;
break ;
            case 't':
             _check_errors=! _check_errors;
break ;
            case 'T':
             templates ();
break ;
            default:
               if(! isdigit (key)    ) {
                  
 break;
}
            _modifier.append (string(1,key));
            break;
}
      return  Command:: Nop;
   }
 public:
   Command run_ins(int key) {
      int _= 0;
         switch(key    ) {
            case 27:
            _= system ("printf '\e[2 q'");
            _current_mode= Mode:: Normal;
            draw (6);
            return  Command:: ModeNormal;
            case '\n':
             text_editing (TextEdit::InsertNl);
break ;
            case '\b':
            case 127:
            case KEY_BACKSPACE:
             text_editing (TextEdit::RemoveChar);
break ;
            default:
             text_editing (TextEdit::Insert, string(1, key));
break ;
}
      return  Command:: Nop;
   }
 public:
   Command run_vis(int key) {
         auto  cmd = run_base(key);
         if(cmd  != Command :: Nop  ) {
            
return  cmd;
}
         switch(key    ) {
            case 'i':
            
return  Command:: ModeInsert;
            case 27:
            
return  Command:: ModeNormal;
            case 'd':
            text_editing (TextEdit::DeleteChar);
            _selections.clear ();
            move (Dir::Left, 0);
            break;
            case 'x':
             select_line ();
break ;
            case 'W':
             select_word ();
break ;
}
      return  Command:: Nop;
   }
 public:
   Command run_space() {
         auto  show = GridLayout(Vector(COLS, 4), Vector(0, LINES - 7));
      show.SetColor (-1);
      vector<string> commands= {
            "f - open file explorer",
            "t - split editor horizontally",
            "v - split editor vertically",
            "h - move to editor left",
            "l - move to editor right",
            "j - move to editor up",
            "k - move to editor down",
            "c - toggle comment",
            "P - paste word from clipboard",
            "p - open command pallete",
            "s - open file searcher",
            ""
        };
         for(int c_iterator = 0; c_iterator < commands.size(); c_iterator++) {
auto c = commands.at(c_iterator);               auto  ele = new IContainer(Fill::Flex);
            ele-> SetContent (List<string>({c}));
            show.add_element (ele);
}
         for(int i = 0; i < 4; i++) {
            
 show.add_row ();
}
      show.draw (n);
      show.destruct ();
         auto  result = TextEditOrCommand(Command::Nop);
         switch(n -> key ()    ) {
            case 'f':
            
return  Command:: ModeFileEx;
            case 't':
            
return  Command:: SplitHorizontal;
            case 'v':
            
return  Command:: SplitVertical;
            case 'h':
            
return  Command:: EditorLeft;
            case 'l':
            
return  Command:: EditorRight;
            case 'j':
            
return  Command:: EditorUp;
            case 'k':
            
return  Command:: EditorDown;
            case 'c':
             text_editing (TextEdit::CommentToggle);
break ;
            case 'P':
            _shared_buffer-> clear ();
            text_editing (TextEdit::PasteLine);
            break;
            case 'p':
            result= _command_pallete-> show (n);
               
{
auto edit_optional_value = result.textedit;
if(edit_optional_value.is_some()) {
auto edit = edit_optional_value.value_unsafe();
                  
 text_editing (edit);
}

}
               
{
auto command_optional_value = result.command;
if(command_optional_value.is_some()) {
auto command = command_optional_value.value_unsafe();
                  
return  command;
}

}
            break;
            case 's':
               
{
auto fp_optional_value = Lgrep(n);
if(fp_optional_value.is_some()) {
auto fp = fp_optional_value.value_unsafe();
                  
 open (fp);
}

}
            break;
}
      return  Command:: ModeNormal;
   }
 public:
   Command run_d() {
         auto  edit_cmd = Option<TextEdit>();
         switch(n -> key ()    ) {
            case 'd':
             edit_cmd= Some (TextEdit::DeleteLine);
break ;
            case 'w':
             edit_cmd= Some (TextEdit::DeleteWord);
break ;
            case 'e':
             edit_cmd= Some (TextEdit::DeleteWordExlusive);
break ;
}
         
{
auto edit_optional_value = edit_cmd;
if(edit_optional_value.is_some()) {
auto edit = edit_optional_value.value_unsafe();
               
{
auto num_optional_value = _modifier.to_num();
if(num_optional_value.is_some()) {
auto num = num_optional_value.value_unsafe();
                     if(num  == 0  ) {
                        
 text_editing (edit);
}
                     for(int i = 0; i < num; i++) {
                        text_editing (edit, i != 0);
}
                  _modifier= String ("");
                  return  Command:: Nop;
}

}
            text_editing (edit);
}

}
      return  Command:: Nop;
   }
 public:
   Command run_y() {
         switch(n -> key ()    ) {
            case 'y':
            
 break;
            default:
            
return  Command:: Nop;
}
         
{
auto num_optional_value = _modifier.to_num();
if(num_optional_value.is_some()) {
auto num = num_optional_value.value_unsafe();
               if(num  == 0  ) {
                  
 yank_line (&_selector);
}
               for(int i = 0; i < num; i++) {
                  yank_line (&_selector, i != 0);
                  move (Dir::Down);
}
            _modifier= String ("");
            return  Command:: Nop;
}

}
      yank_line (&_selector);
      return  Command:: Nop;
   }
 public:
   Command run_z() {
         auto  vec = Vector(_offset.x, _selector.y);
         switch(n -> key ()    ) {
            case 'z':
            case '.':
             vec.y-= _content-> Size () .y/ 2;
break ;
            case 'b':
             vec.y-= _content-> Size () .y;
break ;
            case 't':
            
 break;
            default:
            
return  Command:: ModeNormal;
}
      _offset= vec.y< 0 ? Vector (vec.x, 0): vec;
      return  Command:: ModeNormal;
   }
 public:
   Command run_s() {
         string  search = "";
         while(true   ) {
            n-> clearLn (LINES - 1);
            n-> add_col (LINES - 1, 0, "search:", 3);
            n-> add (LINES - 1, 8, search);
            n-> add_col (LINES - 1, 8 + search.size(), '|', 1);
               auto  key = n->key();
               switch(key    ) {
                  case '\n':
                     if(! find (search)    ) {
                        
 find (search, true);
}
                  n-> clearLn (LINES - 1);
                  return  Command:: Nop;
                  case 27:
                  n-> clearLn (LINES - 1);
                  return  Command:: Nop;
                  case '\b':
                  case 127:
                  case KEY_BACKSPACE:
                     if(search.size ()  == 0  ) {
                        n-> clearLn (LINES - 1);
                        return  Command:: Nop;
}
                  search.pop_back ();
                  break;
                  default:
                     if(isgraph (key)    ) {
                        
 search+= key;
}
                  break;
}
}
      return  Command:: Nop;
   }
 public:
   Command run_r() {
         string  search = "";
         string  replace = "";
         int  step = 0;
         while(true   ) {
            n-> clearLn (LINES - 1);
               auto  extra = step?3:0;
            string extra_str= step ?"":" ";
            n-> add_col (LINES - 1, 0, "replace:", 3);
            n-> add (LINES - 1, 9, "" + to_string(search) + "" + to_string(extra_str) + " - " + to_string(replace) + "");
            n-> mark_until (LINES - 1, 9 + search.size() + extra_str.size() + 1, 2 + step, true);
            n-> add_col (LINES - 1, 9 + search.size() + replace.size() + extra, '|', 1);
               auto  key = n->key();
               switch(key    ) {
                  case '\n':
                     if(step  == 1  ) {
                           while(find (search, replace)    ) {
                              
 continue;
}
                        n-> clearLn (LINES - 1);
                        return  Command:: Nop;
}
                  step++;
                  break;
                  case 27:
                  n-> clearLn (LINES - 1);
                  return  Command:: Nop;
                  case '\b':
                  case 127:
                  case KEY_BACKSPACE:
                     if(search.size ()  == 0  ) {
                        n-> clearLn (LINES - 1);
                        return  Command:: Nop;
}
                     if(step  == 1  &&replace.size ()  == 0  ) {
                        step--;
                        break;
}
                     switch(step    ) {
                        case 0:
                         search.pop_back ();
break ;
                        case 1:
                         replace.pop_back ();
break ;
}
                  break;
                  default:
                     switch(step    ) {
                        case 0:
                           if(isgraph (key)    ) {
                              
 search+= key;
}
                        break;
                        case 1:
                           if(isgraph (key)    ) {
                              
 replace+= key;
}
                        break;
}
                  break;
}
}
   }
};
class EditorManager: public IContent {
 private:
   vector<Editor*> _editors = {};
 private:
   vector<HorizontalLayout*> _editorspaces = {};
 private:
   Option<HorizontalLayout*> _activeSpace = None<HorizontalLayout*>();
 private:
   Option<Editor*> _activeEditor = None<Editor*>();
 private:
   vector<string> _shared_buffer = {};
 private:
   IContainer* _status_line;
 private:
   CommandPallete _command_pallete = CommandPallete();
 public:
   EditorManager (Ncurses* n, IContainer* status_line) {
      this-> n= n;
      _status_line= status_line;
      _origin=new  VerticalLayout (Fill::Flex);
      add_space ();
   }
 private:
   void activate(Dir dir) {
         switch(dir    ) {
            case Dir::Left:
             activate_h (dir);
break ;
            case Dir::Right:
             activate_h (dir);
break ;
            case Dir::Up:
             activate_v (dir);
break ;
            case Dir::Down:
             activate_v (dir);
break ;
}
   }
 private:
   void activate_v(Dir dir) {
         int  i = 0;
         if(_editors.size ()  < 2  ) {
            
return ;
}
         if(_editorspaces.size ()  < 2  ) {
            
return ;
}
         
{
auto index_optional_value = find_active_in_space();
if(index_optional_value.is_some()) {
auto index = index_optional_value.value_unsafe();
               
{
auto active_optional_value = _activeSpace;
if(active_optional_value.is_some()) {
auto active = active_optional_value.value_unsafe();
                     for(int space_iterator = 0; space_iterator < _editorspaces.size(); space_iterator++) {
auto space = _editorspaces.at(space_iterator);                           if(space -> Offset () .eq (active->Offset())    ) {
                                 switch(dir    ) {
                                    case Dir::Up:
                                       if(i  == 0  ) {
                                           i= _editorspaces.size ()- 1;
break ;
}
                                    i--;
                                    break;
                                    case Dir::Down:
                                       if(i  == _editorspaces.size () - 1  ) {
                                           i= 0;
break ;
}
                                    i++;
                                    break;
}
                                 auto  active = _editorspaces.at(i);
                              _activeSpace= Some (active);
                                 if(index  >= active -> size ()  ) {
                                    index= active-> size ()- 1;
}
                                 auto  editor = active->containers()->at(index);
                              _activeEditor= find_editor_from_offset (editor->Offset());
                              return ;
}
                        i++;
}
}

}
}

}
   }
 private:
   void activate_h(Dir dir) {
         if(_editors.size ()  < 2  ) {
            
return ;
}
         
{
auto index_optional_value = find_active_in_space();
if(index_optional_value.is_some()) {
auto index = index_optional_value.value_unsafe();
               
{
auto space_optional_value = _activeSpace;
if(space_optional_value.is_some()) {
auto space = space_optional_value.value_unsafe();
                     auto  size = space->containers()->size();
                     switch(dir    ) {
                        case Dir::Left:
                           if(index  == 0  ) {
                               index= size- 1;
break ;
}
                        index--;
                        break;
                        case Dir::Right:
                           if(index  >= size - 1  ) {
                               index= 0;
break ;
}
                        index++;
                        break;
}
                     auto  editor = space->containers()->at(index);
                  _activeEditor= find_editor_from_offset (editor->Offset());
}

}
}

}
   }
 private:
   Option<Editor*> find_editor_from_offset(Vector offset) {
         
{
auto space_optional_value = _activeSpace;
if(space_optional_value.is_some()) {
auto space = space_optional_value.value_unsafe();
               for(int editor_iterator = 0; editor_iterator < _editors.size(); editor_iterator++) {
auto editor = _editors.at(editor_iterator);                     if(editor -> Offset () .eq (offset)    ) {
                        
return  Some (editor);
}
}
}

}
      return  None< Editor*> ();
   }
 private:
   Option<int> find_active_in_space() {
         
{
auto active_optional_value = _activeEditor;
if(active_optional_value.is_some()) {
auto active = active_optional_value.value_unsafe();
            
return  find_editor_in_space (active->path());
}

}
      return  None<int> ();
   }
 private:
   Option<int> find_editor_in_space(string path) {
         
{
auto editor_optional_value = try_find_editor(path);
if(editor_optional_value.is_some()) {
auto editor = editor_optional_value.value_unsafe();
               
{
auto space_optional_value = _activeSpace;
if(space_optional_value.is_some()) {
auto space = space_optional_value.value_unsafe();
                     auto  editors = space->containers();
                     auto  size = editors->size();
                     for(int i = 0; i < size; i++) {
                           auto  e = editors->at(i);
                           auto  offset = e->Offset();
                           if(offset.eq (editor->Offset())    ) {
                              
return  Some (i);
}
}
}

}
}

}
      return  None<int> ();
   }
 public:
   void open_file(string path) {
         
{
auto editor_optional_value = try_find_editor(path);
if(editor_optional_value.is_some()) {
auto editor = editor_optional_value.value_unsafe();
            _activeEditor= Some (editor);
}

}
         
{
auto a_optional_value = _activeEditor;
if(a_optional_value.is_some()) {
auto a = a_optional_value.value_unsafe();
            
 a-> open (path);
}

}
   }
 public:
   void move_to(int pos) {
         
{
auto a_optional_value = _activeEditor;
if(a_optional_value.is_some()) {
auto a = a_optional_value.value_unsafe();
            
 a-> move_to (pos);
}

}
   }
 public:
   Command write_editor() {
         
{
auto a_optional_value = _activeEditor;
if(a_optional_value.is_some()) {
auto a = a_optional_value.value_unsafe();
            
 a-> write_content ();
}

}
      return  Command:: ModeNormal;
   }
 public:
   Command close_editor(bool forced = false) {
         if(_editors.size ()  == 0  ) {
            
return  Command:: Exit;
}
      _origin-> clear ();
         auto  closed = None<Editor*>();
         
{
auto a_optional_value = _activeEditor;
if(a_optional_value.is_some()) {
auto a = a_optional_value.value_unsafe();
               if(! a -> has_changes ()    ||forced    ) {
                  a-> close ();
}
               else {
                  n-> col (1);
                  n-> add (LINES-1, 0, "Buffer has changes please use q! if you really want to quit.");
                  n-> col (1,false);
                  n-> key ();
                  return  Command:: ModeCmdHan;
}
}

}
      vector< HorizontalLayout*> spaces= {};
         for(int space_iterator = 0; space_iterator < _editorspaces.size(); space_iterator++) {
auto space = _editorspaces.at(space_iterator);               auto  containers = space->containers();
            vector< IContainer*> buf= {};
               for(int i = 0; i < containers->size(); i++) {
                     auto  editor = containers->at(i);
                     if(! editor -> Active ()    ) {
                        
 continue;
}
                     else {
                        
 buf.push_back (editor);
}
}
            space-> clear ();
               if(buf.size ()  == 0  ) {
                  
 continue;
}
               for(int editor_iterator = 0; editor_iterator < buf.size(); editor_iterator++) {
auto editor = buf.at(editor_iterator);                  
 space-> add (editor);
}
            spaces.push_back (space);
}
         
{
auto e_optional_value = closed;
if(e_optional_value.is_some()) {
auto e = e_optional_value.value_unsafe();
            delete e-> origin ();
            delete (e);
}

}
      _editorspaces= spaces;
      _origin-> clear ();
         for(int space_iterator = 0; space_iterator < _editorspaces.size(); space_iterator++) {
auto space = _editorspaces.at(space_iterator);            
 _origin-> add (space);
}
      vector< Editor*> editors= {};
         for(int editor_iterator = 0; editor_iterator < _editors.size(); editor_iterator++) {
auto editor = _editors.at(editor_iterator);               if(editor -> is_active ()    ) {
                  
 editors.push_back (editor);
}
               else {
                  
 delete editor;
}
}
      _editors= editors;
         if(_editors.size ()  == 0  ) {
            
return  Command:: Exit;
}
      _activeEditor= Some (get_last(&_editors));
      _activeSpace= Some (get_last(&_editorspaces));
      return  Command:: ModeNormal;
   }
 public:
   Command run(Mode mode) {
         auto  cmd = Command::Nop;
         
{
auto a_optional_value = _activeEditor;
if(a_optional_value.is_some()) {
auto a = a_optional_value.value_unsafe();
            
 cmd= a-> run (mode);
}

}
         switch(cmd    ) {
            case Command::EditorLeft:
             activate (Dir::Left);
break ;
            case Command::EditorRight:
             activate (Dir::Right);
break ;
            case Command::EditorUp:
             activate (Dir::Up);
break ;
            case Command::EditorDown:
             activate (Dir::Down);
break ;
}
      return  cmd;
   }
 public:
   void set_syntax(string syntax) {
         
{
auto a_optional_value = _activeEditor;
if(a_optional_value.is_some()) {
auto a = a_optional_value.value_unsafe();
            a-> set_syntax (syntax);
}

}
   }
 public:
   void draw() {
         for(int editor_iterator = 0; editor_iterator < _editors.size(); editor_iterator++) {
auto editor = _editors.at(editor_iterator);            
 editor-> draw ();
}
         
{
auto a_optional_value = _activeEditor;
if(a_optional_value.is_some()) {
auto a = a_optional_value.value_unsafe();
            
 a-> draw (6);
}

}
   }
 public:
   void add_editor() {
      _editors.push_back (new Editor(n, (string)"", &_shared_buffer, _status_line, &_command_pallete));
         
{
auto active_optional_value = _activeSpace;
if(active_optional_value.is_some()) {
auto active = active_optional_value.value_unsafe();
               auto  editor = get_last(&_editors);
            _activeEditor= Some (editor);
            active-> add (editor->origin());
}

}
   }
 public:
   void add_space() {
      _editorspaces.push_back (new HorizontalLayout(Fill::Flex));
         auto  space = get_last(&_editorspaces);
      _origin-> add (space);
      _activeSpace= Some (space);
      add_editor ();
   }
 public:
   Option<Editor*> try_find_editor(string path) {
         for(int i = 0; i < _editors.size(); i++) {
               auto  p = _editors.at(i)->path();
               if(p  != path  ) {
                  
 continue;
}
            return  Some (_editors.at(i));
}
      return  None< Editor*> ();
   }
 public:
template <typename T>
   T get_last(vector<T>* vec) {
         auto  count = vec->size();
      return  get_at (vec, count - 1);
   }
 public:
template <typename T>
   T get_at(vector<T>* vec, int at) {
      
return  vec-> at (at);
   }
 public:
   void templates() {
         
{
auto a_optional_value = _activeEditor;
if(a_optional_value.is_some()) {
auto a = a_optional_value.value_unsafe();
            
 a-> templates ();
}

}
   }
 public:
   void search() {
         
{
auto a_optional_value = _activeEditor;
if(a_optional_value.is_some()) {
auto a = a_optional_value.value_unsafe();
            
 a-> run_s ();
}

}
   }
 public:
   void replace() {
         
{
auto a_optional_value = _activeEditor;
if(a_optional_value.is_some()) {
auto a = a_optional_value.value_unsafe();
            
 a-> run_r ();
}

}
   }
};
class Explorer: public IContent {
 private:
   string _path = ".";
 private:
   int _pos = 0;
 private:
   int _offset = 0;
 private:
   Vector _global_size = Vector(COLS,LINES);
 public:
   Explorer (Ncurses* n) {
      _text= list_files (_path);
      _origin=new  IContainer (Fill::Static, Vector(25,0));
      _origin-> SetColor (2);
      _origin-> SetContent (_text);
      this-> n= n;
   }
 private:
   int get_internal_offset() {
         auto  size = _origin->Size();
         auto  y = size.y-1;
         if(_pos  > y + _offset  ) {
            _offset= _pos- y;
}
         if(_pos  < _offset  ) {
            _offset= _pos;
}
      return  _offset;
   }
 public:
   void draw() {
         auto  offset = get_internal_offset();
      List<string> buf= List<string> ();
         for(int i = 0; i < _text.size(); i++) {
               if(i  < offset  ) {
                  
 continue;
}
            buf.add (_text.at(i));
}
      _origin-> SetContent (buf);
      _origin-> draw (n);
      n-> mark_until (_pos - offset, 0, 5, _origin->Size().x);
   }
 public:
   void set_visibility(Mode mode) {
      
 _origin-> SetActive (mode == Mode::FileEx);
   }
 public:
   Command toggle() {
      _origin-> SetActive (!_origin->Active());
      return  Command:: ModeNormal;
   }
 public:
   void update() {
      _text= list_files (_path);
      _origin-> SetContent (_text);
      draw ();
   }
 public:
   string get_fp() {
      string fp= _path.substr (2);
      _path=".";
      update ();
      return  fp;
   }
 public:
   Command move_and_reset() {
      
return  move_and_reset (Command::Nop);
   }
 public:
   Command move_and_reset(Command cmd) {
      _text= list_files (_path);
      _pos= 0;
      move (Dir::Up);
      return  cmd;
   }
 public:
   void move(Dir dir) {
      
 move (dir, 1);
   }
 public:
   void move(Dir dir, int multiply) {
         switch(dir    ) {
            case Dir::Up:
             _pos= clamp (_pos - (1 * multiply), 0, _text.size() - 1);
break ;
            case Dir::Down:
             _pos= clamp (_pos + (1 * multiply), 0, _text.size() - 1);
break ;
}
   }
 public:
   Command choose() {
         auto  p = _text.at(_pos);
         if(p  == "."  ) {
            
return  Command:: Nop;
}
      _path+="/" + to_string(_text.at(_pos)) + "";
      update ();
      return  move_and_reset (_text.size() == 0 ? Command::SelectFile : Command::Nop);
   }
 public:
   Command run() {
      
return  run (false);
   }
 public:
   Command run(bool internal_run) {
         if(internal_run    ) {
            draw ();
               if(_global_size.x  != COLS  ||_global_size.y  != LINES  ) {
                  _global_size= Vector (COLS,LINES);
                  return  Command:: Nop;
}
}
         auto  cmd = Command::Nop;
         switch(n -> key ()    ) {
            case ' ':
             cmd= search ();
break ;
            case 'f':
             cmd= toggle ();
break ;
            case KEY_UP:
            case 'j':
             move (Dir::Up);
break ;
            case KEY_DOWN:
            case 'k':
             move (Dir::Down);
break ;
            case KEY_PPAGE:
             move (Dir::Up, _origin->Size().y);
break ;
            case KEY_NPAGE:
             move (Dir::Down, _origin->Size().y);
break ;
            case '\n':
             cmd= choose ();
break ;
            case 27:
             cmd= toggle ();
break ;
            default:
            
 break;
}
      return  cmd== Command:: Nop ? run (true): cmd;
   }
 public:
   Command search() {
      
return  search (false, None<int>());
   }
 public:
   Command search(bool recurse, Option<int> key_opt) {
         auto  key = key_opt.is_none()?n->key():0;
         
{
auto k_optional_value = key_opt;
if(k_optional_value.is_some()) {
auto k = k_optional_value.value_unsafe();
            
 key= k;
}

}
         auto  i = -1;
         for(int s_iterator = 0; s_iterator < _text.size(); s_iterator++) {
auto s = _text.at(s_iterator);            i++;
               if(s.size ()  == 0  ) {
                  
 continue;
}
               if(i  <= _pos  &&! recurse    ) {
                  
 continue;
}
               if(tolower (s[0])  == key  ) {
                  _pos= i;
                  return  Command:: Nop;
}
}
      return ! recurse ? search (true, Some(key)): Command:: Nop;
   }
};
class CommandLine: public IContent {
 private:
   string _line = "";
 private:
   EditorManager* _editorManager;
 public:
   CommandLine (Ncurses* n, EditorManager* editorManager) {
      _origin=new  IContainer (Fill::Static, Vector(0,1));
      _origin-> SetColor (3);
      _origin-> SetLabel (_line);
      this-> n= n;
      _editorManager= editorManager;
   }
 public:
   void update(string line) {
      _line= line;
      _origin-> SetLabel (_line);
      _origin-> draw (n);
   }
 public:
   Command exit() {
      update ("");
      return  Command:: ModeNormal;
   }
 public:
   Command try_parse(EditorManager* manager) {
         auto  s = String(_line);
      s.remove (0);
      _line= s.to_string ();
         if(_line  == "q"  ) {
            update ("");
            return  Command:: CloseEditor;
}
         else if(_line  == "q!"  ) {
            update ("");
            return  Command:: CloseEditorForced;
}
         else if(_line  == "w"  ) {
            update ("");
            return  Command:: WriteEditor;
}
         else if(_line  == "wq"  ) {
            update ("");
            return  Command:: WriteCloseEditor;
}
         else if(s.starts_with ("touch ")    ) {
            write (" ", _line.substr(6));
            update ("");
            return  Command:: ModeNormal;
}
         else if(s.starts_with ("mkdir ")    ) {
            makedir (_line.substr(6));
            update ("");
            return  Command:: ModeNormal;
}
         else if(s.starts_with ("syntax ")    ) {
            _editorManager-> set_syntax (_line.substr(7));
            update ("");
            return  Command:: ModeNormal;
}
         else if(s.starts_with ("!")    ) {
            n-> stop ();
            system ("" + to_string(_line.substr(1)) + " && echo 'Press any key to return!'");
            n-> key ();
            n-> start ();
            update ("");
            return  Command:: ModeNormal;
}
         
{
auto num_optional_value = s.to_num();
if(num_optional_value.is_some()) {
auto num = num_optional_value.value_unsafe();
            update ("");
            manager-> move_to (num);
            return  Command:: ModeNormal;
}

}
      n-> col (1);
      n-> add (LINES - 1, 0, "no such command: " + to_string(_line) + "");
      n-> key ();
      n-> col (1, false);
      update (":");
      return  Command:: Nop;
   }
 public:
   Command remove_ch() {
         if(_line.size ()  == 0  ) {
            
return  Command:: Nop;
}
      _line.pop_back ();
      update (_line);
         if(_line.size ()  == 0  ) {
            
return  exit ();
}
      return  Command:: Nop;
   }
 public:
   Command add_ch(int key) {
         auto  ch = string(1, key);
      _line+= ch;
      update (_line);
      return  Command:: Nop;
   }
 public:
   Command run(EditorManager* manager) {
         if(_line.size ()  == 0  ) {
            
 update (":");
}
         auto  key = n->key();
         switch(key    ) {
            case 27:
            
return  exit ();
            case '\n':
            
return  try_parse (manager);
            case '\b':
            case 127:
            case KEY_BACKSPACE:
            
return  remove_ch ();
            default:
            
return  add_ch (key);
}
      return  Command:: Nop;
   }
};
class ModeView: public IContent {
 private:
   string _line = "";
 private:
   Mode _mode = Mode::FileEx;
 public:
   ModeView (Ncurses* n) {
      _origin=new  IContainer (Fill::Static, Vector(10,0));
      _origin-> SetColor (5);
      this-> n= n;
      set (_mode);
   }
 public:
   void set(Mode mode) {
      _mode= mode;
      _line="  " + to_string(mode) + "  ";
      _origin-> SetLabel (_line);
   }
 public:
   Mode mode() {
      
return  _mode;
   }
};
class Model: public MainContainer {
 private:
   Ncurses n = Ncurses();
 private:
   IContainer _line = IContainer(Fill::Flex);
 private:
   HorizontalLayout _top = HorizontalLayout(Fill::Flex);
 private:
   HorizontalLayout _status = HorizontalLayout(Fill::Static, Vector(0,1));
 private:
   Explorer _explorer = Explorer(&n);
 private:
   ModeView _mode_view = ModeView(&n);
 private:
   EditorManager _manager = EditorManager(&n, &_line);
 private:
   CommandLine _command_line = CommandLine(&n, &_manager);
 public:
   Model (int argc, char** argv) {
      mousemask (ALL_MOUSE_EVENTS, NULL);
      _top.SetColor (0);
      _status.SetColor (1);
      _line.SetColor (3);
      _line.SetLabel (" << [f] $ [0,0]");
      add (&_top);
      add (&_status);
      add (_command_line.origin());
      _top.add (_explorer.origin());
      _top.add (_manager.origin());
      _status.add (_mode_view.origin());
      _status.add (&_line);
         if(argc  >= 2  ) {
            _manager.open_file (argv[1]);
}
      update ();
      draw (&n);
   }
 public:
   void render() {
      update ();
      draw (&n);
      _explorer.draw ();
      _manager.draw ();
   }
 public:
   bool run() {
         auto  mode = _mode_view.mode();
         auto  cmd = Command::Nop;
      curs_set (mode == Mode::Insert);
         switch(mode    ) {
            case Mode::FileEx:
             cmd= _explorer.run ();
break ;
            case Mode::CmdHan:
             cmd= _command_line.run (&_manager);
break ;
            case Mode::Normal:
            case Mode::Visual:
            case Mode::Insert:
             cmd= _manager.run (mode);
break ;
}
         switch(cmd    ) {
            case Command::CloseEditor:
             cmd= _manager.close_editor ();
break ;
            case Command::CloseEditorForced:
             cmd= _manager.close_editor (true);
break ;
            case Command::WriteEditor:
             cmd= _manager.write_editor ();
break ;
            case Command::WriteCloseEditor:
            _manager.write_editor ();
            cmd= _manager.close_editor ();
            break;
}
         switch(cmd    ) {
            case Command::Exit:
            n.stop ();
            return true;
            case Command::ModeFileEx:
             _mode_view.set (Mode::FileEx);
break ;
            case Command::ModeCmdHan:
             _mode_view.set (Mode::CmdHan);
break ;
            case Command::ModeNormal:
             _mode_view.set (Mode::Normal);
break ;
            case Command::ModeInsert:
             _mode_view.set (Mode::Insert);
break ;
            case Command::ModeVisual:
             _mode_view.set (Mode::Visual);
break ;
            case Command::SelectFile:
             _manager.open_file (_explorer.get_fp());
break ;
            case Command::SplitVertical:
             _manager.add_space ();
break ;
            case Command::SplitHorizontal:
             _manager.add_editor ();
break ;
            case Command::EditorTemplates:
             _manager.templates ();
break ;
            case Command::EditorSearch:
             _manager.search ();
break ;
            case Command::EditorReplace:
             _manager.replace ();
break ;
            case Command::Nop:
            
 break;
}
      _explorer.set_visibility (_mode_view.mode());
      return false;
   }
};
int main(int argc, char* argv[]) {
      auto  n = Ncurses();
      auto  model = Model(argc, argv);
      while(true   ) {
         n.clearScr ();
         model.render ();
            if(model.run ()    ) {
               
 break;
}
}
   n.stop ();
   return 0;
}
