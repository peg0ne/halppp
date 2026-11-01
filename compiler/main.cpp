#include <string>
using namespace std;
#include <vector>
#include <iostream>
#include <ctype.h>
#include <fstream>
#include <stdlib.h>
#include <dirent.h>
#include <algorithm>
#include <unistd.h>
#include <sys/stat.h>
template <typename T>
struct Option;
template <typename T>
struct Peekable;
class String;
struct Clap;
template <typename T>
class List;

#define ARG_END ") {\n"

#define ARG_SEP ", "

#define ASSIGNMENT " = "

#define BLOCK_END "}\n"

#define BLOCK_START " {\n"

#define CHAR_QUOTE '"'

#define CHAR_SINGLE '\''

#define CLASS "class "

#define COMPILER_OUT " -o "

#define CPP_SUFFIX ".cpp"

#define EMPTY ""

#define ENUM "enum class "

#define ENUM_SEP ",\n"

#define FOR_AFTER_UNTIL "; "

#define FOR_END "++) {\n"

#define FOR_MID " = 0; "

#define FOR_START "for(int "

#define FOR_UNTIL " < "

#define HA_SUFFIX ".ha"

#define INCLUDE "#include "

#define INHERIT ": public "

#define LARROW "<"

#define LINE_END ";\n"

#define LPAREN "("

#define NAMESPACE "using namespace "

#define NEWLINE "\n"

#define PRIVATE_STATE " private:\n"

#define PROTECTED_STATE " protected:\n"

#define PUBLIC_STATE " public:\n"

#define QUOTE "\""

#define RARROW ">"

#define RBRACK "}"

#define RETURN_VALUE_IDS "return_value"

#define RPAREN ")"

#define SPACE " "

#define STRUCT "struct "

#define TAB "   "

#define TEMPLATE "template <typename "

#define TEMPLATE_END ">\n"

#define TEMPLATE_MID ", typename "

#define VOID "void"

#define GLOBAL "#define "

#define TOKEN_ALLEQUALS "=&="

#define TOKEN_ALLLESSOREQUALS "=<="

#define TOKEN_ALLLESSTHAN "<<<"

#define TOKEN_ALLMOREOREQUALS "=>="

#define TOKEN_ALLMORETHAN ">>>"

#define TOKEN_ALLNOTEQUALS "=!="

#define TOKEN_AND "&&"

#define TOKEN_ANYEQUALS "=|="

#define TOKEN_ASTERIX "*"

#define TOKEN_BANG "!"

#define TOKEN_CASE "case"

#define TOKEN_CLASS "class"

#define TOKEN_CONST "const"

#define TOKEN_COLON ":"

#define TOKEN_COMMA ","

#define TOKEN_PERIOD "."

#define TOKEN_DOUBLE_PERIOD ".."

#define TOKEN_TRIPLE_PERIOD "..."

#define TOKEN_COMPILER "compiler"

#define TOKEN_COOLARROW "=>"

#define TOKEN_DBLCOLON "::"

#define TOKEN_DBLLESSTHAN "<<"

#define TOKEN_DBLMORETHAN ">>"

#define TOKEN_DEFAULT "default"

#define TOKEN_DO "do"

#define TOKEN_DOBR "dobr"

#define TOKEN_DOCO "doco"

#define TOKEN_DORE "dore"

#define TOKEN_DOREMI "doremi"

#define TOKEN_EIGHT "8"

#define TOKEN_ELIF "elif"

#define TOKEN_ELSE "else"

#define TOKEN_ENUM "enum"

#define TOKEN_EOF "EOF"

#define TOKEN_EQUALITY "=="

#define TOKEN_EQUALS "="

#define TOKEN_EXTEND "extend"

#define TOKEN_FALSE "false"

#define TOKEN_FIVE "5"

#define TOKEN_FOR "for"

#define TOKEN_FOREACH "foreach"

#define TOKEN_FORWARDSLASH "/"

#define TOKEN_FOUR "4"

#define TOKEN_FUNCTION "fn"

#define TOKEN_GET "get"

#define TOKEN_GLOBAL "glob"

#define TOKEN_IFS "if"

#define TOKEN_IN "in"

#define TOKEN_INCLUDE "inc"

#define TOKEN_INT "int"

#define TOKEN_LBLOCK "{"

#define TOKEN_LBRACK "["

#define TOKEN_LESSTHAN "<"

#define TOKEN_LESSTHANOREQUALS "<="

#define TOKEN_LET "let"

#define TOKEN_LINE_COMMENT "//"

#define TOKEN_LOOP "loop"

#define TOKEN_LPAREN "("

#define TOKEN_MACRODEFINITION "def"

#define TOKEN_MATCH "match"

#define TOKEN_MORETHAN ">"

#define TOKEN_MORETHANOREQUALS ">="

#define TOKEN_NAMED "named"

#define TOKEN_NEW "new"

#define TOKEN_NEWLINE "\n"

#define TOKEN_NINE "9"

#define TOKEN_NONEQUALITY "!="

#define TOKEN_ONE "1"

#define TOKEN_OR "||"

#define TOKEN_POINTER "->"

#define TOKEN_PRIVATE "private"

#define TOKEN_PROTECTED "protected"

#define TOKEN_PUBLIC "pub"

#define TOKEN_RBLOCK "}"

#define TOKEN_RBRACK "]"

#define TOKEN_RETURN "return"

#define TOKEN_RPAREN ")"

#define TOKEN_SEMICOLON ";"

#define TOKEN_SEVEN "7"

#define TOKEN_SIX "6"

#define TOKEN_STR "str"

#define TOKEN_STATIC "static"

#define TOKEN_STRING "string"

#define TOKEN_STRUCT "struct"

#define TOKEN_SUB "-"

#define TOKEN_SUM "+"

#define TOKEN_SWITCH "switch"

#define TOKEN_SELECT "select"

#define TOKEN_FROM "from"

#define TOKEN_THREE "3"

#define TOKEN_TRUE "true"

#define TOKEN_TWO "2"

#define TOKEN_TYPE "char"

#define TOKEN_UNTIL "until"

#define TOKEN_USE "use"

#define TOKEN_VIRTUAL "virtual"

#define TOKEN_WHILE "while"

#define TOKEN_ZERO "0"

#define TOKEN_RAW "raw"

#define TOKEN_MAP "map"

#define TOKEN_WHERE "where"

#define VAR_ERR_COM "[Variable]: Variable declaration already complete: "

#define VAR_ERR_ERR "[Variable]: Unexpected error"

#define VAR_ERR_INC "[Variable]: Variable declaration incomplete: "

#define VAR_ERR_INV "[Variable]: Invalid Declaration"

#define VAR_ERR_NON "[Variable]: No token available"

#define VAR_ERR_POI "[Variable]: Pointer infront of type not allowed: "

#define VAR_ERR_SET "[Variable]: Invalid value setter"

#define VAR_ERR_TEM "[Variable]: Variable declaration cannot have template without id and type: "

#define VAR_ERR_TYP "[Variable]: Expected return value type got: "

#define VAR_ERR_VAL "[Variable]: Invalid value"

#define VAR_ERR_PER "[Variable]: Expected Type got: '...'"
enum class Token: int;
string to_string(Token enumerator);
struct Token_t;
enum class VariableState: int;
string to_string(VariableState enumerator);
struct AstToken;
struct CompilerPath;
struct Variable;
struct EnumValue;
struct Enum;
struct Include;
struct Uses;
struct Get;
struct Global;
struct Struct;
struct For;
struct ConditionalExpression;
struct Condition;
struct Select;
struct MatchLines;
struct MatchDef;
struct Expression;
struct Function;
struct Class;
struct Program;
struct Compiler;
struct MapOperator;
struct Map;
enum class MessageSeverity: int;
string to_string(MessageSeverity enumerator);
struct FpFn;
enum class EnumError: int;
string to_string(EnumError enumerator);
enum class ConditionError: int;
string to_string(ConditionError enumerator);
struct VariableNBool;
enum class ClassError: int;
string to_string(ClassError enumerator);
struct CompileOutput;
string to_string(string value);
template <typename T>
Option<T> Some(T value);
template <typename T>
Option<T> None();
template <typename T>
Option<T> None(T value);
template <typename T>
void print(T s);
template <typename T>
void println(T s);
bool is_char_number(char ch);
Option<int> char_to_number(char ch);
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
template <typename T>
string to_string(List<T> list);
Option<string> read(string path);
vector<string> readlines(string path);
void write(string content, string path);
void _system(string command);
bool system(string command);
vector<string> system_output(string command);
void system_output(string command, vector<string>* output);
void remove(string path);
bool makedir(string name);
bool changedir(string name);
Option<string> env(string env_var);
Option<string> home_env();
vector<string> list_reg_files(string path);
vector<string> list_dirs(string path);
vector<string> list_files(string path);
string variable_state_to_cpp(VariableState self);
string expr_to_cpp(Expression* self, int indent);
void colored(MessageSeverity severity, string msg, string recap);
void display_message(MessageSeverity severity, string msg, string recap);
void hint(string msg);
void error(string msg, string recap);
AstToken next_or_exit(Compiler* compiler_t, string s);
bool try_get(Compiler* compiler_t, Token token);
string get_or_exit(Compiler* compiler_t, Token token, string s);
string id_or_exit(Compiler* compiler_t, string s);
string eq_or_exit(Compiler* compiler_t, string s);
string arrow_or_exit(Compiler* compiler_t, string s);
FpFn folder_and_name(string file_path);
Compiler temp_compiler(string emulated_str);
string get_file_path(int argc, char** argv);
string get_content(CompilerPath paths, bool can_be_lib);
string resolve_get_path(string local_path, string lib_name);
void write_program(string program, CompilerPath paths);
char* to_char_arr(string s, char* buf);
void compile_program(CompilerPath paths, vector<string> arguments, bool is_release);
bool next_is_none(Peekable<char> &peekable);
Option<string> try_get_pair(Peekable<char> &peekable, char c);
Option<string> try_get_concat(Peekable<char> &peekable, char c);
Option<string> try_get_matching(Peekable<char> &peekable, char c);
void try_append_raw(Peekable<char> &peekable, vector<AstToken> &ast);
Option<AstToken> try_get_num(Peekable<char> &peekable, char c);
Option<AstToken> try_get_single_char_token(Peekable<char> &peekable, char c);
Option<AstToken> try_get_white_space(Peekable<char> &peekable, char c);
bool is_white_space(char c);
bool is_both_token(string id, char c);
Option<string> try_get_advanced_condition(Peekable<char> &peekable, string id, char c);
vector<AstToken> ast_create(string content);
vector<AstToken> ast_create(string content, int line_offset);
string try_add_token(string id, vector<AstToken> &ast, Peekable<char> &peekable, int &line);
bool is_str_tokens(string s);
bool is_char_token(char ch);
bool is_char_number_t(char ch);
Option<string> try_get_dbl(Peekable<char>* peekable, char ch);
string get_pair(Peekable<char>* peekable, char ch, char endch);
string get_matching(Peekable<char>* peekable, char ch);
string get_concat(Peekable<char>* peekable);
AstToken collect_num(Peekable<char>* peekable, char ch);
string try_collect_raw(Peekable<char>* peekable);
vector<string> imports_construct(Compiler* compiler_t);
vector<string> imports_construct_impl(Compiler* compiler_t);
vector<string> imports_creation(Compiler* compiler_t, AstToken next);
bool imports_check_duplicate(vector<string> imports, string id);
string e_err(EnumError err);
string e_err(EnumError err, string opt);
string e_err(EnumError err, string opt, bool display, string recap);
void validate_enum(Enum enumerator, Compiler* compiler_t);
Enum enums_construct(Compiler* compiler_t);
Expression for_construct(Compiler* compiler_t, bool is_foreach);
Expression expression_construct(Compiler* compiler_t, AstToken first);
Expression expression_construct(Compiler* compiler_t, AstToken first, bool is_match);
Expression get_let_expr(Compiler* compiler_t);
Expression get_lambda_expr(Compiler* compiler_t);
Expression match_construct(Compiler* compiler_t);
Expression match_construct(Compiler* compiler_t, Option<string> id, bool is_let);
string match_statements(Compiler* compiler_t);
string match_adv_statements(Compiler* compiler_t, Token adv);
MatchLines match_lines(Compiler* compiler_t);
Expression map_construct(Compiler* compiler_t, string id, bool is_let);
MapOperator map_operator_construct(Compiler* compiler_t, Token operator_type);
MapOperator map_operator_construct_internal(Compiler* compiler_t, Token operator_type);
Expression switch_construct(Compiler* compiler_t);
vector<Expression> create_case(Compiler* compiler_t, bool is_default);
Expression select_construct(Compiler* compiler_t);
string co_err(ConditionError err);
string co_err(ConditionError err, string opt);
string co_err(ConditionError err, string opt, bool display, string recap);
Expression condition_construct(Compiler* compiler_t, string condition_type);
void adv_conditional_construct(Compiler* compiler_t, ConditionalExpression* expr, AstToken token);
Option<string> get_value(Compiler* compiler_t, bool found_setter);
Option<string> get_value(Compiler* compiler_t, bool found_setter, bool in_args);
Variable get_type(Compiler* compiler_t);
VariableNBool construct_args(Compiler* compiler_t);
VariableNBool construct_args(Compiler* compiler_t, bool is_func);
VariableNBool construct_args(Compiler* compiler_t, Option<string> type_name);
VariableNBool construct_args(Compiler* compiler_t, Option<string> type_name, bool is_func);
vector<string> template_construct(Compiler* compiler_t);
bool same_signature(Function a, Function b);
void validate_function(Function function, Compiler* compiler_t);
Function function_construct(Compiler* compiler_t, VariableState state, bool constr);
Function function_construct(Compiler* compiler_t, VariableState state, bool constr, vector<Variable> variables);
Function function_construct(Compiler* compiler_t, VariableState state, bool constr, vector<Variable> variables, bool is_member);
string c_err(ClassError err);
string c_err(ClassError err, string opt);
string c_err(ClassError err, string opt, bool display, string recap);
void class_validate(Class class_def, Compiler* compiler_t);
void class_validate_function(Class* class_def, Function function, Compiler* compiler_t);
Class class_construct(Compiler* compiler_t, bool is_struct, CompilerPath paths);
void class_internal_declarations(Compiler* compiler_t, bool is_struct, Class* class_def, CompilerPath paths);
Global global_construct(Compiler* compiler_t);
vector<Variable> get_variables(Compiler* compiler_t);
void try_add_variable(Compiler* compiler_t, Global* global, Variable variable);
int main(int argc, char* argv[]);
CompileOutput compile_main(CompilerPath paths, Program* p);
CompileOutput compile(CompilerPath paths, Program* p, bool is_main);
void validate_compiled(Compiler compiler, bool is_main);
string to_string(string value) {
   
return  value;
}
template <typename T>
struct Option {
 private:
   T _value;
   bool _forced_none = true;
 public:
   bool is_none() {
      
return  &_value== nullptr|| _forced_none;
   }
   bool is_some() {
      
return ! is_none ();
   }
   T value_or(T value) {
      
return  is_some () ? _value: value;
   }
   T value_unsafe() {
      
return  _value;
   }
   string to_string() {
      
return  is_some () ?"Some("+ std:: to_string (_value)+")":"None";
   }
template <typename Func, typename ...Args>
   void select_it(Func func, Args... args) {
         if(is_none ()    ) {
            
return ;
}
      func (_value, args...);
   }
   Option () {
      _forced_none=true;
   }
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
template <typename T>
Option<T> None(T value) {
   
return  Option< T> ();
}
template <typename T>
struct Peekable {
 private:
   vector<T> _values = {};
   int _index = 0;
 public:
   Peekable () {
      
return ;
   }
   Peekable (vector<T> values) {
      _values= values;
   }
   Peekable (string text) {
         for(int c_iterator = 0; c_iterator < text.size(); c_iterator++) {
auto c = text.at(c_iterator);            _values. push_back (c);
}
   }
   int index() {
      
return  _index;
   }
   int size() {
      
return  _values. size ();
   }
   bool is_end() {
      
return  _index> _values. size ()- 1;
   }
   bool is_begin() {
      
return  _index== 0;
   }
   Option<T> at(int at) {
      
return  at< _values. size () ? Some (_values.at(at)): None< T> ();
   }
   Option<T> prev() {
      
return ! is_begin () ? at (--_index): None< T> ();
   }
   Option<T> peek_prev() {
      
return ! is_begin () ? at (_index - 1): None< T> ();
   }
   Option<T> next() {
      
return ! is_end () ? at (_index++): None< T> ();
   }
   Option<T> peek() {
      
return ! is_end () ? at (_index): None< T> ();
   }
};
template <typename T>
void print(T s) {
   
 cout<< s;
}
template <typename T>
void println(T s) {
   
 cout<< s<<"\n";
}
class String {
 private:
   string _value;
 public:
   String () {
      
return ;
   }
   String (string value) {
      
 this-> _value= value;
   }
   String operator+(string text) {
      
return  String (_value + text);
   }
   String operator+(char ch) {
      
return  String (_value + string(1, ch));
   }
   char operator[](int at) {
      
return  _value. at (at);
   }
   bool operator==(string other) {
      
return  _value== other;
   }
   bool operator!=(string other) {
      
return  _value!= other;
   }
   bool operator==(String other) {
      
return  _value== other. to_string ();
   }
   bool operator!=(String other) {
      
return  _value!= other. to_string ();
   }
   string to_string() {
      
return  _value;
   }
   long len() {
      
return  _value. size ();
   }
   auto at(int at) {
      
return  _value. at (at);
   }
   void append(string value) {
      
 _value+= value;
   }
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
      updated+= _value. substr (at);
      _value= updated;
   }
   void remove_back(int amount) {
         for(int i = 0; i < amount; i++) {
               if(i  >= len ()  ) {
                  
return ;
}
            remove (len() - 1);
}
   }
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
   void remove_word(int at) {
      
 remove_word (at, false);
   }
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
            ch= _value. at (at);
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
            ch= _value. at (at);
               if(ch  != ' '  ) {
                  
return ;
}
            remove (at);
}
   }
   string pop() {
      
return  substr (0, _value.size() - 1);
   }
   string to_upper() {
         auto  upper = _value;
         for(int i = 0; i < upper.size(); i++) {
            
 upper[ i]= toupper (upper[i]);
}
      return  upper;
   }
   string to_lower() {
         auto  lower = _value;
         for(int i = 0; i < lower.size(); i++) {
            
 lower[ i]= tolower (lower[i]);
}
      return  lower;
   }
   string strip() {
      
return  strip (None<int>());
   }
   string strip(int times) {
      
return  strip (Some(times));
   }
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
                     if(stripped . size ()  == 0  ) {
                        
 break;
}
                     if(any (stripped.back(), {' ', '\n', '\t'})    ) {
                        stripped= stripped. substr (0, stripped.size()-1);
}
                     else {
                        
 rhs=true;
}
}
               if(! lhs    ) {
                     if(stripped . size ()  == 0  ) {
                        
 break;
}
                     if(any (stripped[0], {' ', '\n', '\t'})    ) {
                        stripped= stripped. substr (1);
}
                     else {
                        
 lhs=true;
}
}
}
      return  stripped;
   }
   string strip_end() {
      
return  strip_end (None<int>());
   }
   string strip_end(int times) {
      
return  strip_end (Some(times));
   }
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
               if(stripped . size ()  == 0  ) {
                  
 break;
}
               if(none (stripped.back(), {' ', '\n', '\t'})    ) {
                  
 break;
}
            stripped= stripped. substr (0, stripped.size()-1);
}
      return  stripped;
   }
   string strip_front() {
      
return  strip_front (None<int>());
   }
   string strip_front(int times) {
      
return  strip_front (Some(times));
   }
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
               if(stripped . size ()  == 0  ) {
                  
 break;
}
               if(none (stripped[0], {' ', '\n', '\t'})    ) {
                  
 break;
}
            stripped= stripped. substr (1);
}
      return  stripped;
   }
   string replace(string from, string to) {
      string replaced= _value;
      size_t last= 0;
         while(true   ) {
            size_t start_pos= replaced. find (from, last);
               if(start_pos  == - 1  ) {
                  
return  replaced;
}
            replaced. replace (start_pos, from.length(), to);
            last= start_pos+ 1;
}
   }
   String* replace_into(string from, string to) {
      string replaced= _value;
      size_t last= 0;
         while(true   ) {
            size_t start_pos= replaced. find (from, last);
               if(start_pos  == - 1  ) {
                   _value= replaced;
break ;
}
            replaced. replace (start_pos, from.length(), to);
            last= start_pos+ 1;
}
      return  this;
   }
   string replace(string from, string to, int amount) {
      string replaced= _value;
      size_t last= 0;
         for(int i = 0; i < amount; i++) {
            size_t start_pos= replaced. find (from, last);
               if(start_pos  == - 1  ) {
                  
return  replaced;
}
            replaced. replace (start_pos, from.length(), to);
            last= start_pos+ 1;
}
      return  replaced;
   }
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
   vector<string> split() {
      
return  split (None<char>());
   }
   vector<string> split(char delimiter) {
      
return  split (Some(delimiter));
   }
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
            split. push_back (splitting.substr(0, found));
            splitting= splitting. substr (found + 1);
}
      split. push_back (splitting);
      return  split;
   }
   bool contains(string contains) {
      
return  _value. find (contains)!=- 1;
   }
   bool starts_with(string start) {
      
return  _value. rfind (start, 0)== 0;
   }
   bool ends_with(string ends) {
         if(ends . size ()  > len ()  ) {
            
return false;
}
         if(ends . size ()  == len ()  ) {
            
return  ends== _value;
}
         auto  sub = substr(_value.size() - ends.size());
      return  sub== ends;
   }
   string substr(int start) {
      
return  _value. substr (start);
   }
   string substr(int start, int end) {
      
return  _value. substr (start, end);
   }
   Option<int> find(int from, string key) {
         if(from + 1  >= len ()  ) {
            
return  None<int> ();
}
         auto  s = _value.substr(from + 1);
         auto  found = s.find(key);
      return  found!=- 1 ? Some ((int)found + 1): None<int> ();
   }
   Option<int> find_non_alpha(int from, bool reverse) {
      return  reverse ? find_non_alpha_reverse (from): find_non_alpha (from);
   }
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
   Option<int> find_alpha(int from, bool reverse) {
      return  reverse ? find_alpha_reverse (from): find_alpha (from);
   }
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
   string escape() {
      string buf="";
         for(int c_iterator = 0; c_iterator < _value.size(); c_iterator++) {
auto c = _value.at(c_iterator);               if(c  == '"'  ) {
                  
 buf+='\\';
}
            buf+= c;
}
      return  String (buf). replace ("\n", "\\n");
   }
   string unescape() {
         auto  s = replace("\\n", "\n");
         string  buf = "";
         int  i = 0;
         for(int c_iterator = 0; c_iterator < s.size(); c_iterator++) {
auto c = s.at(c_iterator);            i++;
               if(i  < s . size () - 1  &&s . at (i)  == '"'  ) {
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
struct Clap {
 private:
   int _argc = 0;
   char** _argv;
 public:
   Option<string> at(int index) {
         if(index  >= _argc  ) {
            
return  None<string> ();
}
      return  Some ((string)_argv[index]);
   }
   bool has(string check) {
         for(int i = 0; i < _argc; i++) {
               if(_argv [ i ]  == check  ) {
                  
return true;
}
}
      return false;
   }
   Option<string> peek(string check) {
         for(int i = 0; i < _argc; i++) {
               if(_argv [ i ]  != check  ) {
                  
 continue;
}
               if(i  > _argc - 2  ) {
                  
 break;
}
            return  (string) _argv[ i+ 1];
}
      return  None<string> ();
   }
   Clap (int argc, char** argv) {
      _argc= argc;
      _argv= argv;
   }
};
template <typename T>
class List {
 private:
   vector<T> _list = {};
 public:
   List () {
      
return ;
   }
   List (vector<T> list) {
      
 _list= list;
   }
   T operator[](int at) {
      
return  _list[ at];
   }
   T at(int at) {
      
return  _list. at (at);
   }
   T* at_ptr(int at) {
      
return  &_list. at (at);
   }
   void set(int at, T val) {
      
 _list. at (at)= val;
   }
   Option<T> first() {
      
return  at (0);
   }
   Option<T> last() {
      
return  at (len()-1);
   }
   auto begin() {
      
return  _list. begin ();
   }
   auto end() {
      
return  _list. end ();
   }
   int len() {
      
return  _list. size ();
   }
   int size() {
      
return  _list. size ();
   }
   void add(T ele) {
      
 _list. push_back (ele);
   }
   void pop() {
      
 remove (len()-1);
   }
   void clear() {
      
 _list. clear ();
   }
   vector<T> as_vec() {
      
return  _list;
   }
   vector<T>* as_vec_ptr() {
      
return  &_list;
   }
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
                  
 buf. push_back (element);
}
            buf. push_back (ele);
            i++;
}
      clear ();
      _list= buf;
   }
   void remove(int index) {
         if(len ()  == 0  ) {
            
return ;
}
      vector< T> buf= {};
         int  i = 0;
         for(int ele_iterator = 0; ele_iterator < _list.size(); ele_iterator++) {
auto ele = _list.at(ele_iterator);               if(i  != index  ) {
                  
 buf. push_back (ele);
}
            i++;
}
      clear ();
      _list= buf;
   }
template <typename Func, typename ...Args>
   void select_it(Func func, Args... args) {
         for(int ele_iterator = 0; ele_iterator < _list.size(); ele_iterator++) {
auto ele = _list.at(ele_iterator);            
 func (ele, args...);
}
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
Option<string> read(string path) {
   string content, linebuf;
   ifstream reader (path);
      if(! reader    ) {
         
return  None<string> ();
}
      while(! reader . eof ()    ) {
         getline (reader, linebuf);
         content+= linebuf+"\n";
}
   reader. close ();
      if(content  == ""  ) {
         
return  None<string> ();
}
   return  Some (content);
}
vector<string> readlines(string path) {
   vector<string> lines= {};
      auto  content_opt = read(path);
      if(content_opt . is_none ()    ) {
         
return  lines;
}
      auto  content = content_opt.value_or("");
   int start= 0;
   int end= content. find ("\n");
      while(end  != - 1  ) {
         lines. push_back (content.substr(start, end - start));
         start= end+ 1;
         end= content. find ("\n", start);
}
   lines. push_back (content.substr(start, end - start));
   return  lines;
}
void write(string content, string path) {
   ofstream file (path);
   file<< content;
   file. close ();
}
void _system(string command) {
      if(! system (command.c_str())    ) {
         
 print ("");
}
}
bool system(string command) {
   
return ! system (command.c_str());
}
vector<string> system_output(string command) {
   vector<string> output= {};
   system_output (command, &output);
   return  output;
}
void system_output(string command, vector<string>* output) {
   char buffer[ 1064];
      auto  fp = popen(command.c_str(), "r");
      while(fgets (buffer, sizeof(buffer), fp)    ) {
         
 output-> push_back (buffer);
}
   pclose (fp);
}
void remove(string path) {
   
 remove (path.c_str());
}
bool makedir(string name) {
#ifdef _WIN32
   return ! mkdir (name.c_str());
#else
   return ! mkdir (name.c_str(), S_IRWXU);
#endif
}
bool changedir(string name) {
   
return  chdir (name.c_str())>= 0;
}
Option<string> env(string env_var) {
      auto  e = getenv(env_var.c_str());
      if(e  == NULL  ) {
         
return  None<string> ();
}
   return  Some ((string)e);
}
Option<string> home_env() {
#ifdef _WIN32
   return  env ("USERPROFILE");
#else
   return  env ("HOME");
#endif
}
vector<string> list_reg_files(string path) {
   vector<string> files= {};
   struct dirent* diread;
      auto  dir = opendir(path.c_str());
      if(dir  == nullptr  ) {
         
return  files;
}
      while((diread = readdir(dir))  != nullptr  ) {
            if(diread -> d_type  != DT_REG  ) {
               
 continue;
}
         files. push_back (diread->d_name);
}
   closedir (dir);
   sort (files.begin(), files.end());
   return  files;
}
vector<string> list_dirs(string path) {
   vector<string> files= {};
   struct dirent* diread;
      auto  dir = opendir(path.c_str());
      if(dir  == nullptr  ) {
         
return  files;
}
      while((diread = readdir(dir))  != nullptr  ) {
            if(diread -> d_type  != DT_DIR  ) {
               
 continue;
}
         files. push_back (diread->d_name);
}
   closedir (dir);
   sort (files.begin(), files.end());
   return  files;
}
vector<string> list_files(string path) {
   vector<string> files= {};
   struct dirent* diread;
      auto  dir = opendir(path.c_str());
      if(dir  == nullptr  ) {
         
return  files;
}
      while((diread = readdir(dir))  != nullptr  ) {
         
 files. push_back (diread->d_name);
}
   closedir (dir);
   sort (files.begin(), files.end());
   return  files;
}
enum class Token: int {
   AllEquals,
   AllLessOrEquals,
   AllLessThan,
   AllMoreOrEquals,
   AllMoreThan,
   AllNotEquals,
   And,
   AnyEquals,
   Asterix,
   Bang,
   Case,
   Char,
   Class,
   Colon,
   Comma,
   Comment,
   Compiler,
   Condition,
   Const,
   CoolArrow,
   DblColon,
   DblLessThan,
   DblMoreThan,
   Default,
   Do,
   Dobr,
   Doco,
   Dore,
   Doremi,
   Enum,
   Eof,
   Equality,
   Equals,
   Extend,
   False,
   Float,
   For,
   Foreach,
   ForwardSlash,
   From,
   Function,
   Get,
   Global,
   Id,
   In,
   Include,
   LBlock,
   LBrack,
   LessThan,
   LessThanOrEquals,
   Let,
   LParen,
   MacroDefinition,
   Map,
   Match,
   MoreThan,
   MoreThanOrEquals,
   New,
   Named,
   NewLine,
   NonEquality,
   Number,
   Or,
   Period,
   DoublePeriod,
   TriplePeriod,
   Pointer,
   Private,
   Protected,
   Public,
   Raw,
   RBlock,
   RBrack,
   Return,
   RParen,
   SemiColon,
   Static,
   String,
   Struct,
   Sub,
   Sum,
   Switch,
   Select,
   True,
   Type,
   Until,
   Use,
   UNKNOWN,
   Virtual,
   Where,
};
string to_string(Token enumerator) {
switch (enumerator) {
case Token::AllEquals: return "AllEquals";
case Token::AllLessOrEquals: return "AllLessOrEquals";
case Token::AllLessThan: return "AllLessThan";
case Token::AllMoreOrEquals: return "AllMoreOrEquals";
case Token::AllMoreThan: return "AllMoreThan";
case Token::AllNotEquals: return "AllNotEquals";
case Token::And: return "And";
case Token::AnyEquals: return "AnyEquals";
case Token::Asterix: return "Asterix";
case Token::Bang: return "Bang";
case Token::Case: return "Case";
case Token::Char: return "Char";
case Token::Class: return "Class";
case Token::Colon: return "Colon";
case Token::Comma: return "Comma";
case Token::Comment: return "Comment";
case Token::Compiler: return "Compiler";
case Token::Condition: return "Condition";
case Token::Const: return "Const";
case Token::CoolArrow: return "CoolArrow";
case Token::DblColon: return "DblColon";
case Token::DblLessThan: return "DblLessThan";
case Token::DblMoreThan: return "DblMoreThan";
case Token::Default: return "Default";
case Token::Do: return "Do";
case Token::Dobr: return "Dobr";
case Token::Doco: return "Doco";
case Token::Dore: return "Dore";
case Token::Doremi: return "Doremi";
case Token::Enum: return "Enum";
case Token::Eof: return "Eof";
case Token::Equality: return "Equality";
case Token::Equals: return "Equals";
case Token::Extend: return "Extend";
case Token::False: return "False";
case Token::Float: return "Float";
case Token::For: return "For";
case Token::Foreach: return "Foreach";
case Token::ForwardSlash: return "ForwardSlash";
case Token::From: return "From";
case Token::Function: return "Function";
case Token::Get: return "Get";
case Token::Global: return "Global";
case Token::Id: return "Id";
case Token::In: return "In";
case Token::Include: return "Include";
case Token::LBlock: return "LBlock";
case Token::LBrack: return "LBrack";
case Token::LessThan: return "LessThan";
case Token::LessThanOrEquals: return "LessThanOrEquals";
case Token::Let: return "Let";
case Token::LParen: return "LParen";
case Token::MacroDefinition: return "MacroDefinition";
case Token::Map: return "Map";
case Token::Match: return "Match";
case Token::MoreThan: return "MoreThan";
case Token::MoreThanOrEquals: return "MoreThanOrEquals";
case Token::New: return "New";
case Token::Named: return "Named";
case Token::NewLine: return "NewLine";
case Token::NonEquality: return "NonEquality";
case Token::Number: return "Number";
case Token::Or: return "Or";
case Token::Period: return "Period";
case Token::DoublePeriod: return "DoublePeriod";
case Token::TriplePeriod: return "TriplePeriod";
case Token::Pointer: return "Pointer";
case Token::Private: return "Private";
case Token::Protected: return "Protected";
case Token::Public: return "Public";
case Token::Raw: return "Raw";
case Token::RBlock: return "RBlock";
case Token::RBrack: return "RBrack";
case Token::Return: return "Return";
case Token::RParen: return "RParen";
case Token::SemiColon: return "SemiColon";
case Token::Static: return "Static";
case Token::String: return "String";
case Token::Struct: return "Struct";
case Token::Sub: return "Sub";
case Token::Sum: return "Sum";
case Token::Switch: return "Switch";
case Token::Select: return "Select";
case Token::True: return "True";
case Token::Type: return "Type";
case Token::Until: return "Until";
case Token::Use: return "Use";
case Token::UNKNOWN: return "UNKNOWN";
case Token::Virtual: return "Virtual";
case Token::Where: return "Where";
default: return "UNKNOWN TYPE";
}};
struct Token_t {
 public:
   Token t = Token::Id;
 public:
   Token_t (string s) {
         auto  S = String(s);
         if(S . starts_with (QUOTE)    ) {
            
 t= Token:: String;
return ;
}
         else if(S . starts_with ("'")    ) {
            
 t= Token:: Char;
return ;
}
         else if(any (s, {TOKEN_WHILE, TOKEN_LOOP})    ) {
            
 t= Token:: Condition;
return ;
}
         else if(any (s, {TOKEN_IFS, TOKEN_ELIF, TOKEN_ELSE})    ) {
            
 t= Token:: Condition;
return ;
}
         else if(any (s, {TOKEN_ZERO, TOKEN_ONE, TOKEN_TWO})    ) {
            
 t= Token:: Number;
return ;
}
         else if(any (s, {TOKEN_THREE, TOKEN_FOUR, TOKEN_FIVE})    ) {
            
 t= Token:: Number;
return ;
}
         else if(any (s, {TOKEN_SIX, TOKEN_SEVEN, TOKEN_EIGHT, TOKEN_NINE})    ) {
            
 t= Token:: Number;
return ;
}
         else if(any (s, {TOKEN_INT, TOKEN_STR, TOKEN_STRING})    ) {
            
 t= Token:: Type;
return ;
}
{
   auto _match_expr_ = s;
if (_match_expr_ == TOKEN_ALLEQUALS)  {
      
 t= Token:: AllEquals;
return ;

}
else if (_match_expr_ == TOKEN_ALLLESSOREQUALS)  {
      
 t= Token:: AllLessOrEquals;
return ;

}
else if (_match_expr_ == TOKEN_ALLLESSTHAN)  {
      
 t= Token:: AllLessThan;
return ;

}
else if (_match_expr_ == TOKEN_ALLMOREOREQUALS)  {
      
 t= Token:: AllMoreOrEquals;
return ;

}
else if (_match_expr_ == TOKEN_ALLMORETHAN)  {
      
 t= Token:: AllMoreThan;
return ;

}
else if (_match_expr_ == TOKEN_ALLNOTEQUALS)  {
      
 t= Token:: AllNotEquals;
return ;

}
else if (_match_expr_ == TOKEN_AND)  {
      
 t= Token:: And;
return ;

}
else if (_match_expr_ == TOKEN_ANYEQUALS)  {
      
 t= Token:: AnyEquals;
return ;

}
else if (_match_expr_ == TOKEN_ASTERIX)  {
      
 t= Token:: Asterix;
return ;

}
else if (_match_expr_ == TOKEN_BANG)  {
      
 t= Token:: Bang;
return ;

}
else if (_match_expr_ == TOKEN_CASE)  {
      
 t= Token:: Case;
return ;

}
else if (_match_expr_ == TOKEN_CLASS)  {
      
 t= Token:: Class;
return ;

}
else if (_match_expr_ == TOKEN_COLON)  {
      
 t= Token:: Colon;
return ;

}
else if (_match_expr_ == TOKEN_COMMA)  {
      
 t= Token:: Comma;
return ;

}
else if (_match_expr_ == TOKEN_COMPILER)  {
      
 t= Token:: Compiler;
return ;

}
else if (_match_expr_ == TOKEN_CONST)  {
      
 t= Token:: Const;
return ;

}
else if (_match_expr_ == TOKEN_COOLARROW)  {
      
 t= Token:: CoolArrow;
return ;

}
else if (_match_expr_ == TOKEN_DBLCOLON)  {
      
 t= Token:: DblColon;
return ;

}
else if (_match_expr_ == TOKEN_DBLLESSTHAN)  {
      
 t= Token:: DblLessThan;
return ;

}
else if (_match_expr_ == TOKEN_DBLMORETHAN)  {
      
 t= Token:: DblMoreThan;
return ;

}
else if (_match_expr_ == TOKEN_DEFAULT)  {
      
 t= Token:: Default;
return ;

}
else if (_match_expr_ == TOKEN_DO)  {
      
 t= Token:: Do;
return ;

}
else if (_match_expr_ == TOKEN_DOBR)  {
      
 t= Token:: Dobr;
return ;

}
else if (_match_expr_ == TOKEN_DOCO)  {
      
 t= Token:: Doco;
return ;

}
else if (_match_expr_ == TOKEN_DORE)  {
      
 t= Token:: Dore;
return ;

}
else if (_match_expr_ == TOKEN_DOREMI)  {
      
 t= Token:: Doremi;
return ;

}
else if (_match_expr_ == TOKEN_ENUM)  {
      
 t= Token:: Enum;
return ;

}
else if (_match_expr_ == TOKEN_EOF)  {
      
 t= Token:: Eof;
return ;

}
else if (_match_expr_ == TOKEN_EQUALITY)  {
      
 t= Token:: Equality;
return ;

}
else if (_match_expr_ == TOKEN_EQUALS)  {
      
 t= Token:: Equals;
return ;

}
else if (_match_expr_ == TOKEN_EXTEND)  {
      
 t= Token:: Extend;
return ;

}
else if (_match_expr_ == TOKEN_FALSE)  {
      
 t= Token:: False;
return ;

}
else if (_match_expr_ == TOKEN_FOR)  {
      
 t= Token:: For;
return ;

}
else if (_match_expr_ == TOKEN_FOREACH)  {
      
 t= Token:: Foreach;
return ;

}
else if (_match_expr_ == TOKEN_FORWARDSLASH)  {
      
 t= Token:: ForwardSlash;
return ;

}
else if (_match_expr_ == TOKEN_FROM)  {
      
 t= Token:: From;
return ;

}
else if (_match_expr_ == TOKEN_FUNCTION)  {
      
 t= Token:: Function;
return ;

}
else if (_match_expr_ == TOKEN_GET)  {
      
 t= Token:: Get;
return ;

}
else if (_match_expr_ == TOKEN_GLOBAL)  {
      
 t= Token:: Global;
return ;

}
else if (_match_expr_ == TOKEN_IN)  {
      
 t= Token:: In;
return ;

}
else if (_match_expr_ == TOKEN_INCLUDE)  {
      
 t= Token:: Include;
return ;

}
else if (_match_expr_ == TOKEN_LBLOCK)  {
      
 t= Token:: LBlock;
return ;

}
else if (_match_expr_ == TOKEN_LBRACK)  {
      
 t= Token:: LBrack;
return ;

}
else if (_match_expr_ == TOKEN_LESSTHAN)  {
      
 t= Token:: LessThan;
return ;

}
else if (_match_expr_ == TOKEN_LESSTHANOREQUALS)  {
      
 t= Token:: LessThanOrEquals;
return ;

}
else if (_match_expr_ == TOKEN_LET)  {
      
 t= Token:: Let;
return ;

}
else if (_match_expr_ == TOKEN_LINE_COMMENT)  {
      
 t= Token:: Comment;
return ;

}
else if (_match_expr_ == TOKEN_LPAREN)  {
      
 t= Token:: LParen;
return ;

}
else if (_match_expr_ == TOKEN_MACRODEFINITION)  {
      
 t= Token:: MacroDefinition;
return ;

}
else if (_match_expr_ == TOKEN_MAP)  {
      
 t= Token:: Map;
return ;

}
else if (_match_expr_ == TOKEN_MATCH)  {
      
 t= Token:: Match;
return ;

}
else if (_match_expr_ == TOKEN_MORETHAN)  {
      
 t= Token:: MoreThan;
return ;

}
else if (_match_expr_ == TOKEN_MORETHANOREQUALS)  {
      
 t= Token:: MoreThanOrEquals;
return ;

}
else if (_match_expr_ == TOKEN_NAMED)  {
      
 t= Token:: Named;
return ;

}
else if (_match_expr_ == TOKEN_NEW)  {
      
 t= Token:: New;
return ;

}
else if (_match_expr_ == TOKEN_NEWLINE)  {
      
 t= Token:: NewLine;
return ;

}
else if (_match_expr_ == TOKEN_NONEQUALITY)  {
      
 t= Token:: NonEquality;
return ;

}
else if (_match_expr_ == TOKEN_OR)  {
      
 t= Token:: Or;
return ;

}
else if (_match_expr_ == TOKEN_PERIOD)  {
      
 t= Token:: Period;
return ;

}
else if (_match_expr_ == TOKEN_DOUBLE_PERIOD)  {
      
 t= Token:: DoublePeriod;
return ;

}
else if (_match_expr_ == TOKEN_TRIPLE_PERIOD)  {
      
 t= Token:: TriplePeriod;
return ;

}
else if (_match_expr_ == TOKEN_POINTER)  {
      
 t= Token:: Pointer;
return ;

}
else if (_match_expr_ == TOKEN_PRIVATE)  {
      
 t= Token:: Private;
return ;

}
else if (_match_expr_ == TOKEN_PROTECTED)  {
      
 t= Token:: Protected;
return ;

}
else if (_match_expr_ == TOKEN_PUBLIC)  {
      
 t= Token:: Public;
return ;

}
else if (_match_expr_ == TOKEN_RAW)  {
      
 t= Token:: Raw;
return ;

}
else if (_match_expr_ == TOKEN_RBLOCK)  {
      
 t= Token:: RBlock;
return ;

}
else if (_match_expr_ == TOKEN_RBRACK)  {
      
 t= Token:: RBrack;
return ;

}
else if (_match_expr_ == TOKEN_RETURN)  {
      
 t= Token:: Return;
return ;

}
else if (_match_expr_ == TOKEN_RPAREN)  {
      
 t= Token:: RParen;
return ;

}
else if (_match_expr_ == TOKEN_SEMICOLON)  {
      
 t= Token:: SemiColon;
return ;

}
else if (_match_expr_ == TOKEN_SELECT)  {
      
 t= Token:: Select;
return ;

}
else if (_match_expr_ == TOKEN_STATIC)  {
      
 t= Token:: Static;
return ;

}
else if (_match_expr_ == TOKEN_STRUCT)  {
      
 t= Token:: Struct;
return ;

}
else if (_match_expr_ == TOKEN_SUB)  {
      
 t= Token:: Sub;
return ;

}
else if (_match_expr_ == TOKEN_SUM)  {
      
 t= Token:: Sum;
return ;

}
else if (_match_expr_ == TOKEN_SWITCH)  {
      
 t= Token:: Switch;
return ;

}
else if (_match_expr_ == TOKEN_TRUE)  {
      
 t= Token:: True;
return ;

}
else if (_match_expr_ == TOKEN_UNTIL)  {
      
 t= Token:: Until;
return ;

}
else if (_match_expr_ == TOKEN_USE)  {
      
 t= Token:: Use;
return ;

}
else if (_match_expr_ == TOKEN_VIRTUAL)  {
      
 t= Token:: Virtual;
return ;

}
else if (_match_expr_ == TOKEN_WHERE)  {
      
 t= Token:: Where;
return ;

}
else {
      
 t= Token:: Id;
return ;

}
}
   }
   bool is_id() {
      
return  t== Token:: Id;
   }
   bool is_nl() {
      
return  t== Token:: NewLine;
   }
   bool is_bool() {
      
return  any (t, {Token::False, Token::True});
   }
   bool is_num() {
      
return  t== Token:: Number;
   }
   bool is_float() {
      
return  t== Token:: Float;
   }
   bool is_char() {
      
return  t== Token:: Char;
   }
   bool is_string() {
      
return  t== Token:: String;
   }
   bool is_classy() {
      
return  any (t, {Token::Class, Token::Struct});
   }
   bool is_terminator() {
      
return  any (t, {Token::SemiColon, Token::Eof});
   }
   bool is_base() {
         switch(t    ) {
            case Token::Class:
            case Token::Compiler:
            case Token::Enum:
            case Token::Eof:
            case Token::Function:
            case Token::Get:
            case Token::Global:
            case Token::Include:
            case Token::MacroDefinition:
            case Token::Named:
            case Token::NewLine:
            case Token::SemiColon:
            case Token::Struct:
            case Token::Raw:
            case Token::Use:
            
return true;
            default:
            
return false;
}
   }
   bool is_do() {
         switch(t    ) {
            case Token::Do:
            case Token::Dobr:
            case Token::Doco:
            case Token::Dore:
            case Token::Doremi:
            
return true;
            default:
            
return false;
}
   }
   bool is_adv_conditional() {
         switch(t    ) {
            case Token::AllEquals:
            case Token::AllLessOrEquals:
            case Token::AllLessThan:
            case Token::AllMoreOrEquals:
            case Token::AllMoreThan:
            case Token::AllNotEquals:
            case Token::AnyEquals:
            
return true;
            default:
            
return false;
}
   }
   bool is_conditional() {
         switch(t    ) {
            case Token::Equality:
            case Token::LessThan:
            case Token::LessThanOrEquals:
            case Token::MoreThan:
            case Token::MoreThanOrEquals:
            case Token::NonEquality:
            
return true;
            default:
            
return false;
}
   }
   bool is_conditional_sep() {
      
return  any (t, {Token::And, Token::Or});
   }
   bool valid_case() {
      
return  any (t, {Token::Id, Token::Number, Token::Char});
   }
   string as_str() {
      
return  to_string (t);
   }
};
enum class VariableState: int {
   Private,
   Protected,
   Public,
};
string to_string(VariableState enumerator) {
switch (enumerator) {
case VariableState::Private: return "Private";
case VariableState::Protected: return "Protected";
case VariableState::Public: return "Public";
default: return "UNKNOWN TYPE";
}};
string variable_state_to_cpp(VariableState self) {
      switch(self    ) {
         case VariableState::Private:
         
return  PRIVATE_STATE;
         case VariableState::Protected:
         
return  PROTECTED_STATE;
         case VariableState::Public:
         
return  PUBLIC_STATE;
         default:
         
return  PRIVATE_STATE;
}
}
struct AstToken {
 public:
   string name = EMPTY;
   Token token = Token::Id;
   Token_t t = Token_t("\n");
   int line = 0;
   int col = 0;
 public:
   AstToken () {
      
return ;
   }
   AstToken (string id) {
      this-> name= id;
      this-> t= Token_t (name);
      this-> token= t. t;
   }
   AstToken (char ch) {
      string buf (1,ch);
      this-> name= buf;
      this-> t= Token_t (name);
      this-> token= t. t;
   }
   string to_string() {
      
return "["+ name+"]: Token: "+ t. as_str ();
   }
   bool is_classy() {
      
return  t. is_classy ();
   }
   bool is_id() {
      
return  t. is_id ();
   }
   bool is_nl() {
      
return  t. is_nl ();
   }
   bool is_bool() {
      
return  t. is_bool ();
   }
   bool is_num() {
      
return  t. is_num ();
   }
   bool is_float() {
      
return  t. is_float ();
   }
   bool is_char() {
      
return  t. is_char ();
   }
   bool is_string() {
      
return  t. is_string ();
   }
   bool is_terminator() {
      
return  t. is_terminator ();
   }
   bool is_base() {
      
return  t. is_base ();
   }
   bool is_do() {
      
return  t. is_do ();
   }
   bool is_adv_conditional() {
      
return  t. is_adv_conditional ();
   }
   bool is_conditional() {
      
return  t. is_conditional ();
   }
   bool is_conditional_sep() {
      
return  t. is_conditional_sep ();
   }
   bool valid_case() {
      
return  t. valid_case ();
   }
};
struct CompilerPath {
 public:
   string folder_path = EMPTY;
   string file_path = EMPTY;
   string main_path = EMPTY;
   string main_path_cpp = EMPTY;
   string main_path_bin = EMPTY;
   string output = EMPTY;
   string current = EMPTY;
 public:
   CompilerPath (string main, string f_p, string f_n) {
         auto  main_str = String(main);
         auto  cpp = main_str.replace(HA_SUFFIX, CPP_SUFFIX);
         auto  bin = main_str.replace(HA_SUFFIX, EMPTY);
      this-> folder_path= f_p;
      this-> file_path= f_n;
      this-> main_path= main;
      this-> main_path_cpp= cpp;
      this-> main_path_bin= bin;
      this-> output= cpp+ COMPILER_OUT+ bin;
      this-> current= f_p+ f_n;
   }
};
struct Variable {
 public:
   string id = EMPTY;
   string v_type = EMPTY;
   Option<string> v_value = None<string>();
   bool staticness = false;
   bool constantness = false;
   VariableState variable_state = VariableState::Private;
 public:
   Variable () {
      
return ;
   }
   Variable (string id, string type) {
      this-> id= id;
      this-> v_type= type;
   }
   Variable (string id, string type, Option<string> value, VariableState state) {
      this-> id= id;
      this-> v_type= type;
      this-> v_value= value;
      this-> variable_state= state;
   }
   Variable (bool is_void) {
      this-> id= RETURN_VALUE_IDS;
      this-> v_type= VOID;
   }
   bool has_id() {
      
return  id. size ()!= 0;
   }
   bool has_type() {
      
return  v_type. size ()!= 0;
   }
   bool has_minimum() {
      
return  has_id ()&& has_type ();
   }
   string to_cpp(string spacing, string new_line) {
      string base= spacing+ v_type+ SPACE+ id;
         
{
auto v_optional_value = v_value;
if(v_optional_value.is_some()) {
auto v = v_optional_value.value_unsafe();
            
 base+= ASSIGNMENT+ v;
}

}
      base+= new_line;
      base= constantness ?"const " + to_string(base) + "": base;
      return  staticness ?"static " + to_string(base) + "": base;
   }
   string to_cpp(int indent, string new_line) {
         string  spacing = "";
         for(int i = 0; i < indent; i++) {
            
 spacing+= TAB;
}
      string base= spacing+ v_type+ SPACE+ id;
         
{
auto v_optional_value = v_value;
if(v_optional_value.is_some()) {
auto v = v_optional_value.value_unsafe();
            
 base+= ASSIGNMENT+ v;
}

}
      base+= new_line;
      base= constantness ?"const " + to_string(base) + "": base;
      return  staticness ?"static " + to_string(base) + "": base;
   }
};
struct EnumValue {
 public:
   string name = EMPTY;
   Option<string> value = None<string>();
 public:
   EnumValue () {
      
return ;
   }
};
struct Enum {
 public:
   string name = EMPTY;
   vector<EnumValue> enums = {};
 public:
   Enum (string enum_name) {
      this-> name= enum_name;
   }
   string to_cpp_string_start() {
      
return "string to_string(" + to_string(name) + " enumerator)";
   }
   string to_cpp_start() {
      
return "" + to_string(ENUM) + "" + to_string(name) + ": int";
   }
   string to_cpp_h() {
      
return  to_cpp_start ()+ LINE_END+ to_cpp_string_start ()+ LINE_END;
   }
   string to_cpp() {
         string  enum_str = "" + to_string(to_cpp_start()) + "" + to_string(BLOCK_START) + "";
         for(int e_iterator = 0; e_iterator < enums.size(); e_iterator++) {
auto e = enums.at(e_iterator);            enum_str+="" + to_string(TAB) + "" + to_string(e.name) + "";
               
{
auto e_val_optional_value = e.value;
if(e_val_optional_value.is_some()) {
auto e_val = e_val_optional_value.value_unsafe();
                  
 enum_str+="" + to_string(ASSIGNMENT) + "" + to_string(e_val) + "";
}

}
            enum_str+= ENUM_SEP;
}
      enum_str+="" + to_string(RBRACK) + "" + to_string(LINE_END) + "" + to_string(to_cpp_string_start()) + "" + to_string(BLOCK_START) + "";
      enum_str+="switch (enumerator) {\n";
         for(int e_iterator = 0; e_iterator < enums.size(); e_iterator++) {
auto e = enums.at(e_iterator);            enum_str+="case " + to_string(name) + "::" + to_string(e.name) + "";
            enum_str+=": return \"" + to_string(e.name) + "\";\n";
}
      enum_str+="default: return \"UNKNOWN TYPE\";\n}};\n";
      return  enum_str;
   }
};
struct Include {
 public:
   string include = EMPTY;
 public:
   Include (string include) {
      this-> include= include;
   }
   string to_cpp() {
         auto  is_quoted = String(include).starts_with(QUOTE);
      string include_str= INCLUDE;
      include_str+= is_quoted ? include: LARROW+ include+ RARROW;
      include_str+= NEWLINE;
      return  include_str;
   }
};
struct Uses {
 public:
   string usings = EMPTY;
 public:
   Uses (string usings) {
      this-> usings= usings;
   }
   string to_cpp() {
      
return  NAMESPACE+ usings+ LINE_END;
   }
};
struct Get {
 public:
   string get = EMPTY;
};
struct Global {
 public:
   vector<Variable> variables = {};
 public:
   Global () {
      
return ;
   }
   string to_cpp() {
         string  g_str = "";
         for(int v_iterator = 0; v_iterator < variables.size(); v_iterator++) {
auto v = variables.at(v_iterator);            g_str+="\n" + to_string(GLOBAL) + "" + to_string(v.v_type) + " " + to_string(v.id) + "\n";
}
      return  g_str;
   }
};
struct Struct {
 public:
   string id = EMPTY;
   vector<Variable> variables = {};
};
struct For {
 public:
   string iterator = EMPTY;
   Option<string> named_variable = None<string>();
   string until = EMPTY;
   vector<Expression> lines = {};
   bool is_foreach = false;
 public:
   For () {
      
return ;
   }
   For (bool is_foreach) {
      this-> is_foreach= is_foreach;
   }
   string to_cpp(int indent) {
         string  for_str = "";
      string iter= is_foreach&& named_variable. is_none () ?"" + to_string(iterator) + "_iterator": iterator;
      string to= is_foreach ?"" + to_string(until) + ".size()":until;
         for(int i = 0; i < indent; i++) {
            
 for_str+= TAB;
}
      for_str+="" + to_string(FOR_START) + "" + to_string(iter) + "" + to_string(FOR_MID) + "" + to_string(iter) + "" + to_string(FOR_UNTIL) + "" + to_string(to) + "";
      for_str+="" + to_string(FOR_AFTER_UNTIL) + "" + to_string(iter) + "" + to_string(FOR_END) + "";
         if(is_foreach    ) {
            for_str+="auto ";
            for_str+= named_variable. is_some () ? named_variable. value_or (""): iterator;
            for_str+=" = " + to_string(until) + ".at(" + to_string(iter) + ");";
}
         for(int i = 0; i < lines.size(); i++) {
            
 for_str+= expr_to_cpp (&lines.at(i), indent + 1);
}
      for_str+= BLOCK_END;
      return  for_str;
   }
};
struct ConditionalExpression {
 public:
   string value_left = EMPTY;
   string value_right = EMPTY;
   string operator_value = EMPTY;
   string continuation = EMPTY;
 public:
   ConditionalExpression () {
      
return ;
   }
   string to_cpp() {
         auto  expr_str = value_left+SPACE;
      expr_str+= operator_value+ SPACE;
      expr_str+= value_right+ SPACE+ continuation;
      return  expr_str;
   }
};
struct Condition {
 public:
   string conditioner = EMPTY;
   vector<ConditionalExpression> expressions = {};
   vector<Expression> lines = {};
 public:
   Condition () {
      
return ;
   }
   Condition (string conditioner) {
      this-> conditioner= conditioner;
   }
   void add_expr(ConditionalExpression cexpr) {
      
 expressions. push_back (cexpr);
   }
   string to_cpp(int indentation) {
         string  condition_str = "";
         for(int i = 0; i < indentation; i++) {
            
 condition_str+= TAB;
}
      condition_str+= conditioner;
         if(conditioner  != TOKEN_ELSE  ) {
            condition_str+= LPAREN;
               for(int expr_iterator = 0; expr_iterator < expressions.size(); expr_iterator++) {
auto expr = expressions.at(expr_iterator);                  
 condition_str+= expr. to_cpp ();
}
            condition_str+= RPAREN;
}
      condition_str+= BLOCK_START;
         for(int i = 0; i < lines.size(); i++) {
            
 condition_str+= expr_to_cpp (&lines.at(i), indentation + 1);
}
      condition_str+= BLOCK_END;
      return  condition_str;
   }
};
struct Select {
 public:
   string value_name = EMPTY;
   string optional_value = EMPTY;
   vector<Expression> lines = {};
 public:
   Select () {
      
return ;
   }
   string to_cpp(int indent) {
         string  select_str = "";
         string  wrapped = "" + to_string(value_name) + "_optional_value";
         for(int i = 0; i < indent; i++) {
            
 select_str+= TAB;
}
      select_str+="\n{\n";
      select_str+="auto " + to_string(wrapped) + " = " + to_string(optional_value) + "" + to_string(LINE_END) + "";
      select_str+="if(" + to_string(wrapped) + ".is_some())" + to_string(BLOCK_START) + "";
      select_str+="auto " + to_string(value_name) + " = " + to_string(wrapped) + ".value_unsafe()" + to_string(LINE_END) + "";
         for(int i = 0; i < lines.size(); i++) {
            
 select_str+= expr_to_cpp (&lines.at(i), indent + 1);
}
      select_str+= BLOCK_END;
      select_str+="\n}\n";
      return  select_str;
   }
};
struct MatchLines {
 public:
   vector<string> lines = {};
 public:
   MatchLines () {
      
return ;
   }
   MatchLines (vector<string> lines) {
      this-> lines= lines;
   }
};
struct MatchDef {
 public:
   string matcher_expr = EMPTY;
   vector<string> statments = {};
   vector<MatchLines> lines = {};
   Option<string> id = None<string>();
   bool is_let = false;
   vector<string> operators = {};
 public:
   MatchDef () {
      
return ;
   }
   MatchDef (string matcher_expr, vector<string> statments, vector<MatchLines> lines, Option<string> id, bool is_let, vector<string> operators) {
      this-> matcher_expr= matcher_expr;
      this-> statments= statments;
      this-> lines= lines;
      this-> id= id;
      this-> is_let= is_let;
      this-> operators= operators;
   }
   string to_cpp() {
         string  matcher = "";
         
{
auto returner_optional_value = id;
if(returner_optional_value.is_some()) {
auto returner = returner_optional_value.value_unsafe();
               if(is_let    ) {
                  matcher+="auto " + to_string(returner) + " = ";
                     auto  default_statement = -1;
                     for(int i = 0; i < statments.size(); i++) {
auto statment = statments.at(i);                           if(statment  == "_"  ) {
                               default_statement= i;
break ;
}
}
                     if(default_statement  == - 1  ) {
                        
 error ("[Match] match let statement requires default statement!", "");
}
                     auto  l = lines[default_statement];
                  matcher+= l. lines[ l. lines. size ()- 1];
}
}

}
      matcher+="{";
      matcher+="\n" + to_string(TAB) + "auto _match_expr_ = " + to_string(matcher_expr) + "" + to_string(LINE_END) + "";
         for(int i = 0; i < statments.size(); i++) {
auto statment = statments.at(i);               auto  condition = operators[i].size()==0?statment:"_match_expr_ " + to_string(operators[i]) + " " + to_string(statment) + "";
               if(statment  == "_"  ) {
                  
 condition="true";
}
               if(i  == 0  ) {
                  
 matcher+="if (" + to_string(condition) + ") " + to_string(BLOCK_START) + "";
}
               else if(statment  != "_"  ) {
                  
 matcher+="else if (" + to_string(condition) + ") " + to_string(BLOCK_START) + "";
}
               else {
                  
 matcher+="else {\n";
}
               auto  s_lines = lines[i];
               for(int j = 0; j < s_lines.lines.size(); j++) {
auto line = s_lines.lines.at(j);                     if(j  == s_lines . lines . size () - 1  ) {
                           
{
auto returner_optional_value = id;
if(returner_optional_value.is_some()) {
auto returner = returner_optional_value.value_unsafe();
                              matcher+="" + to_string(returner) + " = ";
}

}
}
                  matcher+="" + to_string(line) + "\n";
}
            matcher+="}\n";
}
      matcher+="}\n";
      return  matcher;
   }
};
struct Expression {
 public:
   Option<Condition> e_condition = None<Condition>();
   Option<For> e_for = None<For>();
   Option<Select> e_select = None<Select>();
   Option<Variable> e_declaration = None<Variable>();
   Option<MatchDef> e_matcher = None<MatchDef>();
   Option<string> line = None<string>();
   Option<string> raw_line = None<string>();
 public:
   Expression () {
      
return ;
   }
   Expression (Condition conditions) {
      this-> e_condition= Some (conditions);
   }
   Expression (For fors) {
      this-> e_for= Some (fors);
   }
   Expression (Select selects) {
      this-> e_select= Some (selects);
   }
   Expression (Variable declaration) {
      this-> e_declaration= Some (declaration);
   }
   Expression (MatchDef matcher) {
      this-> e_matcher= Some (matcher);
   }
   Expression (string line) {
      this-> line= Some (line);
   }
   Expression (string line, bool is_raw) {
         if(is_raw    ) {
            
 this-> raw_line= Some (line);
}
         else {
            
 this-> line= Some (line);
}
   }
   Expression (Option<Condition> conditions, Option<For> fors, Option<Variable> declaration, Option<string> line) {
      this-> e_condition= conditions;
      this-> e_for= fors;
      this-> e_declaration= declaration;
      this-> line= line;
   }
   string to_cpp(int indentation) {
      
return  expr_to_cpp (this, indentation);
   }
};
string expr_to_cpp(Expression* self, int indent) {
      auto  condition = self->e_condition;
      auto  foreacher = self->e_for;
      auto  selects = self->e_select;
      auto  declaration = self->e_declaration;
      auto  matcher = self->e_matcher;
      auto  line = self->line;
      auto  raw_line = self->raw_line;
      string  expression = "";
      
{
auto c_optional_value = condition;
if(c_optional_value.is_some()) {
auto c = c_optional_value.value_unsafe();
         
return  c. to_cpp (indent + 1);
}

}
      
{
auto f_optional_value = foreacher;
if(f_optional_value.is_some()) {
auto f = f_optional_value.value_unsafe();
         
return  f. to_cpp (indent + 1);
}

}
      
{
auto s_optional_value = selects;
if(s_optional_value.is_some()) {
auto s = s_optional_value.value_unsafe();
         
return  s. to_cpp (indent + 1);
}

}
      
{
auto d_optional_value = declaration;
if(d_optional_value.is_some()) {
auto d = d_optional_value.value_unsafe();
         
return  d. to_cpp (indent + 1, LINE_END);
}

}
      
{
auto m_optional_value = matcher;
if(m_optional_value.is_some()) {
auto m = m_optional_value.value_unsafe();
         
return  m. to_cpp ();
}

}
      
{
auto r_optional_value = raw_line;
if(r_optional_value.is_some()) {
auto r = r_optional_value.value_unsafe();
         
return  r;
}

}
      for(int i = 0; i < indent; i++) {
         
 expression+= TAB;
}
      auto  line_value = line.value_or(EMPTY);
      auto  line_str = String(line_value);
      if(line_value . size ()  != 0  ) {
         expression+= line_value;
            auto  is_case = line_str.starts_with("case ");
            auto  is_default = line_str.starts_with("default");
            if(! is_case    &&! is_default    ) {
               
 expression+= LINE_END;
}
}
   return  expression;
}
struct Function {
 public:
   string id = EMPTY;
   VariableState variable_state = VariableState::Public;
   Option<Variable> return_value = None<Variable>();
   vector<Variable> arguments = {};
   vector<Expression> expressions = {};
   vector<string> templates = {};
   bool staticness = false;
   bool virtualness = false;
   bool is_member = false;
 public:
   Function (VariableState state) {
      this-> variable_state= state;
   }
   void add_args(Variable var) {
      
 arguments. push_back (var);
   }
   void add_expr(Expression expr) {
      
 expressions. push_back (expr);
   }
   string to_cpp_start(bool in_class) {
      string fun_str= templates. size ()> 0 ? TEMPLATE: EMPTY;
         for(int i = 0; i < templates.size(); i++) {
            fun_str+= templates. at (i);
            fun_str+= i+ 1< templates. size () ? TEMPLATE_MID: TEMPLATE_END;
}
      fun_str+= in_class ? TAB: EMPTY;
         if(staticness    ) {
            
 fun_str+=" static ";
}
         if(virtualness    ) {
            
 fun_str+=" virtual ";
}
      fun_str+= return_value. value_or (Variable(true)). v_type;
      fun_str+=" " + to_string(id) + "(";
         for(int i = 0; i < arguments.size(); i++) {
            fun_str+= arguments. at (i). to_cpp (EMPTY, EMPTY);
            fun_str+= i+ 1< arguments. size () ? ARG_SEP: EMPTY;
}
      fun_str+= RPAREN;
      return  fun_str;
   }
   string to_cpp_h() {
      
return  to_cpp_start (false)+ LINE_END;
   }
   string to_cpp(bool in_class) {
         auto  fun_str = to_cpp_start(in_class);
      fun_str+= BLOCK_START;
         for(int e_iterator = 0; e_iterator < expressions.size(); e_iterator++) {
auto e = expressions.at(e_iterator);            fun_str+= e. to_cpp (1 + in_class);
}
         if(in_class    ) {
            
 fun_str+= TAB;
}
      fun_str+= BLOCK_END;
      return  fun_str;
   }
};
struct Class {
 public:
   bool is_struct = false;
   string id = EMPTY;
   Option<string> inherit = None<string>();
   vector<Function> functions = {};
   vector<Variable> variables = {};
   vector<string> templates = {};
 public:
   bool contains(Variable v) {
         for(int var_iterator = 0; var_iterator < variables.size(); var_iterator++) {
auto var = variables.at(var_iterator);               if(var . id  == v . id  ) {
                  
return true;
}
}
      return false;
   }
   string to_cpp_start() {
      string class_str= templates. size ()> 0 ? TEMPLATE:"";
         for(int i = 0; i < templates.size(); i++) {
            class_str+= templates. at (i);
            class_str+= i+ 1< templates. size () ? TEMPLATE_MID: TEMPLATE_END;
}
      class_str+= is_struct ? STRUCT: CLASS;
      class_str+= id;
      return  class_str;
   }
   string to_cpp_start_inherit() {
         auto  class_str = to_cpp_start();
         
{
auto i_optional_value = inherit;
if(i_optional_value.is_some()) {
auto i = i_optional_value.value_unsafe();
            
 class_str+= INHERIT+ i;
}

}
      return  class_str;
   }
   string to_cpp_h() {
      
return  to_cpp_start ()+ LINE_END;
   }
   string to_cpp() {
         auto  class_str = to_cpp_start_inherit();
      class_str+= BLOCK_START;
         auto  previous_state = VariableState::Private;
         for(int i = 0; i < variables.size(); i++) {
auto v = variables.at(i);               if(i  == 0  ||v . variable_state  != previous_state  ) {
                  class_str+= variable_state_to_cpp (v.variable_state);
                  previous_state= v. variable_state;
}
               auto  declared = v;
               if(v . staticness    &&! v . constantness    ) {
                  
 declared. v_value= None<string> ();
}
            class_str+= declared. to_cpp (TAB, LINE_END);
}
         for(int i = 0; i < functions.size(); i++) {
auto f = functions.at(i);               if(i  == 0  ||f . variable_state  != previous_state  ) {
                  class_str+= variable_state_to_cpp (f.variable_state);
                  previous_state= f. variable_state;
}
            class_str+= f. to_cpp (true);
}
      class_str+="" + to_string(RBRACK) + "" + to_string(LINE_END) + "";
         for(int v_iterator = 0; v_iterator < variables.size(); v_iterator++) {
auto v = variables.at(v_iterator);               if(! v . staticness    ) {
                  
 continue;
}
               if(v . constantness    ) {
                   class_str+="const " + to_string(v.v_type) + " " + to_string(id) + "::" + to_string(v.id) + "" + to_string(LINE_END) + "";
continue ;
}
            class_str+="" + to_string(v.v_type) + " " + to_string(id) + "::" + to_string(v.id) + "";
               
{
auto value_optional_value = v.v_value;
if(value_optional_value.is_some()) {
auto value = value_optional_value.value_unsafe();
                  class_str+=" = " + to_string(value) + "";
}

}
               if(v . v_value . is_none ()    &&String (v.v_type) . contains ("*")    ) {
                  class_str+=" = nullptr";
}
            class_str+= LINE_END;
}
      return  class_str;
   }
};
struct Program {
 public:
   vector<Global> global = {};
   vector<Struct> structs = {};
   vector<Function> functions = {};
   vector<Class> classes = {};
   vector<Include> includes = {};
   vector<Uses> usings = {};
   vector<string> gets = {};
   vector<Enum> enums = {};
 public:
   Program () {
      
return ;
   }
};
struct Compiler {
 public:
   Program* program;
   Peekable<AstToken> ast;
   vector<string> arguments = {};
   List<string> current_text = List<string>({"\033[0m>>"});
   int current_line = 0;
 public:
   Compiler (Program* p, Peekable<AstToken> ast, int extra_lines) {
      this-> program= p;
      this-> ast= ast;
      this-> current_line-= extra_lines;
   }
   string recap() {
         auto  current = current_line-2;
         while(current_text . len ()  < 7  ) {
               
{
auto n_optional_value = next(true);
if(n_optional_value.is_some()) {
auto n = n_optional_value.value_unsafe();
                  
 continue;
}

}
            break;
}
         string  s = "\n";
         for(int line_iterator = 0; line_iterator < current_text.size(); line_iterator++) {
auto line = current_text.at(line_iterator);               auto  nr = to_string(current);
            s+="" + to_string(nr) + " " + to_string(line) + "\n";
            current++;
}
      return  s;
   }
   int size() {
      
return  ast. size ();
   }
   Option<AstToken> next() {
      
return  next (false);
   }
   Option<AstToken> next(bool is_err) {
         auto  len = current_text.len();
         if(len  == 0  ) {
            
 current_text. add ("\033[0m>> ");
}
         
{
auto peeked_optional_value = ast.peek();
if(peeked_optional_value.is_some()) {
auto peeked = peeked_optional_value.value_unsafe();
               if(peeked . token  == Token :: NewLine  ) {
                     if(! is_err    &&len  > 3  ) {
                        
 current_text. remove (0);
}
                  current_text. add ("\033[0m>> ");
                  current_line++;
}
               else {
                     
{
auto last_optional_value = current_text.last();
if(last_optional_value.is_some()) {
auto last = last_optional_value.value_unsafe();
                           if(! is_err    ) {
                              last+="\033[034m" + to_string(peeked.name) + "\033[0m ";
}
                           else {
                              last+="\033[031m" + to_string(peeked.name) + "\033[0m ";
}
                           auto  vec = current_text.as_vec_ptr();
                        vec-> at (len - 1)= last;
}

}
}
}

}
      return  ast. next ();
   }
   Option<AstToken> peek() {
      
return  ast. peek ();
   }
   Option<AstToken> prev() {
      
return  ast. prev ();
   }
   void add(Function function) {
      
 program-> functions. push_back (function);
   }
   void add(Class class_obj) {
      
 program-> classes. push_back (class_obj);
   }
   void add(Enum enum_def) {
      
 program-> enums. push_back (enum_def);
   }
   void add(Global global) {
      
 program-> global. push_back (global);
   }
   void add_inc(vector<string> includes) {
         for(int i_iterator = 0; i_iterator < includes.size(); i_iterator++) {
auto i = includes.at(i_iterator);            
 program-> includes. push_back (Include(i));
}
   }
   void add_use(vector<string> usings) {
         for(int i_iterator = 0; i_iterator < usings.size(); i_iterator++) {
auto i = usings.at(i_iterator);            
 program-> usings. push_back (Uses(i));
}
   }
   void add_get(vector<string> gets) {
         for(int i_iterator = 0; i_iterator < gets.size(); i_iterator++) {
auto i = gets.at(i_iterator);               while(i . find ("/")  != - 1  ) {
                  
 i= i. substr (1);
}
            program-> gets. push_back (i);
}
   }
   void add_arg(string arg) {
      
 arguments. push_back (String(arg).replace(QUOTE, EMPTY));
   }
   void add_args(vector<string> args) {
         for(int i_iterator = 0; i_iterator < args.size(); i_iterator++) {
auto i = args.at(i_iterator);            
 arguments. push_back (i);
}
   }
   bool has_use(string id) {
         for(int i_iterator = 0; i_iterator < program->usings.size(); i_iterator++) {
auto i = program->usings.at(i_iterator);               if(i . usings  == id  ) {
                  
return true;
}
}
      return false;
   }
   bool has_function(string id) {
         for(int i_iterator = 0; i_iterator < program->functions.size(); i_iterator++) {
auto i = program->functions.at(i_iterator);               if(i . id  == id  ) {
                  
return true;
}
}
      return false;
   }
   bool has_class(string id) {
         for(int i_iterator = 0; i_iterator < program->classes.size(); i_iterator++) {
auto i = program->classes.at(i_iterator);               if(i . id  == id  ) {
                  
return true;
}
}
      return false;
   }
   Option<Class> get_class(string id) {
         for(int i_iterator = 0; i_iterator < program->classes.size(); i_iterator++) {
auto i = program->classes.at(i_iterator);               if(i . id  == id  ) {
                  
return  Some (i);
}
}
      return  None< Class> ();
   }
   bool has_inc(string id) {
         for(int i_iterator = 0; i_iterator < program->includes.size(); i_iterator++) {
auto i = program->includes.at(i_iterator);               if(i . include  == id  ) {
                  
return true;
}
}
      return false;
   }
   bool has_get(string id) {
         auto  getter = id;
         while(getter . find ("/")  != - 1  ) {
            
 getter= getter. substr (1);
}
         for(int i_iterator = 0; i_iterator < program->gets.size(); i_iterator++) {
auto i = program->gets.at(i_iterator);               if(i  == getter  ) {
                  
return true;
}
}
      return false;
   }
   bool has_enum(string id) {
         for(int i_iterator = 0; i_iterator < program->enums.size(); i_iterator++) {
auto i = program->enums.at(i_iterator);               if(i . name  == id  ) {
                  
return true;
}
}
      return false;
   }
   bool has_glob(string id) {
         for(int g_iterator = 0; g_iterator < program->global.size(); g_iterator++) {
auto g = program->global.at(g_iterator);               for(int v_iterator = 0; v_iterator < g.variables.size(); v_iterator++) {
auto v = g.variables.at(v_iterator);                     if(v . v_type  == id  ) {
                        
return true;
}
}
}
      return false;
   }
   bool has_enum_name(string id) {
         for(int e_iterator = 0; e_iterator < program->enums.size(); e_iterator++) {
auto e = program->enums.at(e_iterator);               for(int j_iterator = 0; j_iterator < e.enums.size(); j_iterator++) {
auto j = e.enums.at(j_iterator);                     if(j . name  == id  ) {
                        
return true;
}
}
}
      return false;
   }
};
struct MapOperator {
 public:
   string obj_name = EMPTY;
   string expression = EMPTY;
   Token operator_type = Token();
   Option<string> iterator_name = None<string>();
 public:
   MapOperator () {
      
return ;
   }
   string to_ha(int order, string operate_on) {
         string  map_op_str = "> " + to_string(get_lambda_name(order)) + " = ()\n";
      map_op_str+="let " + to_string(obj_name) + "_as_opt = " + to_string(operate_on) + "";
      map_op_str+= order> 0 ?"()\n":"\n";
      map_op_str+="let " + to_string(obj_name) + " = " + to_string(obj_name) + "_as_opt";
      map_op_str+= order> 0 ?".value_unsafe()\n":"\n";
      map_op_str+="return ";
         if(order  > 0  ) {
            
 map_op_str+="" + to_string(obj_name) + "_as_opt.is_some()";
}
         switch(operator_type    ) {
            case Token::Where:
               if(order  > 0  ) {
                  
 map_op_str+=" && ";
}
            map_op_str+="" + to_string(expression) + " ? Some(" + to_string(obj_name) + ") : None(" + to_string(obj_name) + ")\n";
            break;
            case Token::Select:
               if(order  > 0  ) {
                  
 map_op_str+=" ? Some(" + to_string(expression) + ") : None(" + to_string(expression) + ")\n";
}
               else {
                  
 map_op_str+="Some(" + to_string(expression) + ")\n";
}
            break;
}
      map_op_str+="\n;\n";
      return  map_op_str;
   }
   string get_lambda_name(int order) {
         string  lambda_name = "" + to_string(obj_name) + "_lambda_z";
         for(int i = 0; i < order; i++) {
            
 lambda_name+="z";
}
      return  lambda_name;
   }
};
struct Map {
 public:
   string assigning_value = EMPTY;
   string operator_on_value = EMPTY;
   string type_to_output = EMPTY;
   vector<MapOperator> operations = {};
 public:
   Map () {
      
return ;
   }
   string to_ha() {
         string  iterator_obj = "" + to_string(assigning_value) + "_out_map_value_xzxzxzxzxzx";
         string  selected_obj = "map_" + to_string(iterator_obj) + "_out_sdfgsg";
         string  map_str = "" + to_string(iterator_obj) + " in " + to_string(operator_on_value) + "\n";
         for(int i = 0; i < operations.size(); i++) {
auto operation = operations.at(i);            map_str+= i== 0 ? operation. to_ha (i, iterator_obj): operation. to_ha (i, operations[i - 1].get_lambda_name(i - 1));
               if(i  == operations . size () - 1  ) {
                  map_str+="\nselect " + to_string(selected_obj) + " from " + to_string(operation.get_lambda_name(i)) + "()\n";
                  map_str+="\n" + to_string(assigning_value) + ".push_back(" + to_string(selected_obj) + ")\n;\n;\n";
}
}
      return  map_str;
   }
   string to_cpp() {
         auto  compiler_t = temp_compiler(to_ha());
         string  map_str = "vector<" + to_string(type_to_output) + "> " + to_string(assigning_value) + ";\n";
      map_str+= for_construct (&compiler_t, true). to_cpp (0);
      return  map_str;
   }
};
enum class MessageSeverity: int {
   Hint,
   Error,
};
string to_string(MessageSeverity enumerator) {
switch (enumerator) {
case MessageSeverity::Hint: return "Hint";
case MessageSeverity::Error: return "Error";
default: return "UNKNOWN TYPE";
}};
void colored(MessageSeverity severity, string msg, string recap) {
   string color="";
      switch(severity    ) {
         case MessageSeverity::Hint:
          color="\033[34m";
break ;
         case MessageSeverity::Error:
          color="\033[31m";
break ;
}
   println ("" + to_string(color) + "[" + to_string(severity) + "] >> " + to_string(msg) + " \033[0m");
   println (recap);
}
void display_message(MessageSeverity severity, string msg, string recap) {
   
 colored (severity, msg, recap);
}
void hint(string msg) {
   
 display_message (MessageSeverity::Hint, msg, "");
}
void error(string msg, string recap) {
   display_message (MessageSeverity::Error, msg, recap);
   exit (1);
}
struct FpFn {
 public:
   string f_p = "";
   string f_n = "";
 public:
   FpFn () {
      
return ;
   }
   FpFn (string f_p, string f_n) {
      this-> f_p= f_p;
      this-> f_n= f_n;
   }
};
AstToken next_or_exit(Compiler* compiler_t, string s) {
      auto  next = compiler_t->next();
      if(next . is_none ()    ) {
         
 error (s, compiler_t->recap());
}
   return  next. value_or (AstToken());
}
bool try_get(Compiler* compiler_t, Token token) {
      auto  peek = compiler_t->peek();
      if(peek . is_none ()    ) {
         
return false;
}
   return  peek. value_or (AstToken()). token== token;
}
string get_or_exit(Compiler* compiler_t, Token token, string s) {
      auto  next = compiler_t->next();
      if(next . is_none ()    ||next . value_or (AstToken()) . token  != token  ) {
         
 error (s, compiler_t->recap());
}
   return  next. value_or (AstToken()). name;
}
string id_or_exit(Compiler* compiler_t, string s) {
   
return  get_or_exit (compiler_t, Token::Id, s);
}
string eq_or_exit(Compiler* compiler_t, string s) {
   
return  get_or_exit (compiler_t, Token::Equals, s);
}
string arrow_or_exit(Compiler* compiler_t, string s) {
   
return  get_or_exit (compiler_t, Token::CoolArrow, s);
}
FpFn folder_and_name(string file_path) {
      string  file_name = "";
      string  reversed = "";
      auto  folder_path = file_path;
      while(true   ) {
            if(folder_path . size ()  == 0  ) {
               
 break;
}
            auto  ch = folder_path.back();
         folder_path. pop_back ();
            if(ch  == '/'  ) {
                folder_path. push_back ('/');
break ;
}
         file_name. push_back (ch);
}
      while(file_name . size ()  > 0  ) {
         reversed. push_back (file_name.back());
         file_name. pop_back ();
}
   file_name= reversed;
   return  FpFn (folder_path, file_name);
}
Compiler temp_compiler(string emulated_str) {
      auto  ast = ast_create(emulated_str);
static Program program;
   return  Compiler (&program, ast, 0);
}
string get_file_path(int argc, char** argv) {
      if(argc  < 2  ) {
         
 error ("No file path supplied in arguments!\nExiting...", "");
}
      string  fp = "";
      int  i = 0;
      while(argv [ 1 ] [ i ]  != '\0'  ) {
         
 fp. push_back (argv[1][i++]);
}
   return  fp;
}
string get_content(CompilerPath paths, bool can_be_lib) {
   string content, linebuf;
   ifstream reader (paths.current);
      if(! reader    &&can_be_lib    ) {
            
{
auto home_optional_value = home_env();
if(home_optional_value.is_some()) {
auto home = home_optional_value.value_unsafe();
               reader= ifstream ("" + to_string(home) + "/.local/lib/halppp/" + to_string(paths.current) + "");
}

}
}
      if(! reader    ) {
         
 error ("Couldn't open file\nExiting...", "");
}
      while(! reader . eof ()    ) {
         getline (reader, linebuf);
         content+="" + to_string(linebuf) + "\n";
}
   return  content;
}
string resolve_get_path(string local_path, string lib_name) {
      auto  local_reader = ifstream(local_path);
      if(local_reader    ) {
         
return  local_path;
}
      
{
auto home_optional_value = home_env();
if(home_optional_value.is_some()) {
auto home = home_optional_value.value_unsafe();
            string  lib_path = "" + to_string(home) + "/.local/lib/halppp/" + to_string(lib_name) + "";
            auto  lib_reader = ifstream(lib_path);
            if(lib_reader    ) {
               
return  lib_path;
}
}

}
   hint ("[Get]: " + to_string(lib_name) + " not found locally (" + to_string(local_path) + ") or in ~/.local/lib/halppp");
   return  local_path;
}
void write_program(string program, CompilerPath paths) {
   ofstream file (paths.main_path_cpp);
   file<< program;
   file. close ();
}
char* to_char_arr(string s, char* buf) {
      for(int i = 0; i < s.size(); i++) {
         
 buf[ i]= s. at (i);
}
   buf[ s. size ()]='\0';
   return  buf;
}
void compile_program(CompilerPath paths, vector<string> arguments, bool is_release) {
      string  base_cmd = "g++ ";
   base_cmd+= is_release ?"-O3 ":"-Wall ";
   base_cmd+= paths. output;
      for(int i = 0; i < arguments.size(); i++) {
         
 base_cmd+=" " + to_string(arguments.at(i)) + "";
}
   println ("compiling: " + base_cmd);
   char cmd[ base_cmd. size ()+ 1];
   char cpp_path[ paths. main_path_cpp. size ()+ 1];
      auto  status = system(to_char_arr(base_cmd, cmd));
   remove (to_char_arr(paths.main_path_cpp, cpp_path));
      if(status  != 0  ) {
         
 exit (1);
}
}
bool next_is_none(Peekable<char> &peekable) {
   return  peekable. peek (). is_none ();
}
Option<string> try_get_pair(Peekable<char> &peekable, char c) {
      string  pairs = "";
      switch(c    ) {
         case '(':
          pairs= get_pair (&peekable, '(', ')');
break ;
         case '{':
          pairs= get_pair (&peekable, '{', '}');
break ;
         default:
         
 break;
}
   return  pairs!="" ? Some (pairs): None<string> ();
}
Option<string> try_get_concat(Peekable<char> &peekable, char c) {
      if(c  != '$'  ||peekable . peek () . value_or (' ')  != '"'  ) {
         
return  None<string> ();
}
   return  Some (get_concat(&peekable));
}
Option<string> try_get_matching(Peekable<char> &peekable, char c) {
      if(none (c, {CHAR_QUOTE, CHAR_SINGLE})    ) {
         
return  None<string> ();
}
   return  Some (get_matching(&peekable, c));
}
void try_append_raw(Peekable<char> &peekable, vector<AstToken> &ast) {
      if(ast . size ()  <= 0  ||ast [ ast . size () - 1 ] . token  != Token :: Raw  ) {
         
return ;
}
   ast[ ast. size ()- 1]. name= try_collect_raw (&peekable);
   ast. push_back (AstToken("\n"));
}
Option<AstToken> try_get_num(Peekable<char> &peekable, char c) {
      if(! is_char_number_t (c)    ) {
         
return  None< AstToken> ();
}
   return  Some (collect_num(&peekable, c));
}
Option<AstToken> try_get_single_char_token(Peekable<char> &peekable, char c) {
      if(! is_char_token (c)    ) {
         
return  None< AstToken> ();
}
   return  Some (AstToken(c));
}
Option<AstToken> try_get_white_space(Peekable<char> &peekable, char c) {
      if(! is_white_space (c)    ) {
         
return  None< AstToken> ();
}
      else if(c  == '\n'  ) {
         
return  Some (AstToken("\n"));
}
      else {
         
return  Some (AstToken(" "));
}
}
bool is_white_space(char c) {
   
return  any (c, {'\n', ' ', '\t', '\r'});
}
bool is_both_token(string id, char c) {
   
return  is_str_tokens (id)== is_char_token (c);
}
Option<string> try_get_advanced_condition(Peekable<char> &peekable, string id, char c) {
      if(id . size ()  != 0  ||c  != '='  ) {
         
return  None<string> ();
}
      if(peekable . peek () . is_none ()    ) {
         
return  None<string> ();
}
      if(peekable . at (peekable.index() + 1) . is_none ()    ) {
         
return  None<string> ();
}
      auto  second = peekable.peek().value_or(' ');
      auto  third = peekable.at(peekable.index() + 1).value_or(' ');
      auto  is_part_of_adv = any(second, {'&', '<', '!', '|', '>'});
      auto  is_end_of_adv = third=='=';
      if(! is_part_of_adv    ||! is_end_of_adv    ) {
         
return  None<string> ();
}
   string part_one (1, c);
   string part_two (1, second);
   string part_three (1, third);
      auto  combined = part_one+part_two+part_three;
   return  Some (combined);
}
vector<AstToken> ast_create(string content) {
   
return  ast_create (content, 0);
}
vector<AstToken> ast_create(string content, int line_offset) {
   vector< char> vec= {};
      for(int i_iterator = 0; i_iterator < content.size(); i_iterator++) {
auto i = content.at(i_iterator);         
 vec. push_back (i);
}
      auto  peekable = Peekable<char>(vec);
   string id= EMPTY;
   vector< AstToken> ast= {};
   int current_line= 1;
      while(true   ) {
         try_append_raw (peekable, ast);
            if(next_is_none (peekable)    ) {
                try_add_token (id, ast, peekable, current_line);
break ;
}
            auto  c = peekable.next().value_or(' ');
            auto  last_known_index = peekable.index();
            
{
auto pair_optional_value = try_get_pair(peekable, c);
if(pair_optional_value.is_some()) {
auto pair = pair_optional_value.value_unsafe();
               id= try_add_token (id, ast, peekable, current_line);
                try_add_token (pair, ast, peekable, current_line);
continue ;
}

}
            
{
auto concat_optional_value = try_get_concat(peekable, c);
if(concat_optional_value.is_some()) {
auto concat = concat_optional_value.value_unsafe();
               id= try_add_token (id, ast, peekable, current_line);
                try_add_token (concat, ast, peekable, current_line);
continue ;
}

}
            
{
auto matching_optional_value = try_get_matching(peekable, c);
if(matching_optional_value.is_some()) {
auto matching = matching_optional_value.value_unsafe();
               id= try_add_token (id, ast, peekable, current_line);
                try_add_token (matching, ast, peekable, current_line);
continue ;
}

}
            
{
auto adv_condition_optional_value = try_get_advanced_condition(peekable, id, c);
if(adv_condition_optional_value.is_some()) {
auto adv_condition = adv_condition_optional_value.value_unsafe();
               id= try_add_token (adv_condition, ast, peekable, current_line);
               peekable. next ();
               peekable. next ();
               continue;
}

}
            if(is_char_number_t (c)    &&id . size ()  > 0  &&! is_str_tokens (id)    ) {
                  auto  line = current_line-line_offset;
               string digit (1, c);
               error ("[Lexer] Identifiers cannot contain numbers: " + to_string(id) + "" + to_string(digit) + "... (line " + to_string(line) + ")", "");
}
            
{
auto num_optional_value = try_get_num(peekable, c);
if(num_optional_value.is_some()) {
auto num = num_optional_value.value_unsafe();
               id= try_add_token (id, ast, peekable, current_line);
               ast. push_back (num);
                ast[ ast. size ()- 1]. line= current_line;
continue ;
}

}
         string ch (1, c);
            if(! is_both_token (id, c)    ) {
               id= try_add_token (id, ast, peekable, current_line);
                  if(peekable . index ()  != last_known_index  ) {
                     
 continue;
}
                  if(! is_white_space (c)    ) {
                      id+= ch;
continue ;
}
}
            if(is_both_token (id, c)    &&is_str_tokens (id + ch)    ) {
                id+= ch;
continue ;
}
            else if(is_char_token (c)    ) {
               id= try_add_token (id, ast, peekable, current_line);
                  if(peekable . index ()  != last_known_index  ) {
                     
 continue;
}
               ast. push_back (AstToken(c));
               ast[ ast. size ()- 1]. line= current_line;
                  if(c  == '\n'  ) {
                     
 current_line++;
}
               continue;
}
            else if(is_white_space (c)    ) {
               id= try_add_token (id, ast, peekable, current_line);
               continue;
}
         id+= ch;
}
   ast. push_back (AstToken("EOF"));
   ast[ ast. size ()- 1]. line= current_line;
   ast. push_back (AstToken("EOF"));
   ast[ ast. size ()- 1]. line= current_line;
   ast. push_back (AstToken("EOF"));
   ast[ ast. size ()- 1]. line= current_line;
   ast. push_back (AstToken("EOF"));
   ast[ ast. size ()- 1]. line= current_line;
   ast. push_back (AstToken("EOF"));
   ast[ ast. size ()- 1]. line= current_line;
   ast. push_back (AstToken("EOF"));
   ast[ ast. size ()- 1]. line= current_line;
   return  ast;
}
string try_add_token(string id, vector<AstToken> &ast, Peekable<char> &peekable, int &line) {
      if(id . size ()  == 0  ) {
         
return  id;
}
      bool  consumed_newline = false;
      if(id  == "//"  ) {
            while(true   ) {
                  auto  next = peekable.next().value_or('\n');
                  if(next  == '\n'  ) {
                     
 break;
}
}
         id="\n";
         consumed_newline=true;
}
   ast. push_back (AstToken(id));
   ast[ ast. size ()- 1]. line= line;
      if(consumed_newline    ) {
         
 line++;
}
   return  EMPTY;
}
bool is_str_tokens(string s) {
      if(s . size ()  == 0  ) {
         
return false;
}
      for(int i_iterator = 0; i_iterator < s.size(); i_iterator++) {
auto i = s.at(i_iterator);            if(! is_char_token (i)    ) {
               
return false;
}
}
   return ! Token_t (s). is_id ();
}
bool is_char_token(char ch) {
   string s (1,ch);
   return ! Token_t (s). is_id ();
}
bool is_char_number_t(char ch) {
   string s (1,ch);
   return  Token_t (s). is_num ();
}
Option<string> try_get_dbl(Peekable<char>* peekable, char ch) {
      auto  peek = peekable->peek();
      if(peek . is_none ()    ||peek . value_or (' ')  != ch  ) {
         
return  None<string> ();
}
   peekable-> next ();
   string dbl (1, ch);
   return  Some (dbl + dbl);
}
string get_pair(Peekable<char>* peekable, char ch, char endch) {
      bool  escaped = false;
   string matching (1, ch);
      while(true   ) {
            auto  c_opt = peekable->next();
            if(c_opt . is_none ()    ) {
               
return  matching;
}
            auto  c = c_opt.value_or(' ');
            if(c  == '$'  &&peekable -> peek () . value_or (' ')  == '"'  ) {
               matching+= get_concat (peekable);
               continue;
}
         string matchbuf (1, c);
            if(c  == '\''  ) {
                matching+= get_matching (peekable, '\'');
continue ;
}
            else if(c  == '"'  ) {
                matching+= get_matching (peekable, '"');
continue ;
}
            else if(c  == ch  ) {
                matching+= get_pair (peekable, ch, endch);
continue ;
}
         matching+= matchbuf;
            if(c  == endch  ) {
               
return  matching;
}
}
}
string get_matching(Peekable<char>* peekable, char ch) {
      bool  escaped = false;
   string matching (1, ch);
      while(true   ) {
            auto  c_opt = peekable->next();
            if(c_opt . is_none ()    ) {
               
return  matching;
}
            auto  c = c_opt.value_or(' ');
         string matchbuf (1, c);
         matching+= matchbuf;
            if(c  == ch  &&! escaped    ) {
               
return  matching;
}
         escaped=! escaped&& c=='\\';
}
}
string get_concat(Peekable<char>* peekable) {
   peekable-> next ();
   string concat="\"";
      bool  escaped = false;
      int  depth = 0;
      while(true   ) {
            auto  c_opt = peekable->next();
            if(c_opt . is_none ()    ) {
               
return  concat;
}
            auto  c = c_opt.value_or(' ');
            if(depth  > 0  ) {
                  if(c  == '"'  ) {
                      concat+= get_matching (peekable, '"');
continue ;
}
                  if(c  == '\''  ) {
                      concat+= get_matching (peekable, '\'');
continue ;
}
                  if(c  == '{'  ) {
                     
 depth++;
}
                  if(c  == '}'  ) {
                     
 depth--;
}
                  if(depth  == 0  ) {
                      concat+=") + \"";
continue ;
}
                concat+= c;
continue ;
}
            if(c  == '{'  &&! escaped    ) {
               depth= 1;
               concat+="\" + to_string(";
}
            else {
               
 concat+= c;
}
            if(c  == '"'  &&! escaped    ) {
               
return  concat;
}
         escaped=! escaped&& c=='\\';
}
}
AstToken collect_num(Peekable<char>* peekable, char ch) {
   string num (1, ch);
      bool  is_float = false;
      auto  token = AstToken();
      while(true   ) {
            auto  peeked = peekable->peek().value_or(' ');
            auto  next_peeked = peekable->at(peekable->index() + 1).value_or(' ');
            auto  is_range = peeked=='.'&&next_peeked=='.';
            if(is_range    ||(!isalnum(peeked) && peeked != '.' && peeked != '_')    ) {
               token. name= num;
               token. token= is_float ? Token:: Float: Token:: Number;
               token. t= Token_t ("0");
               token. t. t= is_float ? Token:: Float: Token:: Number;
               return  token;
}
            if(peeked  == '.'  ) {
               
 is_float=true;
}
         peekable-> next ();
         string numbuf (1, peeked);
         num+= numbuf;
}
}
string try_collect_raw(Peekable<char>* peekable) {
      string  raw_str = "";
      while(true   ) {
            auto  c_opt = peekable->next();
            
{
auto c_optional_value = c_opt;
if(c_optional_value.is_some()) {
auto c = c_optional_value.value_unsafe();
               raw_str+= c;
                  if(c  == '\n'  ) {
                     
return  raw_str;
}
               continue;
}

}
         return  raw_str;
}
}
vector<string> imports_construct(Compiler* compiler_t) {
   arrow_or_exit (compiler_t, "[Import]: Missing [=>] in declaration");
   return  imports_construct_impl (compiler_t);
}
vector<string> imports_construct_impl(Compiler* compiler_t) {
   vector<string> imports= {};
      string  id = "";
      while(true   ) {
            auto  next = next_or_exit(compiler_t, "[Import]: Import declaration invalid");
            if(any (next.token, {Token::Eof, Token::NewLine, Token::Comma, Token::RBrack})    ) {
                  if(id . size ()  > 0  &&! imports_check_duplicate (imports, id)    ) {
                     
 imports. push_back (id);
}
               id= EMPTY;
}
            else if(next . token  == Token :: LBrack  ) {
                  auto  combined = imports_construct_impl(compiler_t);
                  for(int i_iterator = 0; i_iterator < combined.size(); i_iterator++) {
auto i = combined.at(i_iterator);                        auto  base = id;
                     base+= i;
                     imports. push_back (base);
}
               id= EMPTY;
}
            else if(next . is_base ()    ) {
               
 error ("[Import]: Token not allowed: " + to_string(next.name) + "", compiler_t->recap());
}
            else {
               
 id+= next. name;
}
            if(any (next.token, {Token::Eof, Token::NewLine, Token::RBrack})    ) {
               
 break;
}
}
   return  imports;
}
vector<string> imports_creation(Compiler* compiler_t, AstToken next) {
      auto  import = imports_construct(compiler_t);
   vector<int> remove= {};
      bool  contains = false;
      for(int i = 0; i < import.size(); i++) {
            auto  imp = import.at(i);
            switch(next . token    ) {
               case Token::Use:
                  if(compiler_t -> has_use (imp)    ) {
                     hint ("[Use]: Duplicate entry of: " + to_string(imp) + "");
                     remove. push_back (i);
}
               break;
               case Token::Include:
                  if(compiler_t -> has_inc (imp)    ) {
                     hint ("[Include]: Duplicate entry of: " + to_string(imp) + "");
                     remove. push_back (i);
}
               break;
               case Token::Get:
                  if(compiler_t -> has_get (imp)    ) {
                     hint ("[Get]: Duplicate entry of: " + to_string(imp) + "");
                     remove. push_back (i);
}
               break;
               default:
                error ("[" + to_string(next.token) + "]: Unhandled import", compiler_t->recap());
break ;
}
}
   vector<string> import_buf= {};
      for(int i = 0; i < import.size(); i++) {
            bool  found = false;
            for(int j_iterator = 0; j_iterator < remove.size(); j_iterator++) {
auto j = remove.at(j_iterator);                  if(i  == j  ) {
                     
 found=true;
}
}
            if(! found    ) {
               
 import_buf. push_back (import.at(i));
}
}
   import= import_buf;
      switch(next . token    ) {
         case Token::Use:
          compiler_t-> add_use (import);
break ;
         case Token::Include:
          compiler_t-> add_inc (import);
break ;
         case Token::Get:
          compiler_t-> add_get (import);
break ;
         default:
          error ("[" + to_string(next.token) + "]: Unhandled import", compiler_t->recap());
break ;
}
   return  import;
}
bool imports_check_duplicate(vector<string> imports, string id) {
      for(int imp_iterator = 0; imp_iterator < imports.size(); imp_iterator++) {
auto imp = imports.at(imp_iterator);            if(imp  == id  ) {
               hint ("[Import]: Token duplicate in entry " + to_string(id) + "");
               return true;
}
}
   return false;
}
enum class EnumError: int {
   Closed,
   CommaNoId,
   Duplicate,
   IdExists,
   Member,
   NoArrow,
   NoId,
   NoValue,
   Unexpected,
   ValueNoId,
};
string to_string(EnumError enumerator) {
switch (enumerator) {
case EnumError::Closed: return "Closed";
case EnumError::CommaNoId: return "CommaNoId";
case EnumError::Duplicate: return "Duplicate";
case EnumError::IdExists: return "IdExists";
case EnumError::Member: return "Member";
case EnumError::NoArrow: return "NoArrow";
case EnumError::NoId: return "NoId";
case EnumError::NoValue: return "NoValue";
case EnumError::Unexpected: return "Unexpected";
case EnumError::ValueNoId: return "ValueNoId";
default: return "UNKNOWN TYPE";
}};
string e_err(EnumError err) {
   
return  e_err (err, EMPTY, false, "");
}
string e_err(EnumError err, string opt) {
   
return  e_err (err, opt, false, "");
}
string e_err(EnumError err, string opt, bool display, string recap) {
      string  msg = "[Enum] ";
      switch(err    ) {
         case EnumError::Closed:
          msg+="Ends without closing itself";
break ;
         case EnumError::CommaNoId:
          msg+="Missing enum before separator";
break ;
         case EnumError::Duplicate:
          msg+="Duplicate instances Enum of: ";
break ;
         case EnumError::IdExists:
          msg+="Cannot assign id to EnumValue that already has id";
break ;
         case EnumError::Member:
          msg+="Duplicate enum members: ";
break ;
         case EnumError::NoArrow:
          msg+="Requires [=>] after Id";
break ;
         case EnumError::NoId:
          msg+="Requires Id in initialization";
break ;
         case EnumError::NoValue:
          msg+="No Value found after assignment";
break ;
         case EnumError::Unexpected:
          msg+="Invalid token inside Enum constructor";
break ;
         case EnumError::ValueNoId:
          msg+="Cannot assign value to EnumValue without id";
break ;
         default:
         
 break;
}
   msg+= opt;
      if(display    ) {
         
 error (msg, recap);
}
   return  msg;
}
void validate_enum(Enum enumerator, Compiler* compiler_t) {
      auto  contains = compiler_t->has_enum(enumerator.name);
      if(contains    ) {
         
 e_err (EnumError::Duplicate, enumerator.name, true, compiler_t->recap());
}
}
Enum enums_construct(Compiler* compiler_t) {
      auto  id = id_or_exit(compiler_t, e_err(EnumError::NoId));
      auto  enumerator = Enum(id);
      auto  enum_def = EnumValue();
      while(true   ) {
            auto  next = next_or_exit(compiler_t, e_err(EnumError::Closed));
            if(next . is_id ()    ) {
                  if(enum_def . name . size ()  == 0  ) {
                      enum_def. name= next. name;
continue ;
}
               e_err (EnumError::IdExists, EMPTY, true, compiler_t->recap());
}
            else if(next . token  == Token :: Comma  ) {
                  if(enum_def . name . size ()  == 0  ) {
                     
 e_err (EnumError::CommaNoId, EMPTY, true, compiler_t->recap());
}
                  for(int i_iterator = 0; i_iterator < enumerator.enums.size(); i_iterator++) {
auto i = enumerator.enums.at(i_iterator);                        if(i . name  == enum_def . name  ) {
                           e_err (EnumError::Member, enum_def.name, true, compiler_t->recap());
}
}
               enumerator. enums. push_back (enum_def);
               enum_def= EnumValue ();
}
            else if(next . token  == Token :: Equals  ) {
                  if(enum_def . name . size ()  != 0  ) {
                        auto  val = get_or_exit(compiler_t, Token::Number, e_err(EnumError::NoValue));
                     enum_def. value= Some (val);
                     continue;
}
               e_err (EnumError::ValueNoId, EMPTY, true, compiler_t->recap());
}
            if(any (next.token, {Token::SemiColon, Token::Eof})    ) {
                  if(enum_def . name . size ()  == 0  ) {
                     
 break;
}
                  for(int i_iterator = 0; i_iterator < enumerator.enums.size(); i_iterator++) {
auto i = enumerator.enums.at(i_iterator);                        if(i . name  == enum_def . name  ) {
                           e_err (EnumError::Member, enum_def.name, true, compiler_t->recap());
}
}
               enumerator. enums. push_back (enum_def);
               break;
}
            if(any (next.token, {Token::Id, Token::NewLine, Token::Comma})    ) {
               
 continue;
}
         e_err (EnumError::Unexpected, EMPTY, true, compiler_t->recap());
}
   validate_enum (enumerator, compiler_t);
   compiler_t-> add (enumerator);
   return  enumerator;
}
Expression for_construct(Compiler* compiler_t, bool is_foreach) {
      auto  for_def = For(is_foreach);
      auto  mid_checker = is_foreach?Token::In:Token::Until;
   for_def. iterator= id_or_exit (compiler_t, "[For] For loop is not closed");
      if(is_foreach    ) {
            if(compiler_t -> peek () . value_or (AstToken("None")) . token  == Token :: Comma  ) {
               next_or_exit (compiler_t, "[For] missing comma");
               for_def. named_variable= Some (id_or_exit(compiler_t, "[For] Requires identifier"));
}
}
   get_or_exit (compiler_t, mid_checker,  "[For] Missing keyword: " + to_string(mid_checker) + "");
   for_def.until= compiler_t-> next (). value_or (AstToken("NONE")). name;
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "[For] For loop is not closed");
            if(x . is_do ()    ) {
               for_def. lines. push_back (expression_construct(compiler_t, x));
               return  Expression (for_def);
}
            if(x . is_nl ()    ) {
               
 break;
}
         for_def.until+= x. name;
}
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "[For] For loop is not closed");
            if(x . is_terminator ()    ) {
               
 break;
}
            if(x . is_nl ()    ) {
               
 continue;
}
            switch(x . token    ) {
               case Token::Foreach:
               case Token::For:
                for_def. lines. push_back (for_construct(compiler_t, x.token == Token::Foreach));
break ;
               case Token::Condition:
                for_def. lines. push_back (condition_construct(compiler_t, x.name));
break ;
               case Token::Switch:
                for_def. lines. push_back (switch_construct(compiler_t));
break ;
               case Token::Select:
                for_def. lines. push_back (select_construct(compiler_t));
break ;
               case Token::Match:
                for_def. lines. push_back (match_construct(compiler_t));
break ;
               default:
                for_def. lines. push_back (expression_construct(compiler_t, x));
break ;
}
}
   return  Expression (for_def);
}
Expression expression_construct(Compiler* compiler_t, AstToken first) {
   
return  expression_construct (compiler_t, first, false);
}
Expression expression_construct(Compiler* compiler_t, AstToken first, bool is_match) {
      string  doing = "";
      string  expression = "";
      if(first . token  == Token :: Raw  ) {
         
return  Expression (first.name, true);
}
      if(first . token  == Token :: Let  ) {
         
return  get_let_expr (compiler_t);
}
      if(first . token  == Token :: MoreThan  ) {
         
return  get_lambda_expr (compiler_t);
}
      if(first . token  == Token :: Id  &&try_get (compiler_t, Token::Equals)    ) {
            auto  t = next_or_exit(compiler_t, "[Expression] Expected =");
         expression= first. name;
         expression+= t. name;
            if(try_get (compiler_t, Token::Match)    ) {
               next_or_exit (compiler_t, "[Expression] Expected match");
               return  match_construct (compiler_t, Some(first.name), false);
}
}
      else {
            switch(first . token    ) {
               case Token::Doco:
                doing=";\ncontinue ";
break ;
               case Token::Dobr:
                doing=";\nbreak ";
break ;
               case Token::Dore:
               
 doing=";\nreturn ";
               case Token::Do:
                expression="\n";
break ;
               case Token::Doremi:
                expression="\nreturn ";
break ;
               case Token::Return:
                expression="return ";
break ;
               default:
                expression= first. name;
break ;
}
}
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "[Expression] Expression ended unexpectedly");
            if(x . token  == Token :: Eof  ) {
                expression+= doing;
break ;
}
            if(x . token  == Token :: NewLine  ) {
                  
{
auto peeked_optional_value = compiler_t->peek();
if(peeked_optional_value.is_some()) {
auto peeked = peeked_optional_value.value_unsafe();
                        if(none (peeked.token, {Token::Period, Token::Pointer})    ||is_match    ) {
                           expression+= doing;
                           break;
}
}

}
}
            if(any (x.token, {Token::Number, Token::Id})    ) {
               
 expression+=" ";
}
            if(x . is_do ()    ) {
               
 expression+="\n";
}
            switch(x . token    ) {
               case Token::Do:
               
 break;
               case Token::Dore:
                doing=";\nreturn ";
break ;
               case Token::Dobr:
                doing=";\nbreak ";
break ;
               case Token::Doco:
                doing=";\ncontinue ";
break ;
               case Token::Doremi:
                expression+="return ";
break ;
               case Token::Let:
                expression+="auto";
break ;
               case Token::Return:
                expression+="return ";
break ;
               case Token::New:
                expression+="new ";
break ;
               default:
                expression+= x. name;
break ;
}
}
   return  Expression (expression);
}
Expression get_let_expr(Compiler* compiler_t) {
      auto  id = id_or_exit(compiler_t, "[Let] Required id after let");
   get_or_exit (compiler_t, Token::Equals,"[Let] Required equals after id");
      string  variable_type = "";
      string  value = "";
      bool  has_operator = false;
      if(try_get (compiler_t, Token::Match)    ) {
         next_or_exit (compiler_t, "Expected match");
         return  match_construct (compiler_t, Some(id), true);
}
      if(try_get (compiler_t, Token::Map)    ) {
         next_or_exit (compiler_t, "Expected map");
         return  map_construct (compiler_t, id, true);
}
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "[Let] Expected token got nothing");
            if(x . token  == Token :: Eof  ) {
               
 break;
}
            if(x . token  == Token :: NewLine  ) {
                  bool  is_member = false;
                  
{
auto peeked_optional_value = compiler_t->peek();
if(peeked_optional_value.is_some()) {
auto peeked = peeked_optional_value.value_unsafe();
                     is_member= String (peeked.name). starts_with (".");
}

}
                  if(! is_member    ) {
                     
 break;
}
}
            if(x . is_conditional ()    ||x . is_conditional_sep ()    ||x . is_adv_conditional ()    ) {
               
 has_operator=true;
}
         value+= x. name;
            if(x . token  == Token :: New  ) {
               
 value+=" ";
}
}
      auto  token = Token_t(value);
      if(has_operator    ) {
         
 variable_type="auto ";
}
      else if(token . is_bool ()    ) {
         
 variable_type="bool ";
}
      else if(token . is_num ()    ) {
         
 variable_type="int ";
}
      else if(token . is_float ()    ) {
         
 variable_type="float ";
}
      else if(token . is_char ()    ) {
         
 variable_type="char ";
}
      else if(token . is_string ()    ) {
         
 variable_type="string ";
}
      else {
         
 variable_type="auto ";
}
      auto  v = Variable(id, variable_type, Some(value), VariableState::Private);
   return  Expression (v);
}
Expression get_lambda_expr(Compiler* compiler_t) {
      auto  id = id_or_exit(compiler_t, "[Lambda] Required id after >");
      string  base = "";
      bool  has_return = false;
   vector<string> parameters= {};
      string  args = "";
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "[Lambda] Incomplete lambda");
            if(x . token  == Token :: Id  &&String (x.name) . starts_with ("(")    ) {
               args= x. name;
               break;
}
            switch(x . token    ) {
               case Token::Id:
                parameters. push_back (x.name);
break ;
               case Token::Equals:
                parameters. push_back (x.name);
break ;
               default:
                error ("[Lambda] Incorrect parameter value", compiler_t->recap());
break ;
}
         x= next_or_exit (compiler_t, "[Lambda] Incomplete lambda");
            if(x . token  == Token :: Id  &&String (x.name) . starts_with ("(")    ) {
               args= x. name;
               break;
}
            if(x . token  == Token :: Comma  ) {
                parameters. push_back (",");
continue ;
}
         error ("[Lambda] Comma missing", compiler_t->recap());
}
   base+="[";
      for(int p_iterator = 0; p_iterator < parameters.size(); p_iterator++) {
auto p = parameters.at(p_iterator);         
 base+= p;
}
   base+="]" + to_string(args) + ""+"{";
      auto  x = next_or_exit(compiler_t, "[Lambda] Incomplete lambda");
      if(x . is_do ()    ) {
         has_return= x. token== Token:: Doremi;
            auto  expr = expression_construct(compiler_t, x);
         base+= expr. to_cpp (2);
}
      else if(x . token  == Token :: NewLine  ) {
            while(true   ) {
               x= next_or_exit (compiler_t, "[Lambda] Incomplete lambda");
                  if(x . token  == Token :: SemiColon  ) {
                     
 break;
}
                  if(x . token  == Token :: Return  ) {
                     
 has_return=true;
}
                  if(x . is_nl ()    ) {
                     
 continue;
}
                  switch(x . token    ) {
                     case Token::Foreach:
                     case Token::For:
                      base+= for_construct (compiler_t, x.token == Token::Foreach). to_cpp (2);
break ;
                     case Token::Condition:
                      base+= condition_construct (compiler_t, x.name). to_cpp (2);
break ;
                     case Token::Switch:
                      base+= switch_construct (compiler_t). to_cpp (2);
break ;
                     case Token::Select:
                      base+= select_construct (compiler_t). to_cpp (2);
break ;
                     case Token::Match:
                      base+= match_construct (compiler_t). to_cpp (2);
break ;
                     default:
                      base+= expression_construct (compiler_t, x). to_cpp (2);
break ;
}
}
}
      if(! has_return    ) {
         
 base+="return true;";
}
   base+="}";
      auto  v = Variable(id, "auto", Some(base), VariableState::Private);
   return  Expression (v);
}
Expression match_construct(Compiler* compiler_t) {
   
return  match_construct (compiler_t, None<string>(), false);
}
Expression match_construct(Compiler* compiler_t, Option<string> id, bool is_let) {
      string  matcher = "";
   vector<string> statments= {};
   vector< MatchLines> internal= {};
   vector<string> operators= {};
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "[Match] requires some kind of expression to match");
            if(x . token  == Token :: NewLine  ) {
               
 break;
}
            if(x . token  == Token :: Eof  ) {
                error ("[Match] missing expression", compiler_t->recap());
break ;
}
            if(x . is_do ()    ) {
                error ("[Match] do is not valid in start expression", compiler_t->recap());
break ;
}
            if(x . is_base ()    ) {
                error ("[Match] Token is not valid in start expression", compiler_t->recap());
break ;
}
         matcher+= x. name;
}
      while(true   ) {
            string  op = "==";
            auto  adv_token = Token::UNKNOWN;
            
{
auto peeked_optional_value = compiler_t->peek();
if(peeked_optional_value.is_some()) {
auto peeked = peeked_optional_value.value_unsafe();
                  if(peeked . is_adv_conditional ()    ) {
                     compiler_t-> next ();
                     adv_token= peeked. token;
}
                  else if(peeked . is_conditional ()    ||peeked . token  == Token :: Period  ||peeked . token  == Token :: Pointer  ) {
                     compiler_t-> next ();
                     op= peeked. name;
}
}

}
            if(adv_token  != Token :: UNKNOWN  ) {
               operators. push_back (EMPTY);
               statments. push_back (match_adv_statements(compiler_t, adv_token));
}
            else {
               operators. push_back (op);
               statments. push_back (match_statements(compiler_t));
}
         internal. push_back (match_lines(compiler_t));
            if(try_get (compiler_t, Token::NewLine)    ) {
               
 next_or_exit (compiler_t, "[Match] Missing new line");
}
            if(try_get (compiler_t, Token::SemiColon)    ) {
               next_or_exit (compiler_t, "[Match] Missing ; at the end");
               break;
}
            else if(try_get (compiler_t, Token::Eof)    ) {
               
 error ("[Match] Unclosed match statement", compiler_t->recap());
}
}
   return  Expression (MatchDef(matcher, statments, internal, id, is_let, operators));
}
string match_statements(Compiler* compiler_t) {
      string  statement = "";
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "[Match] statement not finalized");
            if(x . token  == Token :: CoolArrow  ) {
               
 break;
}
            if(x . token  == Token :: Eof  ) {
               
 break;
}
         statement+= x. name;
}
   return  statement;
}
string match_adv_statements(Compiler* compiler_t, Token adv) {
      string  op = "==";
      string  sep = " && ";
      switch(adv    ) {
         case Token::AllLessOrEquals:
          op="<=";
break ;
         case Token::AllLessThan:
          op="<";
break ;
         case Token::AllMoreOrEquals:
          op=">=";
break ;
         case Token::AllMoreThan:
          op=">";
break ;
         case Token::AllNotEquals:
          op="!=";
break ;
         case Token::AnyEquals:
          sep=" || ";
break ;
         default:
         
 break;
}
      string  statement = "_match_expr_ " + to_string(op) + " ";
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "[Match] statement not finalized");
            if(x . token  == Token :: CoolArrow  ) {
               
 break;
}
            if(x . token  == Token :: Eof  ) {
               
 break;
}
            if(x . token  == Token :: Colon  ) {
                statement+="" + to_string(sep) + "_match_expr_ " + to_string(op) + " ";
continue ;
}
         statement+= x. name;
}
   return  statement;
}
MatchLines match_lines(Compiler* compiler_t) {
      auto  lines = MatchLines();
      auto  x = next_or_exit(compiler_t, "[Match] expected some expression");
      if(x . is_do ()    ) {
         lines. lines. push_back (expression_construct(compiler_t, x, true).to_cpp(2));
         return  lines;
}
      while(true   ) {
{
   auto _match_expr_ = x.token;
if (_match_expr_ == Token::SemiColon)  {
      
 break;

}
else if (_match_expr_ == Token::Eof)  {
      
 break;

}
else if (_match_expr_ == Token::NewLine)  {
       x= next_or_exit (compiler_t, "[Match] expected some expression");
continue ;

}
else if (_match_expr_ == Token::Foreach)  {
      
 lines. lines. push_back (for_construct(compiler_t, true).to_cpp(2));

}
else if (_match_expr_ == Token::For)  {
      
 lines. lines. push_back (for_construct(compiler_t, false).to_cpp(2));

}
else if (_match_expr_ == Token::Condition)  {
      
 lines. lines. push_back (condition_construct(compiler_t, x.name).to_cpp(2));

}
else if (_match_expr_ == Token::Switch)  {
      
 lines. lines. push_back (switch_construct(compiler_t).to_cpp(2));

}
else if (_match_expr_ == Token::Select)  {
      
 lines. lines. push_back (select_construct(compiler_t).to_cpp(2));

}
else if (_match_expr_ == Token::Match)  {
      
 lines. lines. push_back (match_construct(compiler_t).to_cpp(2));

}
else {
      
 lines. lines. push_back (expression_construct(compiler_t, x).to_cpp(2));

}
}
         x= next_or_exit (compiler_t, "[Match] expected some expression");
}
   return  lines;
}
Expression map_construct(Compiler* compiler_t, string id, bool is_let) {
      auto  map_value = Map();
   map_value. assigning_value= id;
   get_or_exit (compiler_t, Token::LessThan, "[Map] expected '<'");
      int  arrow_depth = 1;
      while(true   ) {
            auto  token = next_or_exit(compiler_t, "[Map] expected some type defintion and ending '>'");
            if(token . token  == Token :: LessThan  ) {
               
 arrow_depth++;
}
            if(token . token  == Token :: MoreThan  ) {
               
 arrow_depth--;
}
            if(arrow_depth  == 0  ) {
               
 break;
}
         map_value. type_to_output+= token. name;
}
      auto  raw_operator = String(next_or_exit(compiler_t, "[Map] expected '('").name);
      if(! raw_operator . starts_with ("(")    &&! raw_operator . ends_with (")")    ) {
         
 error ("[Map] expected (...) expression but got {raw_operator.name}", compiler_t->recap());
}
   map_value. operator_on_value= raw_operator. to_string ();
      while(true   ) {
            if(try_get (compiler_t, Token::NewLine)    ) {
               next_or_exit (compiler_t, "[Map] unkown error");
                  if(! try_get (compiler_t, Token::Period)    ) {
                      compiler_t-> prev ();
break ;
}
}
         get_or_exit (compiler_t, Token::Period, "[Map] expected '.'");
            auto  operator_type = next_or_exit(compiler_t, "[Map] expected operator type");
            if(none (operator_type.token, {Token::Select, Token::Where})    ) {
               
 error ("[Map] invalid operator type " + to_string(operator_type.name) + "", compiler_t->recap());
}
         map_value. operations. push_back (map_operator_construct(compiler_t, operator_type.token));
}
      if(map_value . operations . size ()  == 0  ) {
         
 error ("[Map] expected operations but got none", compiler_t->recap());
}
   return  Expression (map_value.to_cpp(), true);
}
MapOperator map_operator_construct(Compiler* compiler_t, Token operator_type) {
      auto  raw_operator = String(next_or_exit(compiler_t, "[Map] expected (...) expression").name);
      if(! raw_operator . starts_with ("(")    &&! raw_operator . ends_with (")")    ) {
         
 error ("[Map] expected (...) expression but got {raw_operator.name}", compiler_t->recap());
}
   raw_operator. remove (0);
   raw_operator. remove_back (1);
      auto  compiler_temp = temp_compiler(raw_operator.to_string());
   return  map_operator_construct_internal (&compiler_temp, operator_type);
}
MapOperator map_operator_construct_internal(Compiler* compiler_t, Token operator_type) {
      auto  map_operator = MapOperator();
   map_operator. operator_type= operator_type;
   map_operator. obj_name= next_or_exit (compiler_t, "[Map] expected some id"). name;
      if(try_get (compiler_t, Token::Comma)    ) {
         map_operator. iterator_name= Some (next_or_exit(compiler_t, "[Map] expected some iterator id").name);
}
   get_or_exit (compiler_t, Token::CoolArrow, "[Map] expected '=>'");
      while(true   ) {
            auto  token = next_or_exit(compiler_t, "[Map] expected some condition");
            if(token . token  == Token :: Eof  ) {
               
 break;
}
         map_operator. expression+= token. name;
}
   return  map_operator;
}
Expression switch_construct(Compiler* compiler_t) {
      auto  cond = Condition("switch");
      auto  expression = ConditionalExpression();
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "[Switch] Switch is not closed");
            if(x . is_do ()    ) {
               
 error ("[Switch] Switch statements cannot have a do parameter", compiler_t->recap());
}
            if(x . is_nl ()    ) {
                cond. expressions. push_back (expression);
break ;
}
         expression. value_left+= x. name+" ";
}
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "[Switch] Switch is not closed");
            bool  exit = false;
         vector< Expression> result= {};
            switch(x . token    ) {
               case Token::Default:
               result= create_case (compiler_t, x.token == Token::Default);
                  for(int i_iterator = 0; i_iterator < result.size(); i_iterator++) {
auto i = result.at(i_iterator);                     
 cond. lines. push_back (i);
}
               break;
               case Token::Case:
               result= create_case (compiler_t, x.token == Token::Default);
                  for(int i_iterator = 0; i_iterator < result.size(); i_iterator++) {
auto i = result.at(i_iterator);                     
 cond. lines. push_back (i);
}
               break;
               case Token::Eof:
                exit=true;
break ;
               case Token::SemiColon:
                exit=true;
break ;
               case Token::NewLine:
               
 break;
               default:
                error ("[Switch] Token not allowed in switch " + to_string(x.token) + "", compiler_t->recap());
break ;
}
            if(exit    ) {
               
 break;
}
}
   return  Expression (cond);
}
vector<Expression> create_case(Compiler* compiler_t, bool is_default) {
   vector< Expression> lines= {};
      string  label = "";
      if(! is_default    ) {
            auto  next = next_or_exit(compiler_t, "[Switch] Case unfinished");
            if(next . token  == Token :: Sub  &&try_get (compiler_t, Token::Number)    ) {
               next= next_or_exit (compiler_t, "[Switch] Case unfinished");
               next. name="-"+ next. name;
}
         label="case "+ next. name;
            auto  name = String(next.name);
            if(next . is_id ()    &&! name . starts_with ("KEY_")    ) {
                  if(! compiler_t -> has_enum (next.name)    ) {
                     
 error ("[Switch] Enum member doesn't exist: " + to_string(next.name) + "", compiler_t->recap());
}
}
            if(! next . valid_case ()    ) {
               
 error ("Token not allowed in switch: ", compiler_t->recap());
}
            if(next . is_id ()    &&try_get (compiler_t, Token::DblColon)    ) {
               label+="::";
               compiler_t-> next ();
                  auto  enum_name = next_or_exit(compiler_t, "[Switch] Unexpected end");
                  if(! compiler_t -> has_enum_name (enum_name.name)    ) {
                     
 error ("[Switch] Enum member doesn't exist: " + to_string(enum_name.name) + "", compiler_t->recap());
}
               label+= enum_name. name;
}
         label+=":\n";
}
      else {
         
 label="default:\n";
}
   lines. push_back (Expression(label));
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "[Switch] Case unfinished");
         vector< Expression> result= {};
            switch(x . token    ) {
               case Token::Case:
               case Token::Default:
               case Token::SemiColon:
               compiler_t-> prev ();
               
return  lines;
               case Token::Foreach:
               case Token::For:
                lines. push_back (for_construct(compiler_t, x.token == Token::Foreach));
break ;
               case Token::Condition:
                lines. push_back (condition_construct(compiler_t, x.name));
break ;
               case Token::Switch:
                lines. push_back (switch_construct(compiler_t));
break ;
               case Token::Select:
                lines. push_back (select_construct(compiler_t));
break ;
               case Token::Match:
                lines. push_back (match_construct(compiler_t));
break ;
               case Token::NewLine:
               
 break;
               default:
                lines. push_back (expression_construct(compiler_t, x));
break ;
}
}
}
Expression select_construct(Compiler* compiler_t) {
      auto  select_def = Select();
   select_def. value_name= id_or_exit (compiler_t, "[Select] is not closed");
   get_or_exit (compiler_t, Token::From, "[Select] Missing keyword: from");
   select_def. optional_value= compiler_t-> next (). value_or (AstToken("NONE")). name;
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "[Select] is not closed");
            if(x . is_do ()    ) {
               select_def. lines. push_back (expression_construct(compiler_t, x));
               return  Expression (select_def);
}
            if(x . is_nl ()    ) {
               
 break;
}
         select_def. optional_value+= x. name;
}
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "[Select] is not closed");
            if(x . is_terminator ()    ) {
               
 break;
}
            if(x . is_nl ()    ) {
               
 continue;
}
            switch(x . token    ) {
               case Token::Foreach:
               case Token::For:
                select_def. lines. push_back (for_construct(compiler_t, x.token == Token::Foreach));
break ;
               case Token::Condition:
                select_def. lines. push_back (condition_construct(compiler_t, x.name));
break ;
               case Token::Switch:
                select_def. lines. push_back (switch_construct(compiler_t));
break ;
               case Token::Select:
                select_def. lines. push_back (select_construct(compiler_t));
break ;
               case Token::Match:
                select_def. lines. push_back (match_construct(compiler_t));
break ;
               default:
                select_def. lines. push_back (expression_construct(compiler_t, x));
break ;
}
}
   return  Expression (select_def);
}
enum class ConditionError: int {
   Closed,
};
string to_string(ConditionError enumerator) {
switch (enumerator) {
case ConditionError::Closed: return "Closed";
default: return "UNKNOWN TYPE";
}};
string co_err(ConditionError err) {
   
return  co_err (err, EMPTY, false, "");
}
string co_err(ConditionError err, string opt) {
   
return  co_err (err, opt, false, "");
}
string co_err(ConditionError err, string opt, bool display, string recap) {
      string  msg = "[Condition] ";
      switch(err    ) {
         case ConditionError::Closed:
          msg+="Condition is not closed ";
break ;
         default:
         
 break;
}
   msg+= opt;
      if(display    ) {
         
 error (msg, recap);
}
   return  msg;
}
Expression condition_construct(Compiler* compiler_t, string condition_type) {
      auto  cond = Condition(condition_type);
      auto  expression = ConditionalExpression();
      if(condition_type  == "elif"  ) {
         
 cond= Condition ("else if");
}
      if(condition_type  == "loop"  ) {
         cond= Condition ("while");
         expression. value_left="true";
}
      while(true   ) {
            auto  x = next_or_exit(compiler_t, co_err(ConditionError::Closed));
            if(x . is_do ()    ) {
               cond. add_expr (expression);
               cond. lines. push_back (expression_construct(compiler_t, x));
               return  Expression (cond);
}
            if(x . is_conditional_sep ()    ) {
               expression. continuation= x. name;
               cond. add_expr (expression);
                expression= ConditionalExpression ();
continue ;
}
            if(x . is_adv_conditional ()    ) {
               adv_conditional_construct (compiler_t, &expression, x);
               cond. add_expr (expression);
                expression= ConditionalExpression ();
continue ;
}
            if(x . is_conditional ()    ) {
                expression. operator_value= x. name;
continue ;
}
            if(x . is_nl ()    ) {
                cond. add_expr (expression);
break ;
}
            if(expression . operator_value . size ()  == 0  ) {
                expression. value_left+="" + to_string(x.name) + " ";
continue ;
}
         expression. value_right+="" + to_string(x.name) + " ";
}
      while(true   ) {
            auto  x = next_or_exit(compiler_t, co_err(ConditionError::Closed));
            if(x . is_terminator ()    ) {
               
 break;
}
            if(x . is_nl ()    ) {
               
 continue;
}
            switch(x . token    ) {
               case Token::Foreach:
               case Token::For:
                cond. lines. push_back (for_construct(compiler_t, x.token == Token::Foreach));
break ;
               case Token::Condition:
                cond. lines. push_back (condition_construct(compiler_t, x.name));
break ;
               case Token::Switch:
                cond. lines. push_back (switch_construct(compiler_t));
break ;
               case Token::Select:
                cond. lines. push_back (select_construct(compiler_t));
break ;
               case Token::Match:
                cond. lines. push_back (match_construct(compiler_t));
break ;
               default:
                cond. lines. push_back (expression_construct(compiler_t, x));
break ;
}
}
   return  Expression (cond);
}
void adv_conditional_construct(Compiler* compiler_t, ConditionalExpression* expr, AstToken token) {
      string  separator = "&& ";
      switch(token . token    ) {
         case Token::AllEquals:
          expr-> operator_value="==";
break ;
         case Token::AllLessOrEquals:
          expr-> operator_value="<=";
break ;
         case Token::AllLessThan:
          expr-> operator_value="<";
break ;
         case Token::AllMoreOrEquals:
          expr-> operator_value=">=";
break ;
         case Token::AllMoreThan:
          expr-> operator_value=">";
break ;
         case Token::AllNotEquals:
          expr-> operator_value="!=";
break ;
         case Token::AnyEquals:
         expr-> operator_value="==";
         separator="|| ";
         break;
         default:
          error ("UNKOWN TOKEN", compiler_t->recap());
break ;
}
      string  op = "" + to_string(expr->operator_value) + " ";
      string  left = "" + to_string(expr->value_left) + " ";
      bool  is_first = true;
      bool  new_operand = true;
      while(true   ) {
            auto  x = compiler_t->peek().value_or(' ');
            if(compiler_t -> peek () . is_none ()    ) {
               
return ;
}
            if(x . is_do ()    ) {
               
return ;
}
            if(x . is_conditional_sep ()    ) {
               
return ;
}
            if(x . is_nl ()    ) {
               
return ;
}
            if(x . token  == Token :: Colon  ) {
               new_operand=true;
                compiler_t-> next ();
continue ;
}
            if(new_operand    &&! is_first    ) {
               
 expr-> value_right+= separator+ left+ op;
}
         expr-> value_right+="" + to_string(x.name) + " ";
         compiler_t-> next ();
         is_first=false;
         new_operand=false;
}
}
struct VariableNBool {
 public:
   Variable variable = Variable();
   bool is_end = false;
 public:
   VariableNBool (Variable v, bool is_end) {
      this-> variable= v;
      this-> is_end= is_end;
   }
};
Option<string> get_value(Compiler* compiler_t, bool found_setter) {
   
return  get_value (compiler_t, found_setter, false);
}
Option<string> get_value(Compiler* compiler_t, bool found_setter, bool in_args) {
      string  value = "";
      if(! found_setter    ) {
         
 eq_or_exit (compiler_t, VAR_ERR_SET);
}
      while(true   ) {
            auto  next = next_or_exit(compiler_t, VAR_ERR_VAL);
            if(next . is_nl ()    ) {
               
 break;
}
            if(in_args    &&any (next.token, {Token::Comma, Token::CoolArrow})    ) {
               
 break;
}
         value+= next. name;
            if(next . token  == Token :: New  ) {
               
 value+=" ";
}
}
   return  value. size ()== 0 ? None<string> (): Some (value);
}
Variable get_type(Compiler* compiler_t) {
      auto  next = next_or_exit(compiler_t, VAR_ERR_NON);
      auto  variable = Variable(true);
      if(any (next.token, {Token::Id, Token::Type})    ) {
         
 variable. v_type= next. name;
}
      else if(next . token  != Token :: NewLine  ) {
         
 error (VAR_ERR_TYP + to_string(next.token), compiler_t->recap());
}
      auto  tried = try_get(compiler_t, Token::LessThan);
      if(tried    ) {
            if(! variable . has_id ()    ) {
               error (VAR_ERR_TEM + variable.v_type, compiler_t->recap());
}
            int  depth = 0;
            while(true   ) {
               next= next_or_exit (compiler_t, VAR_ERR_INV);
                  if(next . is_nl ()    ||next . is_do ()    ||next . is_terminator ()    ) {
                     
 error (VAR_ERR_INV, compiler_t->recap());
}
               variable. v_type+= next. name;
                  if(next . token  == Token :: LessThan  ) {
                     
 depth++;
}
                  if(next . token  == Token :: MoreThan  ) {
                     
 depth--;
}
                  if(next . token  == Token :: DblMoreThan  ) {
                     
 depth-= 2;
}
                  if(next . token  == Token :: AllMoreThan  ) {
                     
 depth-= 3;
}
                  if(depth  <= 0  ) {
                     
 break;
}
}
}
   tried= try_get (compiler_t, Token::Asterix);
      if(tried    ) {
         
 variable. v_type+= get_or_exit (compiler_t, Token::Asterix, VAR_ERR_NON);
}
   return  variable;
}
VariableNBool construct_args(Compiler* compiler_t) {
   
return  construct_args (compiler_t, None<string>(), false);
}
VariableNBool construct_args(Compiler* compiler_t, bool is_func) {
   
return  construct_args (compiler_t, None<string>(), is_func);
}
VariableNBool construct_args(Compiler* compiler_t, Option<string> type_name) {
   
return  construct_args (compiler_t, type_name, false);
}
VariableNBool construct_args(Compiler* compiler_t, Option<string> type_name, bool is_func) {
      auto  variable = Variable();
      
{
auto t_optional_value = type_name;
if(t_optional_value.is_some()) {
auto t = t_optional_value.value_unsafe();
         
 variable. v_type= t;
}

}
      bool  is_end = false;
      string  pre_name = "";
      while(true   ) {
            auto  next = next_or_exit(compiler_t, VAR_ERR_INV);
            if(any (next.token, {Token::NewLine, Token::CoolArrow})    ) {
                is_end=true;
break ;
}
{
   auto _match_expr_ = next.token;
if (_match_expr_ == Token::Equals)  {
      variable. v_value= get_value (compiler_t, true, is_func);

         if(is_func    ) {
               
{
auto prev_optional_value = compiler_t->prev();
if(prev_optional_value.is_some()) {
auto prev = prev_optional_value.value_unsafe();
                  is_end= prev. token== Token:: CoolArrow;
}

}
            compiler_t-> next ();
}

      break;

}
else if (_match_expr_ == Token::TriplePeriod)  {
         if(variable . has_type ()    ) {
            
 variable. v_type+= next. name;
}

         else {
            
 error (VAR_ERR_PER, compiler_t->recap());
}

}
else if (_match_expr_ == Token::Comma)  {
      
 break;

}
else if (_match_expr_ == Token::Asterix)  {
         if(! variable . has_type ()    ) {
            
 error (VAR_ERR_POI + variable.v_type, compiler_t->recap());
}

      variable. v_type+= next. name;

}
else if (_match_expr_ == Token::LessThan)  {
         if(! variable . has_id ()    &&! variable . has_type ()    ) {
            
 error (VAR_ERR_TEM + variable.v_type, compiler_t->recap());
}

      variable. v_type+= next. name;

         int  depth = 1;

         while(true   ) {
            next= next_or_exit (compiler_t, VAR_ERR_INV);
            variable. v_type+= next. name;
               if(next . token  == Token :: LessThan  ) {
                  
 depth++;
}
               if(next . token  == Token :: MoreThan  ) {
                  
 depth--;
}
               if(next . token  == Token :: DblMoreThan  ) {
                  
 depth-= 2;
}
               if(next . token  == Token :: AllMoreThan  ) {
                  
 depth-= 3;
}
               if(depth  == 0  ) {
                  
 break;
}
}

}
else if (_match_expr_ == Token::Const)  {
      
 pre_name="const ";

}
else {
         if(! variable . has_type ()    ) {
             variable. v_type= next. name;
continue ;
}

         if(! variable . has_id ()    ) {
             variable. id= next. name;
continue ;
}

      error (VAR_ERR_COM, compiler_t->recap());

}
}
}
      if(! variable . has_minimum ()    &&! is_end    ) {
         
 error (VAR_ERR_INC + variable.id, compiler_t->recap());
}
   variable. v_type= pre_name+ variable. v_type;
   return  VariableNBool (variable, is_end);
}
vector<string> template_construct(Compiler* compiler_t) {
   vector<string> templates= {};
      string  pre_text = "";
      bool  is_comma = true;
      while(true   ) {
            auto  next = next_or_exit(compiler_t, "[Template]: Template declaration invalid");
            if(next . is_id ()    ) {
                  if(is_comma    ) {
                     templates. push_back (pre_text + next.name);
                     pre_text="";
                     is_comma=false;
                     continue;
}
               error ("[Template]: Expected ',' got: " + to_string(next.name) + "", compiler_t->recap());
}
            else if(next . token  == Token :: TriplePeriod  ) {
                  if(is_comma    ) {
                      pre_text= next. name;
continue ;
}
               error ("[Template]: Expected ',' got: " + to_string(next.name) + "", compiler_t->recap());
}
            else if(next . token  == Token :: Comma  ) {
                is_comma=true;
continue ;
}
            else if(next . token  == Token :: MoreThan  ) {
               
 break;
}
         error ("[Template]: Unecpected token: " + to_string(next.name) + "", compiler_t->recap());
}
   return  templates;
}
bool same_signature(Function a, Function b) {
      if(a . id  != b . id  ||a . templates  != b . templates  ) {
         
return false;
}
      if(a . arguments . size ()  != b . arguments . size ()  ) {
         
return false;
}
      for(int j = 0; j < a.arguments.size(); j++) {
            if(a . arguments [ j ] . v_type  != b . arguments [ j ] . v_type  ) {
               
return false;
}
}
   return true;
}
void validate_function(Function function, Compiler* compiler_t) {
      if(function . is_member    ) {
         
return ;
}
      for(int f_iterator = 0; f_iterator < compiler_t->program->functions.size(); f_iterator++) {
auto f = compiler_t->program->functions.at(f_iterator);            if(f . is_member    ) {
               
 continue;
}
            if(same_signature (f, function)    ) {
               
 error ("Duplicate instances Function of: " + to_string(function.id) + "", compiler_t->recap());
}
}
}
Function function_construct(Compiler* compiler_t, VariableState state, bool constr) {
   
return  function_construct (compiler_t, state, constr, {}, false);
}
Function function_construct(Compiler* compiler_t, VariableState state, bool constr, vector<Variable> variables) {
   
return  function_construct (compiler_t, state, constr, variables, true);
}
Function function_construct(Compiler* compiler_t, VariableState state, bool constr, vector<Variable> variables, bool is_member) {
      auto  function = Function(state);
   function. is_member= is_member;
   vector< Variable> variables_in_func= {};
      if(! constr    ) {
            auto  func_id = next_or_exit(compiler_t, "[FunctionError]: No Function Id");
            if(func_id . token  == Token :: Id  ) {
               
 function. id= func_id. name;
}
            else if(func_id . token  == Token :: Where  ) {
               
 function. id= func_id. name;
}
            else {
                  switch(func_id . token    ) {
                     case Token::And:
                     case Token::Or:
                     case Token::Sum:
                     case Token::Sub:
                     case Token::Bang:
                     case Token::Asterix:
                     case Token::DblLessThan:
                     case Token::DblMoreThan:
                     case Token::Equality:
                     case Token::NonEquality:
                     case Token::ForwardSlash:
                     case Token::LessThan:
                     case Token::LessThanOrEquals:
                     case Token::MoreThan:
                     case Token::MoreThanOrEquals:
                     function. id="operator"+ func_id. name;
                     break;
                     case Token::LBrack:
                     function. id="operator[]";
                     break;
                     default:
                      error ("Expected id or operator but got: " + to_string(func_id.name) + "", compiler_t->recap());
break ;
}
}
}
      auto  peeked_opt = compiler_t->peek();
      if(peeked_opt . is_none ()    ) {
         
 error ("Error when trying to parse function: " + to_string(function.id) + "", compiler_t->recap());
}
      if(peeked_opt . value_or (AstToken("NONE")) . token  == Token :: LessThan  ) {
         compiler_t-> next ();
         function. templates= template_construct (compiler_t);
}
      while(true   ) {
            auto  vnb = construct_args(compiler_t, true);
            if(! vnb . variable . has_minimum ()    ) {
               
 break;
}
         function. add_args (vnb.variable);
            if(vnb . is_end    ) {
               
 break;
}
}
      if(function . id  == "main"  ) {
         function. add_args (Variable("argc", "int"));
         function. add_args (Variable("argv[]", "char*"));
         function. return_value= Some (Variable("", "int"));
            
{
auto peeked_optional_value = compiler_t->peek();
if(peeked_optional_value.is_some()) {
auto peeked = peeked_optional_value.value_unsafe();
                  if(peeked . token  != Token :: NewLine  ) {
                     error ("Return value invalid on main function", compiler_t->recap());
}
}

}
}
      else {
         peeked_opt= compiler_t-> peek ();
            auto  is_do = peeked_opt.value_or(AstToken("NONE")).is_do();
         function. return_value= is_do ? Some (Variable(true)): Some (get_type(compiler_t));
}
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "Function is not closed " + to_string(function.id) + "");
            if(any (x.token, {Token::SemiColon, Token::Eof})    ) {
               
 break;
}
            if(x . token  == Token :: Function  ) {
                error ("Function above is not closed " + to_string(function.id) + "", compiler_t->recap());
break ;
}
            if(x . is_nl ()    ) {
               
 continue;
}
            switch(x . token    ) {
               case Token::Foreach:
               case Token::For:
                function. add_expr (for_construct(compiler_t, x.token == Token::Foreach));
break ;
               case Token::Condition:
                function. add_expr (condition_construct(compiler_t, x.name));
break ;
               case Token::Switch:
                function. add_expr (switch_construct(compiler_t));
break ;
               case Token::Select:
                function. add_expr (select_construct(compiler_t));
break ;
               case Token::Match:
                function. add_expr (match_construct(compiler_t));
break ;
               default:
                  auto  expr = expression_construct(compiler_t, x);
               function. add_expr (expr);
                  
{
auto declaration_optional_value = expr.e_declaration;
if(declaration_optional_value.is_some()) {
auto declaration = declaration_optional_value.value_unsafe();
                        for(int v_iterator = 0; v_iterator < variables_in_func.size(); v_iterator++) {
auto v = variables_in_func.at(v_iterator);                              if(v . id  == declaration . id  ) {
                                 error ("Multiple declarations with same name in function", compiler_t->recap());
}
}
                        for(int v_iterator = 0; v_iterator < variables.size(); v_iterator++) {
auto v = variables.at(v_iterator);                              if(v . id  == declaration . id  ) {
                                 error ("Variable already declared in class", compiler_t->recap());
}
}
                        for(int v_iterator = 0; v_iterator < function.arguments.size(); v_iterator++) {
auto v = function.arguments.at(v_iterator);                              if(v . id  == declaration . id  ) {
                                 error ("Variable already declared in function arguments", compiler_t->recap());
}
}
                     variables_in_func. push_back (declaration);
}

}
               break;
}
            if(x . is_do ()    ) {
               
 break;
}
}
      if(function . id  == "main"  ) {
         
 function. add_expr (Expression((string)"return 0"));
}
   validate_function (function, compiler_t);
   compiler_t-> add (function);
   return  function;
}
enum class ClassError: int {
   Closed,
   Definition,
   Duplicate,
   Extend,
   ExtendClosed,
   ExtendNoId,
   ExtendNotValid,
   Inheritance,
   InheritanceTemplate,
   InheritanceArguments,
   InheritanceReturnValue,
   InheritanceMissingFunc,
   NoId,
   NoInheritor,
   StaticNotValid,
   ConstNotValid,
   VirtualNotValid,
   DoubleDeclaration,
   DuplicateFunction,
};
string to_string(ClassError enumerator) {
switch (enumerator) {
case ClassError::Closed: return "Closed";
case ClassError::Definition: return "Definition";
case ClassError::Duplicate: return "Duplicate";
case ClassError::Extend: return "Extend";
case ClassError::ExtendClosed: return "ExtendClosed";
case ClassError::ExtendNoId: return "ExtendNoId";
case ClassError::ExtendNotValid: return "ExtendNotValid";
case ClassError::Inheritance: return "Inheritance";
case ClassError::InheritanceTemplate: return "InheritanceTemplate";
case ClassError::InheritanceArguments: return "InheritanceArguments";
case ClassError::InheritanceReturnValue: return "InheritanceReturnValue";
case ClassError::InheritanceMissingFunc: return "InheritanceMissingFunc";
case ClassError::NoId: return "NoId";
case ClassError::NoInheritor: return "NoInheritor";
case ClassError::StaticNotValid: return "StaticNotValid";
case ClassError::ConstNotValid: return "ConstNotValid";
case ClassError::VirtualNotValid: return "VirtualNotValid";
case ClassError::DoubleDeclaration: return "DoubleDeclaration";
case ClassError::DuplicateFunction: return "DuplicateFunction";
default: return "UNKNOWN TYPE";
}};
string c_err(ClassError err) {
   
return  c_err (err, EMPTY, false, "");
}
string c_err(ClassError err, string opt) {
   
return  c_err (err, opt, false, "");
}
string c_err(ClassError err, string opt, bool display, string recap) {
      string  msg = "[Class] ";
      switch(err    ) {
         case ClassError::Closed:
          msg+="Class is not closed ";
break ;
         case ClassError::Definition:
          msg+="Invalid class definition of: ";
break ;
         case ClassError::Duplicate:
          msg+="Duplicate instance of: ";
break ;
         case ClassError::Extend:
          msg+="Missing => after extend in: ";
break ;
         case ClassError::ExtendClosed:
          msg+="Error when trying to extend in: ";
break ;
         case ClassError::ExtendNoId:
          msg+="Missing id in extend: ";
break ;
         case ClassError::Inheritance:
          msg+="Invalid inheritance of: ";
break ;
         case ClassError::NoId:
          msg+="Invalid class declaration";
break ;
         case ClassError::NoInheritor:
          msg+="Invalid Inheritor Token\nExpected Id for inheritance for class: ";
break ;
         case ClassError::ExtendNotValid:
          msg+="Invalid class extendor: ";
break ;
         case ClassError::StaticNotValid:
          msg+="Cannot make this static: ";
break ;
         case ClassError::ConstNotValid:
          msg+="Cannot make this const: ";
break ;
         case ClassError::VirtualNotValid:
          msg+="Cannot make this virtual: ";
break ;
         case ClassError::DoubleDeclaration:
          msg+="Duplicate instance of variable: ";
break ;
         case ClassError::DuplicateFunction:
          msg+="Duplicate instance of function: ";
break ;
         case ClassError::InheritanceTemplate:
          msg+="Function inheritance template misaligned: ";
break ;
         case ClassError::InheritanceArguments:
          msg+="Function inheritance arguments misaligned: ";
break ;
         case ClassError::InheritanceReturnValue:
          msg+="Function inheritance return value misaligned: ";
break ;
         case ClassError::InheritanceMissingFunc:
          msg+="Function inheritance not found: ";
break ;
         default:
         
 break;
}
   msg+= opt;
      if(display    ) {
         
 error (msg, recap);
}
   return  msg;
}
void class_validate(Class class_def, Compiler* compiler_t) {
      if(compiler_t -> has_class (class_def.id)    ) {
         c_err (ClassError::Duplicate, class_def.id, true, compiler_t->recap());
}
      
{
auto inherit_optional_value = class_def.inherit;
if(inherit_optional_value.is_some()) {
auto inherit = inherit_optional_value.value_unsafe();
            
{
auto inherited_optional_value = compiler_t->get_class(inherit);
if(inherited_optional_value.is_some()) {
auto inherited = inherited_optional_value.value_unsafe();
                  for(int inherited_func_iterator = 0; inherited_func_iterator < inherited.functions.size(); inherited_func_iterator++) {
auto inherited_func = inherited.functions.at(inherited_func_iterator);                        if(! inherited_func . virtualness    ) {
                           
 continue;
}
                     bool inherits=false;
                        for(int func_iterator = 0; func_iterator < class_def.functions.size(); func_iterator++) {
auto func = class_def.functions.at(func_iterator);                              if(func . id  != inherited_func . id  ) {
                                 
 continue;
}
                              if(func . templates  != inherited_func . templates  ) {
                                 
 c_err (ClassError::InheritanceTemplate, "" + to_string(class_def.id) + "::" + to_string(inherited_func.id) + "", true, compiler_t->recap());
}
                              if(func . arguments . size ()  != inherited_func . arguments . size ()  ) {
                                 c_err (ClassError::InheritanceArguments, "" + to_string(class_def.id) + "::" + to_string(inherited_func.id) + " " + to_string(func.arguments.size()) + " " + to_string(inherited_func.arguments.size()) + "", true, compiler_t->recap());
}
                              for(int i = 0; i < inherited_func.arguments.size(); i++) {
auto inherited_arg = inherited_func.arguments.at(i);                                    if(func . arguments [ i ] . v_type  != inherited_arg . v_type  ) {
                                       
 c_err (ClassError::InheritanceArguments, "" + to_string(class_def.id) + "::" + to_string(inherited_func.id) + " " + to_string(func.arguments[i].v_type) + " " + to_string(inherited_arg.v_type) + "", true, compiler_t->recap());
}
}
                              if(func . return_value . value_or (Variable()) . v_type  != inherited_func . return_value . value_or (Variable()) . v_type  ) {
                                 c_err (ClassError::InheritanceReturnValue, "" + to_string(class_def.id) + "::" + to_string(inherited_func.id) + "", true, compiler_t->recap());
}
                           inherits=true;
}
                        if(! inherits    ) {
                           
 c_err (ClassError::InheritanceMissingFunc, "" + to_string(class_def.id) + "::" + to_string(inherited_func.id) + "", true, compiler_t->recap());
}
}
               return ;
}

}
         c_err (ClassError::Inheritance, class_def.id, true, compiler_t->recap());
}

}
}
void class_validate_function(Class* class_def, Function function, Compiler* compiler_t) {
      for(int f_iterator = 0; f_iterator < class_def->functions.size(); f_iterator++) {
auto f = class_def->functions.at(f_iterator);            if(! same_signature (f, function)    ) {
               
 continue;
}
            auto  name = function.id.size()==0?"constructor":function.id;
         c_err (ClassError::DuplicateFunction, "" + to_string(class_def->id) + "::" + to_string(name) + "", true, compiler_t->recap());
}
}
Class class_construct(Compiler* compiler_t, bool is_struct, CompilerPath paths) {
      auto  class_def = Class();
   class_def. is_struct= is_struct;
   class_def. id= id_or_exit (compiler_t, c_err(ClassError::NoId));
      auto  next = next_or_exit(compiler_t, c_err(ClassError::Definition, class_def.id));
      if(next . token  == Token :: LessThan  ) {
         class_def. templates= template_construct (compiler_t);
         next= next_or_exit (compiler_t, c_err(ClassError::Definition, class_def.id));
}
      if(next . token  == Token :: CoolArrow  ) {
         class_def. inherit= Some (id_or_exit(compiler_t, c_err(ClassError::NoInheritor, class_def.id)));
}
   class_internal_declarations (compiler_t, is_struct, &class_def, paths);
   class_validate (class_def, compiler_t);
   compiler_t-> add (class_def);
   return  class_def;
}
void class_internal_declarations(Compiler* compiler_t, bool is_struct, Class* class_def, CompilerPath paths) {
      auto  variable_state = !is_struct?VariableState::Private:VariableState::Public;
      while(true   ) {
            auto  next = next_or_exit(compiler_t, c_err(ClassError::Closed, class_def->id));
            bool  staticness = false;
            bool  constantness = false;
            bool  virtualness = false;
            if(next . token  == Token :: Static  ) {
               next= next_or_exit (compiler_t, c_err(ClassError::Closed, class_def->id));
                  if(none (next.token, {Token::Id, Token::Type, Token::Function, Token::Const})    ) {
                     c_err (ClassError::StaticNotValid, next.name, true, compiler_t->recap());
}
               staticness=true;
}
            if(next . token  == Token :: Const  ) {
               next= next_or_exit (compiler_t, c_err(ClassError::Closed, class_def->id));
                  if(none (next.token, {Token::Id, Token::Type})    ) {
                     c_err (ClassError::ConstNotValid, next.name, true, compiler_t->recap());
}
               constantness=true;
}
            if(next . token  == Token :: Virtual  ) {
               next= next_or_exit (compiler_t, c_err(ClassError::Closed, class_def->id));
                  if(next . token  != Token :: Function  ) {
                     
 c_err (ClassError::VirtualNotValid, next.name, true, compiler_t->recap());
}
               virtualness=true;
}
            if(next . token  == Token :: Extend  ) {
               arrow_or_exit (compiler_t, c_err(ClassError::Extend, class_def->id));
                  auto  extends = imports_construct_impl(compiler_t);
                  for(int extender_iterator = 0; extender_iterator < extends.size(); extender_iterator++) {
auto extender = extends.at(extender_iterator);                        
{
auto content_optional_value = read(paths.folder_path + extender + HA_SUFFIX);
if(content_optional_value.is_some()) {
auto content = content_optional_value.value_unsafe();
                              auto  ast = ast_create(content);
                              auto  extend_compiler = Compiler(compiler_t->program, ast, 0);
                           class_internal_declarations (&extend_compiler, is_struct, class_def, paths);
                           continue;
}

}
                     c_err (ClassError::ExtendNotValid, extender, true, compiler_t->recap());
}
}
            if(next . token  == Token :: Function  ) {
                  auto  function = function_construct(compiler_t, variable_state, false, class_def->variables);
               function. staticness= staticness;
               function. virtualness= virtualness;
               class_validate_function (class_def, function, compiler_t);
                class_def-> functions. push_back (function);
continue ;
}
            else if(any (next.token, {Token::Id, Token::Type})    ) {
                  if(next . name  == class_def -> id  ) {
                        auto  function = function_construct(compiler_t, VariableState::Public, true, class_def->variables);
                     function. return_value= Some (Variable(EMPTY, class_def->id));
                     class_validate_function (class_def, function, compiler_t);
                      class_def-> functions. push_back (function);
continue ;
}
                  auto  vnb = construct_args(compiler_t, Some(next.name));
               vnb. variable. variable_state= variable_state;
               vnb. variable. staticness= staticness;
               vnb. variable. constantness= constantness;
                  if(class_def -> contains (vnb.variable)    ) {
                     c_err (ClassError::DoubleDeclaration, vnb.variable.id, true, compiler_t->recap());
}
                class_def-> variables. push_back (vnb.variable);
continue ;
}
            else if(any (next.token, {Token::Eof, Token::SemiColon, Token::Class})    ) {
               
 break;
}
            switch(next . token    ) {
               case Token::Private:
                variable_state= VariableState:: Private;
break ;
               case Token::Protected:
                variable_state= VariableState:: Protected;
break ;
               case Token::Public:
                variable_state= VariableState:: Public;
break ;
               default:
               
 break;
}
}
}
Global global_construct(Compiler* compiler_t) {
      auto  global = Global();
      auto  variables = get_variables(compiler_t);
      for(int i_iterator = 0; i_iterator < variables.size(); i_iterator++) {
auto i = variables.at(i_iterator);         
 try_add_variable (compiler_t, &global, i);
}
   compiler_t-> add (global);
   return  global;
}
vector<Variable> get_variables(Compiler* compiler_t) {
   vector< Variable> variables= {};
      auto  variable = Variable();
      while(true   ) {
            auto  x = next_or_exit(compiler_t, "[Global]: Unexpected end of global");
            switch(x . token    ) {
               case Token::Eof:
               case Token::SemiColon:
               
return  variables;
               case Token::NewLine:
               variables. push_back (variable);
               variable= Variable ();
               break;
               default:
                  if(! variable . has_type ()    ) {
                      variable. v_type= x. name;
break ;
}
                  else if(! variable . has_id ()    ) {
                      variable. id= x. name;
break ;
}
               error ("[Global]: Variable is already finished", compiler_t->recap());
}
}
}
void try_add_variable(Compiler* compiler_t, Global* global, Variable variable) {
      if(! variable . has_minimum ()    ) {
         
return ;
}
      for(int v_iterator = 0; v_iterator < global->variables.size(); v_iterator++) {
auto v = global->variables.at(v_iterator);            if(v . v_type  == variable . v_type  ) {
               error ("[Global]: Multiple declarations of same value", compiler_t->recap());
}
}
      if(compiler_t -> has_glob (variable.v_type)    ) {
         error ("[Global]: Multiple declarations of same value", compiler_t->recap());
}
   global-> variables. push_back (variable);
}
struct CompileOutput {
 public:
   string output = "";
   string includes = "";
   string headers = "";
   string fnheaders = "";
   vector<string> arguments = {};
 public:
   string content() {
      
return  includes+ headers+ fnheaders+ output;
   }
   CompileOutput (string output, string includes, string headers, string fnheaders, vector<string> args) {
      this-> output= output;
      this-> includes= includes;
      this-> headers= headers;
      this-> fnheaders= fnheaders;
      this-> arguments= args;
   }
};
int main(int argc, char* argv[]) {
      auto  clap = Clap(argc, argv);
   FpFn fpfn= folder_and_name (get_file_path(argc, argv));
      auto  paths = CompilerPath(get_file_path(argc, argv), fpfn.f_p, fpfn.f_n);
      auto  p = Program();
      auto  output = compile_main(paths, &p);
   write_program (output.content(), paths);
      if(! clap . has ("-t")    ) {
         
 compile_program (paths, output.arguments, clap.has("-r"));
}
   return 0;
}
CompileOutput compile_main(CompilerPath paths, Program* p) {
   
return  compile (paths, p, true);
}
CompileOutput compile(CompilerPath paths, Program* p, bool is_main) {
   println ("compiling: " + paths.current);
      string  output = "";
      string  includes = "";
      string  headers = "";
      string  fnheaders = "";
      bool  is_named = false;
      auto  content = get_content(paths, !is_main);
      int  extralines = 0;
      if(is_main    ) {
         extralines= 5;
            string  extras = "\nfn to_string string value => string doremi value\n";
         extras+="\ninc => string\nuse => std\n";
         content= extras+ content;
}
      auto  ast = ast_create(content, extralines);
      auto  compiler_t = Compiler(p, ast, extralines);
   vector<string> incs= {};
   string args= EMPTY;
      while(true   ) {
            auto  next = next_or_exit(&compiler_t, "Compiler failed to do unexpected EOF");
            if(! next . is_base ()    ) {
               error ("Token not allowed in base: " + to_string(next.token) + "", compiler_t.recap());
}
            if(next . is_terminator ()    ) {
               
 break;
}
            else if(next . is_nl ()    ) {
               
 continue;
}
            else if(next . is_classy ()    ) {
                  auto  classdef = class_construct(&compiler_t, next.token == Token::Struct, paths);
               output+= classdef. to_cpp ();
               headers+= classdef. to_cpp_h ();
               continue;
}
{
   auto _match_expr_ = next.token;
if (_match_expr_ == Token::Named)  {
         if(is_named    ) {
            
 error ("[Named] cannot have nested namespaces", compiler_t.recap());
}

      is_named=true;

      arrow_or_exit (&compiler_t, "[Named] missing => in declaration");;

         auto  id = id_or_exit(&compiler_t, "[Named] cannot create namespace without Id");;

      output+="namespace " + to_string(id) + "\n"+"{\n";

}
else if (_match_expr_ == Token::Function)  {
         auto  fndef = function_construct(&compiler_t, VariableState::Public, false);

      output+= fndef. to_cpp (false);

      fnheaders+= fndef. to_cpp_h ();

}
else if (_match_expr_ == Token::Enum)  {
         auto  enumdef = enums_construct(&compiler_t);

      output+= enumdef. to_cpp ();

      headers+= enumdef. to_cpp_h ();

}
else if (_match_expr_ == Token::Global)  {
         auto  global = global_construct(&compiler_t);

      headers+= global. to_cpp ();

}
else if (_match_expr_ == Token::Include)  {
      incs= imports_creation (&compiler_t, next);

         for(int i_iterator = 0; i_iterator < incs.size(); i_iterator++) {
auto i = incs.at(i_iterator);            
 includes+= Include (i). to_cpp ();
}

}
else if (_match_expr_ == Token::Use)  {
      incs= imports_creation (&compiler_t, next);

         for(int i_iterator = 0; i_iterator < incs.size(); i_iterator++) {
auto i = incs.at(i_iterator);            
 includes+= Uses (i). to_cpp ();
}

}
else if (_match_expr_ == Token::Get)  {
      incs= imports_creation (&compiler_t, next);

         for(int i_iterator = 0; i_iterator < incs.size(); i_iterator++) {
auto i = incs.at(i_iterator);               auto  get_name = i+HA_SUFFIX;
               auto  get_file = resolve_get_path(paths.folder_path + get_name, get_name);
            FpFn fpfn= folder_and_name (get_file);
               auto  get_path = CompilerPath(get_file, fpfn.f_p, fpfn.f_n);
               auto  get_out = compile(get_path, p, false);
            output+= get_out. output;
            includes+= get_out. includes;
            headers+= get_out. headers;
            fnheaders+= get_out. fnheaders;
            compiler_t. add_args (get_out.arguments);
}

}
else if (_match_expr_ == Token::Compiler)  {
      arrow_or_exit (&compiler_t, "[Compiler] Missing start of compiler intent [=>]: " + to_string(next.name) + "");

      args= get_or_exit (&compiler_t, Token::String, "[Compiler] Missing value of compiler intent [TString]: " + to_string(next.name) + "");

      compiler_t. add_arg (args);

}
else if (_match_expr_ == Token::Raw)  {
      
 output+= next. name;

}
else {
      
 error ("Token not handled: " + to_string(next.name) + "", compiler_t.recap());

}
}
}
      if(is_named    ) {
         
 output+="\n}\n";
}
   validate_compiled (compiler_t, is_main);
   return  CompileOutput (output, includes, headers, fnheaders, compiler_t.arguments);
}
void validate_compiled(Compiler compiler, bool is_main) {
      bool  has_main = false;
      for(int f_iterator = 0; f_iterator < compiler.program->functions.size(); f_iterator++) {
auto f = compiler.program->functions.at(f_iterator);            if(f . id  == "main"  ) {
                has_main=true;
break ;
}
}
      if(! has_main    &&is_main    ) {
         
 hint ("Main function is not present!");
}
      if(has_main    &&! is_main    ) {
         
 hint ("Main function not in main file");
}
}
