#include <string>
#include <vector>
using namespace std;
#include <iostream>
using namespace std;
#include <vector>
#include <iostream>
using namespace std;
#include <fstream>
template <typename T>
struct Option;
template <typename T>
struct Peekable;
class String;

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

#define TOKEN_COLON ":"

#define TOKEN_COMMA ","

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

#define TOKEN_MORETHAN ">"

#define TOKEN_MORETHANOREQUALS ">="

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

#define TOKEN_STRING "string"

#define TOKEN_STRUCT "struct"

#define TOKEN_SUB "-"

#define TOKEN_SUM "+"

#define TOKEN_SWITCH "switch"

#define TOKEN_THREE "3"

#define TOKEN_TRUE "true"

#define TOKEN_TWO "2"

#define TOKEN_TYPE "char"

#define TOKEN_UNTIL "until"

#define TOKEN_USE "use"

#define TOKEN_WHILE "while"

#define TOKEN_ZERO "0"

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
enum class Token: int;
string to_string(Token enumerator);
struct Token_t;
enum class VariableState: int;
string to_string(VariableState enumerator);
struct AstToken;
struct CompilerPath;
enum class MessageSeverity: int;
string to_string(MessageSeverity enumerator);
struct FpFn;
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
struct Conditions;
struct Expressioner;
struct Function;
struct Class;
struct Program;
struct Compiler;
enum class EnumError: int;
string to_string(EnumError enumerator);
enum class ConditionError: int;
string to_string(ConditionError enumerator);
struct VariableNBool;
enum class ClassError: int;
string to_string(ClassError enumerator);
struct CompileOutput;
template <typename T>
Option<T> Some(T value);
template <typename T>
Option<T> None();
template <typename T>
void print(T s);
template <typename T>
void println(T s);
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
string variable_state_to_cpp(VariableState self);
void colored(MessageSeverity severity, string msg);
void display_message(MessageSeverity severity, string msg);
void display_hint_message(string msg);
void display_err_message(string msg);
AstToken get_next_or_exit(Option<AstToken> next, string s);
bool try_get(Option<AstToken> peek, Token token);
string get_or_exit(Option<AstToken> next, Token token, string s);
string get_id_or_exit(Option<AstToken> next, string s);
string get_arrow_or_exit(Option<AstToken> next, string s);
string get_eq_or_exit(Option<AstToken> next, string s);
FpFn get_folder_and_name(string file_path);
string get_file_path(int argc, char** argv);
string get_content(CompilerPath paths);
void write_program(string program, CompilerPath paths);
char* to_char_arr(string s, char* buf);
void compile_program(CompilerPath paths, vector<string> arguments, bool should_remove_cpp);
string expr_to_cpp(Expressioner* self, int indent);
vector<AstToken> ast_create(string content);
string try_add_token(string id, vector<AstToken>* ast, Peekable<char>* peekable);
bool is_str_tokens(string s);
bool is_char_token(char ch);
bool is_char_number(char ch);
Option<string> try_get_dbl(Peekable<char>* peekable, char ch);
string get_matching(Peekable<char>* peekable, char ch);
AstToken collect_num(Peekable<char>* peekable, char ch);
vector<string> imports_construct(Compiler* compiler_t);
vector<string> imports_construct_impl(Compiler* compiler_t);
vector<string> imports_creation(Compiler* compiler_t, AstToken next);
bool imports_check_duplicate(vector<string> imports, string id);
string e_err(EnumError err);
string e_err(EnumError err, string opt);
string e_err(EnumError err, string opt, bool display);
void validate_enum(Enum enumerator, Compiler* compiler_t);
Enum enums_construct(Compiler* compiler_t);
Expressioner for_construct(Compiler* compiler_t);
Expressioner expression_construct(Compiler* compiler_t, AstToken first);
Expressioner get_let_expr(Compiler* compiler_t);
Expressioner switch_construct(Compiler* compiler_t);
vector<Expressioner> create_case(Compiler* compiler_t, bool is_default);
string co_err(ConditionError err);
string co_err(ConditionError err, string opt);
string co_err(ConditionError err, string opt, bool display);
Expressioner condition_construct(Compiler* compiler_t, string condition_type);
Option<string> get_value(Compiler* compiler_t, bool found_setter);
Variable get_type(Compiler* compiler_t);
VariableNBool construct_args(Compiler* compiler_t);
VariableNBool construct_args(Compiler* compiler_t, Option<string> type_name);
vector<string> template_construct(Compiler* compiler_t);
void validate_function(Function function, Compiler* compiler_t);
Function function_construct(Compiler* compiler_t, VariableState state, bool constr);
string c_err(ClassError err);
string c_err(ClassError err, string opt);
string c_err(ClassError err, string opt, bool display);
void class_validate(Class class_def, Compiler* compiler_t);
Class class_construct(Compiler* compiler_t, bool is_struct);
Global global_construct(Compiler* compiler_t);
vector<Variable> get_variables(Compiler* compiler_t);
void try_add_variable(Compiler* compiler_t, Global* global, Variable variable);
int main(int argc, char* argv[]);
CompileOutput compile_main(CompilerPath paths, Program* p);
CompileOutput compile(CompilerPath paths, Program* p, bool is_main);
void validate_compiled(Compiler compiler, bool is_main);
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
      
return ! is_none();
   }
 public:
   T value_or(T value) {
      
return  is_some() ? _value: value;
   }
 public:
   string to_string() {
      
return  is_some() ?"Some("+ std:: to_string( _value)+")":"None";
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
   
return  Option< T>( value);
}
template <typename T>
Option<T> None() {
   
return  Option< T>();
}
template <typename T>
struct Peekable {
 private:
   vector<T> _values = {};
 private:
   int _index = 0;
 public:
   Peekable () {
   }
 public:
   Peekable (vector<T> values) {
      _values= values;
   }
 public:
   int index() {
      
return  _index;
   }
 public:
   int size() {
      
return  _values.size();
   }
 public:
   bool is_end() {
      
return  _index> _values.size()- 2;
   }
 public:
   bool is_begin() {
      
return  _index== 0;
   }
 public:
   Option<T> at(int at) {
      
return  Some( _values.at( at));
   }
 public:
   Option<T> prev() {
      
return ! is_begin() ? at(-- _index): None< T>();
   }
 public:
   Option<T> peek_prev() {
      
return ! is_begin() ? at( _index- 1): None< T>();
   }
 public:
   Option<T> next() {
      
return ! is_end() ? at( _index++): None< T>();
   }
 public:
   Option<T> peek() {
      
return ! is_end() ? at( _index): None< T>();
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
   String (string value) {
      this-> _value= value;
   }
 public:
   long len() {
      
return  _value.size();
   }
 public:
   char at(int at) {
      
return  _value.at( at);
   }
 public:
   void append(string value) {
      
 _value+= value;
   }
 public:
   string replace(string from, string to) {
      string replaced= _value;
         while(true   ) {
            size_t start_pos= replaced.find( from);
               if(start_pos  == - 1  ) {
                  
return  replaced;
}
            replaced.replace( start_pos, from.length(), to);
}
   }
 public:
   string replace(string from, string to, int amount) {
      string replaced= _value;
         for(int i = 0; i < amount; i++) {
            size_t start_pos= replaced.find( from);
               if(start_pos  == - 1  ) {
                  
return  replaced;
}
            replaced.replace( start_pos, from.length(), to);
}
      return  replaced;
   }
 public:
   bool contains(string contains) {
      
return  _value.find( contains)!=- 1;
   }
 public:
   bool starts_with(string start) {
      
return  _value.rfind( start, 0)== 0;
   }
 public:
   string substr(int start) {
      
return  _value.substr( start);
   }
 public:
   string substr(int start, int end) {
      
return  _value.substr( start, end);
   }
};
template <typename T>
bool any(T value, vector<T> values) {
      for(int i = 0; i < values.size(); i++) {
            if(value  == values.at ( i )  ) {
               
return true;
}
}
   return false;
}
template <typename T>
bool all(T value, vector<T> values) {
      for(int i = 0; i < values.size(); i++) {
            if(value  != values.at ( i )  ) {
               
return false;
}
}
   return true;
}
template <typename T>
bool none(T value, vector<T> values) {
      for(int i = 0; i < values.size(); i++) {
            if(value  == values.at ( i )  ) {
               
return false;
}
}
   return true;
}
template <typename T>
bool over(T value, vector<T> values) {
      for(int i = 0; i < values.size(); i++) {
            if(value  == values.at ( i )  ) {
               
return false;
}
            if(value  < values.at ( i )  ) {
               
return false;
}
}
   return true;
}
template <typename T>
bool under(T value, vector<T> values) {
      for(int i = 0; i < values.size(); i++) {
            if(value  == values.at ( i )  ) {
               
return false;
}
            if(value  > values.at ( i )  ) {
               
return false;
}
}
   return true;
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
   ForwardSlash,
   Function,
   Get,
   Global,
   Id,
   Include,
   LBlock,
   LBrack,
   LessThan,
   LessThanOrEquals,
   Let,
   LParen,
   MacroDefinition,
   MoreThan,
   MoreThanOrEquals,
   NewLine,
   NonEquality,
   Number,
   Or,
   Pointer,
   Private,
   Protected,
   Public,
   RBlock,
   RBrack,
   Return,
   RParen,
   SemiColon,
   String,
   Struct,
   Sub,
   Sum,
   Switch,
   True,
   Type,
   Until,
   Use,
   UNKNOWN,
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
case Token::ForwardSlash: return "ForwardSlash";
case Token::Function: return "Function";
case Token::Get: return "Get";
case Token::Global: return "Global";
case Token::Id: return "Id";
case Token::Include: return "Include";
case Token::LBlock: return "LBlock";
case Token::LBrack: return "LBrack";
case Token::LessThan: return "LessThan";
case Token::LessThanOrEquals: return "LessThanOrEquals";
case Token::Let: return "Let";
case Token::LParen: return "LParen";
case Token::MacroDefinition: return "MacroDefinition";
case Token::MoreThan: return "MoreThan";
case Token::MoreThanOrEquals: return "MoreThanOrEquals";
case Token::NewLine: return "NewLine";
case Token::NonEquality: return "NonEquality";
case Token::Number: return "Number";
case Token::Or: return "Or";
case Token::Pointer: return "Pointer";
case Token::Private: return "Private";
case Token::Protected: return "Protected";
case Token::Public: return "Public";
case Token::RBlock: return "RBlock";
case Token::RBrack: return "RBrack";
case Token::Return: return "Return";
case Token::RParen: return "RParen";
case Token::SemiColon: return "SemiColon";
case Token::String: return "String";
case Token::Struct: return "Struct";
case Token::Sub: return "Sub";
case Token::Sum: return "Sum";
case Token::Switch: return "Switch";
case Token::True: return "True";
case Token::Type: return "Type";
case Token::Until: return "Until";
case Token::Use: return "Use";
case Token::UNKNOWN: return "UNKNOWN";
default: return "UNKNOWN TYPE";
}};
struct Token_t {
 public:
   Token t = Token::Id;
 public:
   Token_t (string s) {
      auto S = String(s);
         if(S.starts_with ( QUOTE )    ) {
            
 t= Token:: String;
return ;
}
         else if(S.starts_with ( "'" )    ) {
            
 t= Token:: Char;
return ;
}
         else if(s  == TOKEN_ALLEQUALS  ) {
            
 t= Token:: AllEquals;
return ;
}
         else if(s  == TOKEN_ALLLESSOREQUALS  ) {
            
 t= Token:: AllLessOrEquals;
return ;
}
         else if(s  == TOKEN_ALLLESSTHAN  ) {
            
 t= Token:: AllLessThan;
return ;
}
         else if(s  == TOKEN_ALLMOREOREQUALS  ) {
            
 t= Token:: AllMoreOrEquals;
return ;
}
         else if(s  == TOKEN_ALLMORETHAN  ) {
            
 t= Token:: AllMoreThan;
return ;
}
         else if(s  == TOKEN_ALLNOTEQUALS  ) {
            
 t= Token:: AllNotEquals;
return ;
}
         else if(s  == TOKEN_AND  ) {
            
 t= Token:: And;
return ;
}
         else if(s  == TOKEN_ANYEQUALS  ) {
            
 t= Token:: AnyEquals;
return ;
}
         else if(s  == TOKEN_ASTERIX  ) {
            
 t= Token:: Asterix;
return ;
}
         else if(s  == TOKEN_BANG  ) {
            
 t= Token:: Bang;
return ;
}
         else if(s  == TOKEN_CASE  ) {
            
 t= Token:: Case;
return ;
}
         else if(s  == TOKEN_CLASS  ) {
            
 t= Token:: Class;
return ;
}
         else if(s  == TOKEN_COLON  ) {
            
 t= Token:: Colon;
return ;
}
         else if(s  == TOKEN_COMMA  ) {
            
 t= Token:: Comma;
return ;
}
         else if(s  == TOKEN_COMPILER  ) {
            
 t= Token:: Compiler;
return ;
}
         else if(s  == TOKEN_COOLARROW  ) {
            
 t= Token:: CoolArrow;
return ;
}
         else if(s  == TOKEN_DBLCOLON  ) {
            
 t= Token:: DblColon;
return ;
}
         else if(s  == TOKEN_DBLLESSTHAN  ) {
            
 t= Token:: DblLessThan;
return ;
}
         else if(s  == TOKEN_DBLMORETHAN  ) {
            
 t= Token:: DblMoreThan;
return ;
}
         else if(s  == TOKEN_DEFAULT  ) {
            
 t= Token:: Default;
return ;
}
         else if(s  == TOKEN_DO  ) {
            
 t= Token:: Do;
return ;
}
         else if(s  == TOKEN_DOBR  ) {
            
 t= Token:: Dobr;
return ;
}
         else if(s  == TOKEN_DOCO  ) {
            
 t= Token:: Doco;
return ;
}
         else if(s  == TOKEN_DORE  ) {
            
 t= Token:: Dore;
return ;
}
         else if(s  == TOKEN_DOREMI  ) {
            
 t= Token:: Doremi;
return ;
}
         else if(s  == TOKEN_ENUM  ) {
            
 t= Token:: Enum;
return ;
}
         else if(s  == TOKEN_EOF  ) {
            
 t= Token:: Eof;
return ;
}
         else if(s  == TOKEN_EQUALITY  ) {
            
 t= Token:: Equality;
return ;
}
         else if(s  == TOKEN_EQUALS  ) {
            
 t= Token:: Equals;
return ;
}
         else if(s  == TOKEN_EXTEND  ) {
            
 t= Token:: Extend;
return ;
}
         else if(s  == TOKEN_FALSE  ) {
            
 t= Token:: False;
return ;
}
         else if(s  == TOKEN_FORWARDSLASH  ) {
            
 t= Token:: ForwardSlash;
return ;
}
         else if(s  == TOKEN_FUNCTION  ) {
            
 t= Token:: Function;
return ;
}
         else if(s  == TOKEN_GET  ) {
            
 t= Token:: Get;
return ;
}
         else if(s  == TOKEN_GLOBAL  ) {
            
 t= Token:: Global;
return ;
}
         else if(s  == TOKEN_INCLUDE  ) {
            
 t= Token:: Include;
return ;
}
         else if(s  == TOKEN_LBLOCK  ) {
            
 t= Token:: LBlock;
return ;
}
         else if(s  == TOKEN_LBRACK  ) {
            
 t= Token:: LBrack;
return ;
}
         else if(s  == TOKEN_LESSTHAN  ) {
            
 t= Token:: LessThan;
return ;
}
         else if(s  == TOKEN_LESSTHANOREQUALS  ) {
            
 t= Token:: LessThanOrEquals;
return ;
}
         else if(s  == TOKEN_LET  ) {
            
 t= Token:: Let;
return ;
}
         else if(s  == TOKEN_LINE_COMMENT  ) {
            
 t= Token:: Comment;
return ;
}
         else if(s  == TOKEN_LPAREN  ) {
            
 t= Token:: LParen;
return ;
}
         else if(s  == TOKEN_MACRODEFINITION  ) {
            
 t= Token:: MacroDefinition;
return ;
}
         else if(s  == TOKEN_MORETHAN  ) {
            
 t= Token:: MoreThan;
return ;
}
         else if(s  == TOKEN_MORETHANOREQUALS  ) {
            
 t= Token:: MoreThanOrEquals;
return ;
}
         else if(s  == TOKEN_NEWLINE  ) {
            
 t= Token:: NewLine;
return ;
}
         else if(s  == TOKEN_NONEQUALITY  ) {
            
 t= Token:: NonEquality;
return ;
}
         else if(s  == TOKEN_OR  ) {
            
 t= Token:: Or;
return ;
}
         else if(s  == TOKEN_POINTER  ) {
            
 t= Token:: Pointer;
return ;
}
         else if(s  == TOKEN_PRIVATE  ) {
            
 t= Token:: Private;
return ;
}
         else if(s  == TOKEN_PROTECTED  ) {
            
 t= Token:: Protected;
return ;
}
         else if(s  == TOKEN_PUBLIC  ) {
            
 t= Token:: Public;
return ;
}
         else if(s  == TOKEN_RBLOCK  ) {
            
 t= Token:: RBlock;
return ;
}
         else if(s  == TOKEN_RBRACK  ) {
            
 t= Token:: RBrack;
return ;
}
         else if(s  == TOKEN_RETURN  ) {
            
 t= Token:: Return;
return ;
}
         else if(s  == TOKEN_RPAREN  ) {
            
 t= Token:: RParen;
return ;
}
         else if(s  == TOKEN_SEMICOLON  ) {
            
 t= Token:: SemiColon;
return ;
}
         else if(s  == TOKEN_STRUCT  ) {
            
 t= Token:: Struct;
return ;
}
         else if(s  == TOKEN_SUB  ) {
            
 t= Token:: Sub;
return ;
}
         else if(s  == TOKEN_SUM  ) {
            
 t= Token:: Sum;
return ;
}
         else if(s  == TOKEN_SWITCH  ) {
            
 t= Token:: Switch;
return ;
}
         else if(s  == TOKEN_TRUE  ) {
            
 t= Token:: True;
return ;
}
         else if(s  == TOKEN_UNTIL  ) {
            
 t= Token:: Until;
return ;
}
         else if(s  == TOKEN_USE  ) {
            
 t= Token:: Use;
return ;
}
         else if(any ( s , { TOKEN_WHILE , TOKEN_LOOP } )    ) {
            
 t= Token:: Condition;
return ;
}
         else if(any ( s , { TOKEN_IFS , TOKEN_ELIF , TOKEN_ELSE } )    ) {
            
 t= Token:: Condition;
return ;
}
         else if(any ( s , { TOKEN_ZERO , TOKEN_ONE , TOKEN_TWO } )    ) {
            
 t= Token:: Number;
return ;
}
         else if(any ( s , { TOKEN_THREE , TOKEN_FOUR , TOKEN_FIVE } )    ) {
            
 t= Token:: Number;
return ;
}
         else if(any ( s , { TOKEN_SIX , TOKEN_SEVEN , TOKEN_EIGHT , TOKEN_NINE } )    ) {
            
 t= Token:: Number;
return ;
}
         else if(any ( s , { TOKEN_FOR , TOKEN_FOREACH } )    ) {
            
 t= Token:: For;
return ;
}
         else if(any ( s , { TOKEN_INT , TOKEN_STR , TOKEN_STRING } )    ) {
            
 t= Token:: Type;
return ;
}
      t= Token:: Id;
   }
 public:
   bool is_id() {
      
return  t== Token:: Id;
   }
 public:
   bool is_nl() {
      
return  t== Token:: NewLine;
   }
 public:
   bool is_bool() {
      
return  any( t,{ Token:: False, Token:: True});
   }
 public:
   bool is_num() {
      
return  t== Token:: Number;
   }
 public:
   bool is_float() {
      
return  t== Token:: Float;
   }
 public:
   bool is_char() {
      
return  t== Token:: Char;
   }
 public:
   bool is_string() {
      
return  t== Token:: String;
   }
 public:
   bool is_classy() {
      
return  any( t,{ Token:: Class, Token:: Struct});
   }
 public:
   bool is_terminator() {
      
return  any( t,{ Token:: SemiColon, Token:: Eof});
   }
 public:
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
            case Token::NewLine:
            case Token::SemiColon:
            case Token::Struct:
            case Token::Use:
            
return true;
            default:
;
            
return false;
}
   }
 public:
   bool is_do() {
         switch(t    ) {
            case Token::Do:
            case Token::Dobr:
            case Token::Doco:
            case Token::Dore:
            case Token::Doremi:
            
return true;
            default:
;
            
return false;
}
   }
 public:
   bool is_conditional() {
         switch(t    ) {
            case Token::AllEquals:
            case Token::AllLessOrEquals:
            case Token::AllLessThan:
            case Token::AllMoreOrEquals:
            case Token::AllMoreThan:
            case Token::AllNotEquals:
            case Token::AnyEquals:
            case Token::Equality:
            case Token::LessThan:
            case Token::LessThanOrEquals:
            case Token::MoreThan:
            case Token::MoreThanOrEquals:
            case Token::NonEquality:
            
return true;
            default:
;
            
return false;
}
   }
 public:
   bool is_conditional_sep() {
      
return  any( t,{ Token:: And, Token:: Or});
   }
 public:
   bool valid_case() {
      
return  any( t,{ Token:: Id, Token:: Number, Token:: Char});
   }
 public:
   string as_str() {
      
return  to_string( t);
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
;
         
return  PRIVATE_STATE;
}
}
struct AstToken {
 public:
   string name = EMPTY;
 public:
   Token token = Token::Id;
 public:
   Token_t t = Token_t("\n");
 public:
   AstToken () {
   }
 public:
   AstToken (string id) {
      this-> name= id;
      this-> t= Token_t( name);
      this-> token= t.t;
   }
 public:
   AstToken (char ch) {
      string buf( 1, ch);
      this-> name= buf;
      this-> t= Token_t( name);
      this-> token= t.t;
   }
 public:
   string to_string() {
      
return "["+ name+"]: Token: "+ t.as_str();
   }
 public:
   bool is_classy() {
      
return  t.is_classy();
   }
 public:
   bool is_id() {
      
return  t.is_id();
   }
 public:
   bool is_nl() {
      
return  t.is_nl();
   }
 public:
   bool is_bool() {
      
return  t.is_bool();
   }
 public:
   bool is_num() {
      
return  t.is_num();
   }
 public:
   bool is_float() {
      
return  t.is_float();
   }
 public:
   bool is_char() {
      
return  t.is_char();
   }
 public:
   bool is_string() {
      
return  t.is_string();
   }
 public:
   bool is_terminator() {
      
return  t.is_terminator();
   }
 public:
   bool is_base() {
      
return  t.is_base();
   }
 public:
   bool is_do() {
      
return  t.is_do();
   }
 public:
   bool is_conditional() {
      
return  t.is_conditional();
   }
 public:
   bool is_conditional_sep() {
      
return  t.is_conditional_sep();
   }
 public:
   bool valid_case() {
      
return  t.valid_case();
   }
};
struct CompilerPath {
 public:
   string folder_path = EMPTY;
 public:
   string file_path = EMPTY;
 public:
   string main_path = EMPTY;
 public:
   string main_path_cpp = EMPTY;
 public:
   string main_path_bin = EMPTY;
 public:
   string output = EMPTY;
 public:
   string current = EMPTY;
 public:
   CompilerPath (string main, string f_p, string f_n) {
      auto main_str = String(main);
      string cpp= main_str.replace( HA_SUFFIX, CPP_SUFFIX);
      string bin= main_str.replace( HA_SUFFIX, EMPTY);
      this-> folder_path= f_p;
      this-> file_path= f_n;
      this-> main_path= main;
      this-> main_path_cpp= cpp;
      this-> main_path_bin= bin;
      this-> output= cpp+ COMPILER_OUT+ bin;
      this-> current= f_p+ f_n;
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
void colored(MessageSeverity severity, string msg) {
   string color= EMPTY;
      switch(severity    ) {
         case MessageSeverity::Hint:
          color="\033[34m";
break ;
         case MessageSeverity::Error:
          color="\033[31m";
break ;
}
   println( color+"["+ to_string( severity)+"] >> "+ msg+"\033[0m");
}
void display_message(MessageSeverity severity, string msg) {
   
 colored( severity, msg);
}
void display_hint_message(string msg) {
   
 display_message( MessageSeverity:: Hint, msg);
}
void display_err_message(string msg) {
   display_message( MessageSeverity:: Error, msg);
   exit( 1);
}
struct FpFn {
 public:
   string f_p = EMPTY;
 public:
   string f_n = EMPTY;
 public:
   FpFn () {
   }
 public:
   FpFn (string f_p, string f_n) {
      this-> f_p= f_p;
      this-> f_n= f_n;
   }
};
AstToken get_next_or_exit(Option<AstToken> next, string s) {
      if(next.is_none ( )    ) {
         
 display_err_message( s);
}
   return  next.value_or( AstToken());
}
bool try_get(Option<AstToken> peek, Token token) {
      if(peek.is_none ( )    ) {
         
return false;
}
   return  peek.value_or( AstToken()) .token== token;
}
string get_or_exit(Option<AstToken> next, Token token, string s) {
      if(next.is_none ( )    ||next.value_or ( AstToken ( ) ) .token  != token  ) {
         
 display_err_message( s);
}
   return  next.value_or( AstToken()) .name;
}
string get_id_or_exit(Option<AstToken> next, string s) {
   
return  get_or_exit( next, Token:: Id, s);
}
string get_arrow_or_exit(Option<AstToken> next, string s) {
   
return  get_or_exit( next, Token:: CoolArrow, s);
}
string get_eq_or_exit(Option<AstToken> next, string s) {
   
return  get_or_exit( next, Token:: Equals, s);
}
FpFn get_folder_and_name(string file_path) {
   string file_name= EMPTY;
   string reversed= EMPTY;
   string folder_path= file_path;
      while(true   ) {
            if(folder_path.size ( )  == 0  ) {
               
 break;
}
         auto ch = folder_path.back();
         folder_path.pop_back();
            if(ch  == '/'  ) {
                folder_path.push_back('/');
break ;
}
         file_name.push_back( ch);
}
      while(file_name.size ( )  > 0  ) {
         reversed.push_back( file_name.back());
         file_name.pop_back();
}
   file_name= reversed;
   return  FpFn( folder_path, file_name);
}
string get_file_path(int argc, char** argv) {
      if(argc  < 2  ) {
         
 display_err_message("No file path supplied in arguments!\nExiting...");
}
   string fp= EMPTY;
   int i = 0;
      while(argv [ 1 ] [ i ]  != '\0'  ) {
         
 fp.push_back( argv[ 1][ i++]);
}
   return  fp;
}
string get_content(CompilerPath paths) {
   string content, linebuf;
   ifstream reader( paths.current);
      if(! reader    ) {
         
 display_err_message("Couldn't open file\nExiting...");
}
      while(! reader.eof ( )    ) {
         getline( reader, linebuf);
         content+= linebuf+"\n";
}
   return  content;
}
void write_program(string program, CompilerPath paths) {
   ofstream file( paths.main_path_cpp);
   file<< program;
   file.close();
}
char* to_char_arr(string s, char* buf) {
      for(int i = 0; i < s.size(); i++) {
         
 buf[ i]= s.at( i);
}
   buf[ s.size()]='\0';
   return  buf;
}
void compile_program(CompilerPath paths, vector<string> arguments, bool should_remove_cpp) {
   string base_cmd="g++ "+ paths.output;
      for(int i = 0; i < arguments.size(); i++) {
         
 base_cmd+=" "+ arguments.at( i);
}
   println("compiling: "+ base_cmd);
   char cmd[ base_cmd.size()+ 1];
   char cpp_path[ paths.main_path_cpp.size()+ 1];
   system( to_char_arr( base_cmd, cmd));
      if(should_remove_cpp    ) {
         
 remove( to_char_arr( paths.main_path_cpp, cpp_path));
}
}
struct Variable {
 public:
   string id = EMPTY;
 public:
   string v_type = EMPTY;
 public:
   Option<string> v_value = None<string>();
 public:
   VariableState variable_state = VariableState::Private;
 public:
   Variable () {
   }
 public:
   Variable (string id, string type) {
      this-> id= id;
      this-> v_type= type;
   }
 public:
   Variable (string id, string type, Option<string> value, VariableState state) {
      this-> id= id;
      this-> v_type= type;
      this-> v_value= value;
      this-> variable_state= state;
   }
 public:
   Variable (bool is_void) {
      this-> id= RETURN_VALUE_IDS;
      this-> v_type= VOID;
   }
 public:
   bool has_id() {
      
return  id.size()!= 0;
   }
 public:
   bool has_type() {
      
return  v_type.size()!= 0;
   }
 public:
   bool has_minimum() {
      
return  has_id()&& has_type();
   }
 public:
   string to_cpp(string spacing, string new_line) {
      string base= spacing+ v_type+ SPACE+ id;
      base+= v_value.is_some() ? ASSIGNMENT: EMPTY;
      base+= v_value.value_or( EMPTY)+ new_line;
      return  base;
   }
};
struct EnumValue {
 public:
   string name = EMPTY;
 public:
   Option<string> value = None<string>();
 public:
   EnumValue () {
   }
};
struct Enum {
 public:
   string name = EMPTY;
 public:
   vector<EnumValue> enums = {};
 public:
   Enum (string enum_name) {
      this-> name= enum_name;
   }
 public:
   string to_cpp_string_start() {
      
return "string to_string("+ name+" enumerator)";
   }
 public:
   string to_cpp_start() {
      
return  ENUM+ name+": int";
   }
 public:
   string to_cpp_h() {
      
return  to_cpp_start()+ LINE_END+ to_cpp_string_start()+ LINE_END;
   }
 public:
   string to_cpp() {
      string enum_str= to_cpp_start()+ BLOCK_START;
         for(int i = 0; i < enums.size(); i++) {
            auto e = enums.at(i);
            enum_str+= TAB+ e.name;
            enum_str+= e.value.is_some() ? ASSIGNMENT+ e.value.value_or( EMPTY): EMPTY;
            enum_str+= ENUM_SEP;
}
      enum_str+= RBRACK;
      enum_str+= LINE_END;
      enum_str+= to_cpp_string_start()+ BLOCK_START;
      enum_str+="switch (enumerator) {\n";
         for(int i = 0; i < enums.size(); i++) {
            auto e = enums.at(i);
            enum_str+="case "+ name;
            enum_str+="::"+ e.name;
            enum_str+=": return \""+ e.name+"\";\n";
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
 public:
   string to_cpp() {
      auto is_quoted = String(include).starts_with(QUOTE);
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
 public:
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
   }
 public:
   string to_cpp() {
      string g_str= EMPTY;
         for(int i = 0; i < variables.size(); i++) {
            auto v = variables.at(i);
            g_str+= NEWLINE;
            g_str+= GLOBAL+ v.v_type;
            g_str+= SPACE+ v.id;
            g_str+= NEWLINE;
}
      return  g_str;
   }
};
struct Struct {
 public:
   string id = EMPTY;
 public:
   vector<Variable> variables = {};
};
struct For {
 public:
   string iterator = EMPTY;
 public:
   string until = EMPTY;
 public:
   vector<Expressioner> lines = {};
 public:
   For () {
   }
 public:
   string to_cpp(int indent) {
      string for_str= EMPTY;
         for(int i = 0; i < indent; i++) {
            
 for_str+= TAB;
}
      for_str+= FOR_START+ iterator;
      for_str+= FOR_MID+ iterator;
      for_str+= FOR_UNTIL+until;
      for_str+= FOR_AFTER_UNTIL+ iterator+ FOR_END;
         for(int i = 0; i < lines.size(); i++) {
            
 for_str+= expr_to_cpp( &lines.at( i), indent+ 1);
}
      for_str+= BLOCK_END;
      return  for_str;
   }
};
struct ConditionalExpression {
 public:
   string value_left = EMPTY;
 public:
   string value_right = EMPTY;
 public:
   string operator_value = EMPTY;
 public:
   string continuation = EMPTY;
 public:
   ConditionalExpression () {
   }
 public:
   string to_cpp() {
      auto expr_str = value_left+SPACE;
      expr_str+= operator_value+ SPACE;
      expr_str+= value_right+ SPACE+ continuation;
      return  expr_str;
   }
};
struct Conditions {
 public:
   string conditioner = EMPTY;
 public:
   vector<ConditionalExpression> expressions = {};
 public:
   vector<Expressioner> lines = {};
 public:
   Conditions () {
   }
 public:
   Conditions (string conditioner) {
      this-> conditioner= conditioner;
   }
 public:
   void add_expr(ConditionalExpression cexpr) {
      
 expressions.push_back( cexpr);
   }
 public:
   string to_cpp(int indentation) {
      string condition_str= EMPTY;
         for(int i = 0; i < indentation; i++) {
            
 condition_str+= TAB;
}
      condition_str+= conditioner;
         if(conditioner  != TOKEN_ELSE  ) {
            condition_str+= LPAREN;
               for(int i = 0; i < expressions.size(); i++) {
                  
 condition_str+= expressions.at( i) .to_cpp();
}
            condition_str+= RPAREN;
}
      condition_str+= BLOCK_START;
         for(int i = 0; i < lines.size(); i++) {
            
 condition_str+= expr_to_cpp( &lines.at( i), indentation+ 1);
}
      condition_str+= BLOCK_END;
      return  condition_str;
   }
};
struct Expressioner {
 public:
   Option<Conditions> e_condition = None<Conditions>();
 public:
   Option<For> e_for = None<For>();
 public:
   Option<string> line = None<string>();
 public:
   Expressioner () {
   }
 public:
   Expressioner (Conditions conditions) {
      this-> e_condition= Some( conditions);
   }
 public:
   Expressioner (For fors) {
      this-> e_for= Some( fors);
   }
 public:
   Expressioner (string line) {
      this-> line= Some( line);
   }
 public:
   Expressioner (Option<Conditions> conditions, Option<For> fors, Option<string> line) {
      this-> e_condition= conditions;
      this-> e_for= fors;
      this-> line= line;
   }
 public:
   string to_cpp(int indentation) {
      
return  expr_to_cpp( this, indentation);
   }
};
string expr_to_cpp(Expressioner* self, int indent) {
   auto condition = self->e_condition;
   auto foreacher = self->e_for;
   auto line = self->line;
   string expression= EMPTY;
      if(condition.is_some ( )    ) {
         
return  condition.value_or( Conditions()) .to_cpp( indent+ 1);
}
      if(foreacher.is_some ( )    ) {
         
return  foreacher.value_or( For()) .to_cpp( indent+ 1);
}
      for(int i = 0; i < indent; i++) {
         
 expression+= TAB;
}
   auto line_value = line.value_or(EMPTY);
   auto line_str = String(line_value);
      if(line_value.size ( )  != 0  ) {
         expression+= line_value;
            if(! line_str.starts_with ( "case " )    ) {
               
 expression+= LINE_END;
}
}
   return  expression;
}
struct Function {
 public:
   string id = EMPTY;
 public:
   VariableState variable_state = VariableState::Public;
 public:
   Option<Variable> return_value = None<Variable>();
 public:
   vector<Variable> arguments = {};
 public:
   vector<Expressioner> expressions = {};
 public:
   vector<string> templates = {};
 public:
   Function (VariableState state) {
      this-> variable_state= state;
   }
 public:
   void add_args(Variable var) {
      
 arguments.push_back( var);
   }
 public:
   void add_expr(Expressioner expr) {
      
 expressions.push_back( expr);
   }
 public:
   string to_cpp_start(bool in_class) {
      string fun_str= templates.size()> 0 ? TEMPLATE: EMPTY;
         for(int i = 0; i < templates.size(); i++) {
            fun_str+= templates.at( i);
            fun_str+= i+ 1< templates.size() ? TEMPLATE_MID: TEMPLATE_END;
}
      fun_str+= in_class ? TAB: EMPTY;
      fun_str+= return_value.value_or( Variable(true)) .v_type;
      fun_str+= SPACE+ id+ LPAREN;
         for(int i = 0; i < arguments.size(); i++) {
            fun_str+= arguments.at( i) .to_cpp( EMPTY, EMPTY);
            fun_str+= i+ 1< arguments.size() ? ARG_SEP: EMPTY;
}
      fun_str+= RPAREN;
      return  fun_str;
   }
 public:
   string to_cpp_h() {
      
return  to_cpp_start(false)+ LINE_END;
   }
 public:
   string to_cpp(bool in_class) {
      string fun_str= to_cpp_start( in_class);
      fun_str+= BLOCK_START;
         for(int i = 0; i < expressions.size(); i++) {
            fun_str+= expressions.at( i) .to_cpp( 1+ in_class);
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
 public:
   string id = EMPTY;
 public:
   Option<string> inherit = None<string>();
 public:
   vector<Function> functions = {};
 public:
   vector<Variable> variables = {};
 public:
   vector<string> templates = {};
 public:
   string to_cpp_start() {
      string class_str= templates.size()> 0 ? TEMPLATE: EMPTY;
         for(int i = 0; i < templates.size(); i++) {
            class_str+= templates.at( i);
            class_str+= i+ 1< templates.size() ? TEMPLATE_MID: TEMPLATE_END;
}
      class_str+= is_struct ? STRUCT: CLASS;
      class_str+= id;
      class_str+= inherit.is_some() ? INHERIT: EMPTY;
      class_str+= inherit.value_or( EMPTY);
      return  class_str;
   }
 public:
   string to_cpp_h() {
      
return  to_cpp_start()+ LINE_END;
   }
 public:
   string to_cpp() {
      string class_str= to_cpp_start();
      class_str+= BLOCK_START;
         for(int i = 0; i < variables.size(); i++) {
            auto v = variables.at(i);
            class_str+= variable_state_to_cpp( v.variable_state);
            class_str+= v.to_cpp( TAB, LINE_END);
}
         for(int i = 0; i < functions.size(); i++) {
            auto f = functions.at(i);
            class_str+= variable_state_to_cpp( f.variable_state);
            class_str+= f.to_cpp(true);
}
      class_str+= RBRACK;
      class_str+= LINE_END;
      return  class_str;
   }
};
struct Program {
 public:
   vector<Global> global = {};
 public:
   vector<Struct> structs = {};
 public:
   vector<Function> functions = {};
 public:
   vector<Class> classes = {};
 public:
   vector<Include> includes = {};
 public:
   vector<Uses> usings = {};
 public:
   vector<Enum> enums = {};
 public:
   Program () {
   }
};
struct Compiler {
 public:
   Program* program;
 public:
   Peekable<AstToken> ast;
 public:
   vector<string> arguments = {};
 public:
   Compiler (Program* p, Peekable<AstToken> ast) {
      this-> program= p;
      this-> ast= ast;
   }
 public:
   int size() {
      
return  ast.size();
   }
 public:
   Option<AstToken> next() {
      
return  ast.next();
   }
 public:
   Option<AstToken> peek() {
      
return  ast.peek();
   }
 public:
   Option<AstToken> prev() {
      
return  ast.prev();
   }
 public:
   void add_fn(Function function) {
      
 program-> functions.push_back( function);
   }
 public:
   void add_class(Class class_obj) {
      
 program-> classes.push_back( class_obj);
   }
 public:
   void add_enum(Enum enum_def) {
      
 program-> enums.push_back( enum_def);
   }
 public:
   void add_glob(Global global) {
      
 program-> global.push_back( global);
   }
 public:
   void add_inc(vector<string> includes) {
         for(int i = 0; i < includes.size(); i++) {
            
 program-> includes.push_back( Include( includes.at( i)));
}
   }
 public:
   void add_use(vector<string> usings) {
         for(int i = 0; i < usings.size(); i++) {
            
 program-> usings.push_back( Uses( usings.at( i)));
}
   }
 public:
   void add_arg(string arg) {
      
 arguments.push_back( String( arg) .replace( QUOTE, EMPTY));
   }
 public:
   void add_args(vector<string> args) {
         for(int i = 0; i < args.size(); i++) {
            
 arguments.push_back( args.at( i));
}
   }
 public:
   bool has_use(string id) {
         for(int i = 0; i < program->usings.size(); i++) {
               if(program -> usings.at ( i ) .usings  == id  ) {
                  
return true;
}
}
      return false;
   }
 public:
   bool has_function(string id) {
         for(int i = 0; i < program->functions.size(); i++) {
               if(program -> functions.at ( i ) .id  == id  ) {
                  
return true;
}
}
      return false;
   }
 public:
   bool has_class(string id) {
         for(int i = 0; i < program->classes.size(); i++) {
               if(program -> classes.at ( i ) .id  == id  ) {
                  
return true;
}
}
      return false;
   }
 public:
   bool has_inc(string id) {
         for(int i = 0; i < program->includes.size(); i++) {
               if(program -> includes.at ( i ) .include  == id  ) {
                  
return true;
}
}
      return false;
   }
 public:
   bool has_enum(string id) {
         for(int i = 0; i < program->enums.size(); i++) {
               if(program -> enums.at ( i ) .name  == id  ) {
                  
return true;
}
}
      return false;
   }
 public:
   bool has_glob(string id) {
         for(int i = 0; i < program->global.size(); i++) {
            auto g = program->global.at(i);
               for(int j = 0; j < g.variables.size(); j++) {
                     if(g.variables.at ( j ) .v_type  == id  ) {
                        
return true;
}
}
}
      return false;
   }
 public:
   bool has_enum_name(string id) {
         for(int i = 0; i < program->enums.size(); i++) {
            auto e = program->enums.at(i);
               for(int j = 0; j < e.enums.size(); j++) {
                     if(e.enums.at ( j ) .name  == id  ) {
                        
return true;
}
}
}
      return false;
   }
};
vector<AstToken> ast_create(string content) {
   vector< char> vec={};
      for(int i = 0; i < content.size(); i++) {
         
 vec.push_back( content[ i]);
}
   auto peekable = Peekable<char>(vec);
   string id= EMPTY;
   vector< AstToken> ast={};
      while(true   ) {
         auto c_opt = peekable.next();
         auto last_known_index = peekable.index();
            if(c_opt.is_none ( )    ) {
                try_add_token( id, &ast, &peekable);
break ;
}
         auto c = c_opt.value_or(' ');
            if(any ( c , { CHAR_QUOTE , CHAR_SINGLE } )    ) {
               auto matched = get_matching(&peekable,c);
               id= try_add_token( id, &ast, &peekable);
                try_add_token( matched, &ast, &peekable);
continue ;
}
            else if(is_char_number ( c )    ) {
               auto num = collect_num(&peekable,c);
               id= try_add_token( id, &ast, &peekable);
                ast.push_back( num);
continue ;
}
         string ch( 1, c);
         auto is_white_space = any(c,{'\n',' ','\t'});
         auto is_both_token = is_str_tokens(id)==is_char_token(c);
            if(! is_both_token    ) {
               id= try_add_token( id, &ast, &peekable);
                  if(peekable.index ( )  != last_known_index  ) {
                     
 continue;
}
                  if(! is_white_space    ) {
                      id+= ch;
continue ;
}
}
            if(is_both_token    &&is_str_tokens ( id + ch )    ) {
                id+= ch;
continue ;
}
            else if(is_char_token ( c )    ) {
               id= try_add_token( id, &ast, &peekable);
                  if(peekable.index ( )  != last_known_index  ) {
                     
 continue;
}
                ast.push_back( AstToken( c));
continue ;
}
            else if(is_white_space    ) {
               id= try_add_token( id, &ast, &peekable);
                  if(c  == '\n'  ) {
                     
 ast.push_back( AstToken("\n"));
}
               continue;
}
         id+= ch;
}
   ast.push_back( AstToken("EOF"));
   ast.push_back( AstToken("EOF"));
   ast.push_back( AstToken("EOF"));
   ast.push_back( AstToken("EOF"));
   ast.push_back( AstToken("EOF"));
   ast.push_back( AstToken("EOF"));
   return  ast;
}
string try_add_token(string id, vector<AstToken>* ast, Peekable<char>* peekable) {
      if(id.size ( )  == 0  ) {
         
return  id;
}
      if(id  == "//"  ) {
            while(true   ) {
               auto next = peekable->next().value_or('\n');
                  if(next  == '\n'  ) {
                     
 break;
}
}
         id="\n";
}
   ast-> push_back( AstToken( id));
   return  EMPTY;
}
bool is_str_tokens(string s) {
      if(s.size ( )  == 0  ) {
         
return false;
}
      for(int i = 0; i < s.size(); i++) {
            if(! is_char_token ( s.at ( i ) )    ) {
               
return false;
}
}
   return ! Token_t( s) .is_id();
}
bool is_char_token(char ch) {
   string s( 1, ch);
   return ! Token_t( s) .is_id();
}
bool is_char_number(char ch) {
   string s( 1, ch);
   return  Token_t( s) .is_num();
}
Option<string> try_get_dbl(Peekable<char>* peekable, char ch) {
   auto peek = peekable->peek();
      if(peek.is_none ( )    ||peek.value_or ( ' ' )  != ch  ) {
         
return  None<string>();
}
   peekable-> next();
   string dbl( 1, ch);
   return  Some( dbl+ dbl);
}
string get_matching(Peekable<char>* peekable, char ch) {
   bool escaped = false;
   string matching( 1, ch);
      while(true   ) {
         auto c_opt = peekable->next();
            if(c_opt.is_none ( )    ) {
               
return  matching;
}
         auto c = c_opt.value_or(' ');
         string matchbuf( 1, c);
         matching+= matchbuf;
            if(c  == ch  &&! escaped    ) {
               
return  matching;
}
         escaped=! escaped&& c=='\\';
}
}
AstToken collect_num(Peekable<char>* peekable, char ch) {
   string num( 1, ch);
   bool is_float = false;
   auto token = AstToken();
      while(true   ) {
         auto peeked = peekable->peek().value_or(' ');
            if(! is_char_number ( peeked )    &&peeked  != '.'  ) {
               token.name= num;
               token.token= is_float ? Token:: Float: Token:: Number;
               token.t= Token_t("0");
               token.t.t= is_float ? Token:: Float: Token:: Number;
               return  token;
}
            if(peeked  == '.'  ) {
               
 is_float=true;
}
         peekable-> next();
         string numbuf( 1, peeked);
         num+= numbuf;
}
}
vector<string> imports_construct(Compiler* compiler_t) {
   get_arrow_or_exit( compiler_t-> next(),"[Import]: Missing [=>] in declaration");
   return  imports_construct_impl( compiler_t);
}
vector<string> imports_construct_impl(Compiler* compiler_t) {
   vector<string> imports={};
   string id= EMPTY;
      while(true   ) {
         auto next = get_next_or_exit(compiler_t->next(),"[Import]: Import declaration invalid");
            if(any ( next.token , { Token :: Eof , Token :: NewLine , Token :: Comma , Token :: RBrack } )    ) {
                  if(id.size ( )  > 0  &&! imports_check_duplicate ( imports , id )    ) {
                     
 imports.push_back( id);
}
               id= EMPTY;
}
            else if(next.token  == Token :: LBrack  ) {
               auto combined = imports_construct_impl(compiler_t);
                  for(int i = 0; i < combined.size(); i++) {
                     auto base = id;
                     base+= combined.at( i);
                     imports.push_back( base);
}
               id= EMPTY;
}
            else if(next.is_base ( )    ) {
               
 display_err_message("[Import]: Token not allowed: "+ next.name);
}
            else {
               
 id+= next.name;
}
            if(any ( next.token , { Token :: Eof , Token :: NewLine , Token :: RBrack } )    ) {
               
 break;
}
}
   return  imports;
}
vector<string> imports_creation(Compiler* compiler_t, AstToken next) {
   auto import = imports_construct(compiler_t);
   auto import_return = import;
   bool found = false;
   bool contains = false;
      for(int i = 0; i < import.size(); i++) {
         auto imp = import.at(i);
            if(next.token  == Token :: Use  ) {
               contains= compiler_t-> has_use( imp);
                  if(contains    ) {
                     display_hint_message("[Use]: Duplicate entry of: "+ to_string( next.token));
                     found=true;
}
               continue;
}
            else if(next.token  == Token :: Include  ) {
               contains= compiler_t-> has_inc( imp);
                  if(contains    ) {
                     display_hint_message("[Include]: Duplicate entry of: "+ to_string( next.token));
                     found=true;
}
               continue;
}
            else if(next.token  == Token :: Get  ) {
               
 continue;
}
         display_err_message("["+ to_string( next.token)+"]: Unhandled import");
}
      if(! found    ) {
            if(next.token  == Token :: Use  ) {
               
 compiler_t-> add_use( import);
}
            else if(next.token  == Token :: Include  ) {
               
 compiler_t-> add_inc( import);
}
            else if(next.token  == Token :: Get  ) {
               
return  import_return;
}
            else {
               
 display_err_message("["+ to_string( next.token)+"]: Unhandled import");
}
}
   return  import_return;
}
bool imports_check_duplicate(vector<string> imports, string id) {
      for(int i = 0; i < imports.size(); i++) {
            if(imports.at ( i )  == id  ) {
               display_hint_message("[Import]: Token duplicate in entry "+ id);
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
   
return  e_err( err, EMPTY,false);
}
string e_err(EnumError err, string opt) {
   
return  e_err( err, opt,false);
}
string e_err(EnumError err, string opt, bool display) {
   string msg="[Enum] ";
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
;
         
 break;
}
   msg+= opt;
      if(display    ) {
         
 display_err_message( msg);
}
   return  msg;
}
void validate_enum(Enum enumerator, Compiler* compiler_t) {
   auto contains = compiler_t->has_enum(enumerator.name);
      if(contains    ) {
         
 e_err( EnumError:: Duplicate, enumerator.name,true);
}
}
Enum enums_construct(Compiler* compiler_t) {
   auto id = get_id_or_exit(compiler_t->next(),e_err(EnumError::NoId));
   auto enumerator = Enum(id);
   get_arrow_or_exit( compiler_t-> next(), e_err( EnumError:: NoArrow));
   auto enum_def = EnumValue();
      while(true   ) {
         auto next = get_next_or_exit(compiler_t->next(),e_err(EnumError::Closed));
            if(next.is_id ( )    ) {
                  if(enum_def.name.size ( )  == 0  ) {
                      enum_def.name= next.name;
continue ;
}
               e_err( EnumError:: IdExists, EMPTY,true);
}
            else if(next.token  == Token :: Comma  ) {
                  if(enum_def.name.size ( )  == 0  ) {
                     
 e_err( EnumError:: CommaNoId, EMPTY,true);
}
                  for(int i = 0; i < enumerator.enums.size(); i++) {
                        if(enumerator.enums.at ( i ) .name  == enum_def.name  ) {
                           e_err( EnumError:: Member, enum_def.name,true);
}
}
               enumerator.enums.push_back( enum_def);
               enum_def= EnumValue();
}
            else if(next.token  == Token :: Equals  ) {
                  if(enum_def.name.size ( )  != 0  ) {
                     auto val = get_or_exit(compiler_t->next(),Token::Number,e_err(EnumError::NoValue));
                     enum_def.value= Some( val);
                     continue;
}
               e_err( EnumError:: ValueNoId, EMPTY,true);
}
            if(any ( next.token , { Token :: SemiColon , Token :: Eof } )    ) {
               
 break;
}
            if(any ( next.token , { Token :: Id , Token :: NewLine , Token :: Comma } )    ) {
               
 continue;
}
         e_err( EnumError:: Unexpected, EMPTY,true);
}
   validate_enum( enumerator, compiler_t);
   compiler_t-> add_enum( enumerator);
   return  enumerator;
}
Expressioner for_construct(Compiler* compiler_t) {
   auto for_def = For();
   for_def.iterator= get_id_or_exit( compiler_t-> next(),"[For] For loop is not closed");
   get_or_exit( compiler_t-> next(), Token:: Until,"[For] Missing until keyword");
   for_def.until= compiler_t-> next() .value_or( AstToken("NONE")) .name;
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"[For] For loop is not closed");
            if(x.is_do ( )    ) {
               for_def.lines.push_back( expression_construct( compiler_t, x));
               return  Expressioner( for_def);
}
            if(x.is_nl ( )    ) {
               
 break;
}
         for_def.until+= x.name;
}
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"[For] For loop is not closed");
            if(x.is_terminator ( )    ) {
               
 break;
}
            if(x.is_nl ( )    ) {
               
 continue;
}
            switch(x.token    ) {
               case Token::Condition:
                for_def.lines.push_back( condition_construct( compiler_t, x.name));
break ;
               case Token::For:
                for_def.lines.push_back( for_construct( compiler_t));
break ;
               case Token::Switch:
                for_def.lines.push_back( switch_construct( compiler_t));
break ;
               default:
;
                for_def.lines.push_back( expression_construct( compiler_t, x));
break ;
}
}
   return  Expressioner( for_def);
}
Expressioner expression_construct(Compiler* compiler_t, AstToken first) {
   string doing= EMPTY;
   string expression= EMPTY;
      if(first.token  == Token :: Let  ) {
         
return  get_let_expr( compiler_t);
}
      switch(first.token    ) {
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
;
          expression= first.name;
break ;
}
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"[Expression] Expression ended unexpectedly");
            if(any ( x.token , { Token :: Eof , Token :: NewLine } )    ) {
                expression+= doing;
break ;
}
            if(any ( x.token , { Token :: Number , Token :: Id } )    ) {
               
 expression+=" ";
}
            if(x.is_do ( )    ) {
               
 expression+="\n";
}
            switch(x.token    ) {
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
               default:
;
                expression+= x.name;
break ;
}
}
   return  Expressioner( expression);
}
Expressioner get_let_expr(Compiler* compiler_t) {
   auto id = get_id_or_exit(compiler_t->next(),"[Let] Required id after let");
   get_or_exit( compiler_t-> next(), Token:: Equals,"[Let] Required equals after id");
   string expression= EMPTY;
   string value= EMPTY;
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"LET exception");
            if(any ( x.token , { Token :: Eof , Token :: NewLine } )    ) {
               
 break;
}
         value+= x.name;
}
   auto token = Token_t(value);
      if(token.is_bool ( )    ) {
         
 expression="bool ";
}
      else if(token.is_num ( )    ) {
         
 expression="int ";
}
      else if(token.is_float ( )    ) {
         
 expression="float ";
}
      else if(token.is_char ( )    ) {
         
 expression="char ";
}
      else if(token.is_string ( )    ) {
         
 expression="string ";
}
      else {
         
 expression="auto ";
}
   expression+= id+" = "+ value;
   return  Expressioner( expression);
}
Expressioner switch_construct(Compiler* compiler_t) {
   auto cond = Conditions("switch");
   auto expression = ConditionalExpression();
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"[Switch] Switch is not closed");
            if(x.is_do ( )    ) {
               
 display_err_message("[Switch] Switch statements cannot have a do parameter");
}
            if(x.is_nl ( )    ) {
                cond.expressions.push_back( expression);
break ;
}
         expression.value_left+= x.name+" ";
}
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"[Switch] Switch is not closed");
         bool exit = false;
         vector< Expressioner> result={};
            switch(x.token    ) {
               case Token::Default:
               result= create_case( compiler_t, x.token== Token:: Default);
                  for(int i = 0; i < result.size(); i++) {
                     
 cond.lines.push_back( result.at( i));
}
               break;
               case Token::Case:
               result= create_case( compiler_t, x.token== Token:: Default);
                  for(int i = 0; i < result.size(); i++) {
                     
 cond.lines.push_back( result.at( i));
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
;
                display_err_message("[Switch] Token not allowed in switch "+ to_string( x.token));
break ;
}
            if(exit    ) {
               
 break;
}
}
   return  Expressioner( cond);
}
vector<Expressioner> create_case(Compiler* compiler_t, bool is_default) {
   vector< Expressioner> lines={};
   string label= EMPTY;
      if(! is_default    ) {
         auto next = get_next_or_exit(compiler_t->next(),"[Switch] Case unfinished");
         label="case "+ next.name;
            if(next.is_id ( )    &&! compiler_t -> has_enum ( next.name )    ) {
               
 display_err_message("[Switch] Enum member doesn't exist:"+ next.name);
}
            if(! next.valid_case ( )    ) {
               
 display_err_message("Token not allowed in switch: ");
}
            if(next.is_id ( )    &&try_get ( compiler_t -> peek ( ) , Token :: DblColon )    ) {
               label+="::";
               compiler_t-> next();
               auto enum_name = get_next_or_exit(compiler_t->next(),"[Switch] Unexpected end");
                  if(! compiler_t -> has_enum_name ( enum_name.name )    ) {
                     
 display_err_message("[Switch] Enum member doesn't exist: "+ enum_name.name);
}
               label+= enum_name.name;
}
         label+=":\n";
}
      else {
         
 label="default:\n";
}
   lines.push_back( Expressioner( label));
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"[Switch] Case unfinished");
         vector< Expressioner> result={};
            switch(x.token    ) {
               case Token::Case:
               case Token::Default:
               case Token::SemiColon:
               compiler_t-> prev();
               
return  lines;
               case Token::Condition:
                lines.push_back( condition_construct( compiler_t, x.name));
break ;
               case Token::For:
                lines.push_back( for_construct( compiler_t));
break ;
               case Token::Switch:
                lines.push_back( switch_construct( compiler_t));
break ;
               case Token::NewLine:
               
 break;
               default:
;
                lines.push_back( expression_construct( compiler_t, x));
break ;
}
}
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
   
return  co_err( err, EMPTY,false);
}
string co_err(ConditionError err, string opt) {
   
return  co_err( err, opt,false);
}
string co_err(ConditionError err, string opt, bool display) {
   string msg="[Condition] ";
      switch(err    ) {
         case ConditionError::Closed:
          msg+="Condition is not closed ";
break ;
         default:
;
         
 break;
}
   msg+= opt;
      if(display    ) {
         
 display_err_message( msg);
}
   return  msg;
}
Expressioner condition_construct(Compiler* compiler_t, string condition_type) {
   auto cond = Conditions(condition_type);
   auto expression = ConditionalExpression();
      if(condition_type  == "elif"  ) {
         
 cond= Conditions("else if");
}
      if(condition_type  == "loop"  ) {
         cond= Conditions("while");
         expression.value_left="true";
}
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),co_err(ConditionError::Closed));
            if(x.is_do ( )    ) {
               cond.add_expr( expression);
               cond.lines.push_back( expression_construct( compiler_t, x));
               return  Expressioner( cond);
}
            if(x.is_conditional_sep ( )    ) {
               expression.continuation= x.name;
               cond.add_expr( expression);
                expression= ConditionalExpression();
continue ;
}
            if(x.is_conditional ( )    ) {
                expression.operator_value= x.name;
continue ;
}
            if(x.is_nl ( )    ) {
                cond.add_expr( expression);
break ;
}
            if(expression.operator_value.size ( )  == 0  ) {
                expression.value_left+= x.name+" ";
continue ;
}
         expression.value_right+= x.name+" ";
}
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),co_err(ConditionError::Closed));
            if(x.is_terminator ( )    ) {
               
 break;
}
            if(x.is_nl ( )    ) {
               
 continue;
}
            switch(x.token    ) {
               case Token::Condition:
                cond.lines.push_back( condition_construct( compiler_t, x.name));
break ;
               case Token::For:
                cond.lines.push_back( for_construct( compiler_t));
break ;
               case Token::Switch:
                cond.lines.push_back( switch_construct( compiler_t));
break ;
               default:
;
                cond.lines.push_back( expression_construct( compiler_t, x));
break ;
}
}
   return  Expressioner( cond);
}
struct VariableNBool {
 public:
   Variable variable = Variable();
 public:
   bool is_end = false;
 public:
   VariableNBool (Variable v, bool is_end) {
      this-> variable= v;
      this-> is_end= is_end;
   }
};
Option<string> get_value(Compiler* compiler_t, bool found_setter) {
   string value= EMPTY;
      if(! found_setter    ) {
         
 get_eq_or_exit( compiler_t-> next(), VAR_ERR_SET);
}
      while(true   ) {
         auto next = get_next_or_exit(compiler_t->next(),VAR_ERR_VAL);
            if(next.is_nl ( )    ) {
               
 break;
}
         value+= next.name;
}
   return  value.size()== 0 ? None<string>(): Some( value);
}
Variable get_type(Compiler* compiler_t) {
   auto next = get_next_or_exit(compiler_t->next(),VAR_ERR_NON);
   auto variable = Variable(true);
      if(any ( next.token , { Token :: Id , Token :: Type } )    ) {
         
 variable.v_type= next.name;
}
      else if(next.token  != Token :: NewLine  ) {
         
 display_err_message( VAR_ERR_TYP+ to_string( next.token));
}
   auto tried = try_get(compiler_t->peek(),Token::LessThan);
      if(tried    ) {
            if(! variable.has_id ( )    ) {
               display_err_message( VAR_ERR_TEM+ variable.v_type);
}
         next= get_next_or_exit( compiler_t-> next(), VAR_ERR_INV);
         variable.v_type+= next.name;
            while(true   ) {
               next= get_next_or_exit( compiler_t-> next(), VAR_ERR_INV);
               variable.v_type+= next.name;
                  if(next.token  == Token :: MoreThan  ) {
                     
 break;
}
}
}
   tried= try_get( compiler_t-> peek(), Token:: Asterix);
      if(tried    ) {
         
 variable.v_type+= get_or_exit( compiler_t-> next(), Token:: Asterix, VAR_ERR_NON);
}
   return  variable;
}
VariableNBool construct_args(Compiler* compiler_t) {
   
return  construct_args( compiler_t, None<string>());
}
VariableNBool construct_args(Compiler* compiler_t, Option<string> type_name) {
   auto variable = Variable();
      if(type_name.is_some ( )    ) {
         
 variable.v_type= type_name.value_or( VOID);
}
   bool is_end = false;
      while(true   ) {
         auto next = get_next_or_exit(compiler_t->next(),VAR_ERR_INV);
            if(any ( next.token , { Token :: NewLine , Token :: CoolArrow } )    ) {
                is_end=true;
break ;
}
            if(next.token  == Token :: Equals  ) {
                variable.v_value= get_value( compiler_t,true);
break ;
}
            else if(next.token  == Token :: Comma  ) {
               
 break;
}
            else if(next.token  == Token :: Asterix  ) {
                  if(! variable.has_type ( )    ) {
                     
 display_err_message( VAR_ERR_POI+ variable.v_type);
}
               variable.v_type+= next.name;
}
            else if(next.token  == Token :: LessThan  ) {
                  if(! variable.has_id ( )    &&! variable.has_type ( )    ) {
                     
 display_err_message( VAR_ERR_TEM+ variable.v_type);
}
               variable.v_type+= next.name;
                  while(true   ) {
                     next= get_next_or_exit( compiler_t-> next(), VAR_ERR_INV);
                     variable.v_type+= next.name;
                        if(next.token  == Token :: MoreThan  ) {
                           
 break;
}
}
}
            else {
                  if(! variable.has_type ( )    ) {
                      variable.v_type= next.name;
continue ;
}
                  if(! variable.has_id ( )    ) {
                      variable.id= next.name;
continue ;
}
               display_err_message( VAR_ERR_COM+ variable.id);
}
}
      if(! variable.has_minimum ( )    &&! is_end    ) {
         
 display_err_message( VAR_ERR_INC+ variable.id);
}
   return  VariableNBool( variable, is_end);
}
vector<string> template_construct(Compiler* compiler_t) {
   vector<string> templates={};
      while(true   ) {
         auto next = get_next_or_exit(compiler_t->next(),"[Template]: Template declaration invalid");
            if(next.is_id ( )    ) {
                templates.push_back( next.name);
continue ;
}
            else if(any ( next.token , { Token :: Comma , Token :: LessThan } )    ) {
               
 continue;
}
            else if(next.token  == Token :: MoreThan  ) {
               
 break;
}
         display_err_message("[Template]: Token not allowed: "+ next.name);
}
   return  templates;
}
void validate_function(Function function, Compiler* compiler_t) {
      if(compiler_t -> has_function ( function.id )    ) {
            for(int i = 0; i < compiler_t->program->functions.size(); i++) {
               auto f = compiler_t->program->functions.at(i);
                  if(f.arguments.size ( )  != function.arguments.size ( )  ) {
                     
return ;
}
                  for(int j = 0; j < f.arguments.size(); j++) {
                        if(f.arguments [ j ] .v_type  != function.arguments [ j ] .v_type  ) {
                           
return ;
}
                     j++;
}
}
         display_err_message("Duplicate instances Function of: "+ function.id);
}
}
Function function_construct(Compiler* compiler_t, VariableState state, bool constr) {
   auto function = Function(state);
      if(! constr    ) {
         function.id= get_id_or_exit( compiler_t-> next(),"[FunctionError]: No Function Id");
}
   auto peeked_opt = compiler_t->peek();
      if(peeked_opt.is_none ( )    ) {
         
 display_err_message("Error when trying to parse function: "+ function.id);
}
      if(peeked_opt.value_or ( AstToken ( "NONE" ) ) .token  == Token :: LessThan  ) {
         function.templates= template_construct( compiler_t);
}
      while(true   ) {
         auto vnb = construct_args(compiler_t);
            if(! vnb.variable.has_minimum ( )    ) {
               
 break;
}
         function.add_args( vnb.variable);
            if(vnb.is_end    ) {
               
 break;
}
}
      if(function.id  == "main"  ) {
         function.add_args( Variable("argc","int"));
         function.add_args( Variable("argv[]","char*"));
         function.return_value= Some( Variable("","int"));
}
      else {
         
 function.return_value= Some( get_type( compiler_t));
}
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"Function is not closed "+function.id);
            if(any ( x.token , { Token :: SemiColon , Token :: Function , Token :: Eof } )    ) {
               
 break;
}
            if(x.is_nl ( )    ) {
               
 continue;
}
            switch(x.token    ) {
               case Token::For:
                function.add_expr( for_construct( compiler_t));
break ;
               case Token::Condition:
                function.add_expr( condition_construct( compiler_t, x.name));
break ;
               case Token::Switch:
                function.add_expr( switch_construct( compiler_t));
break ;
               default:
;
                function.add_expr( expression_construct( compiler_t, x));
break ;
}
            if(x.is_do ( )    ) {
               
 break;
}
}
      if(function.id  == "main"  ) {
         function.add_expr( Expressioner("return 0"));
}
   compiler_t-> add_fn( function);
   return  function;
}
enum class ClassError: int {
   Closed,
   Definition,
   Duplicate,
   Inheritance,
   NoId,
   NoInheritor,
};
string to_string(ClassError enumerator) {
switch (enumerator) {
case ClassError::Closed: return "Closed";
case ClassError::Definition: return "Definition";
case ClassError::Duplicate: return "Duplicate";
case ClassError::Inheritance: return "Inheritance";
case ClassError::NoId: return "NoId";
case ClassError::NoInheritor: return "NoInheritor";
default: return "UNKNOWN TYPE";
}};
string c_err(ClassError err) {
   
return  c_err( err, EMPTY,false);
}
string c_err(ClassError err, string opt) {
   
return  c_err( err, opt,false);
}
string c_err(ClassError err, string opt, bool display) {
   string msg="[Class] ";
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
         case ClassError::Inheritance:
          msg+="Invalid inheritance of: ";
break ;
         case ClassError::NoId:
          msg+="Invalid class declaration";
break ;
         case ClassError::NoInheritor:
          msg+="Invalid Inheritor Token\nExpected Id for inheritance for class: ";
break ;
         default:
;
         
 break;
}
   msg+= opt;
      if(display    ) {
         
 display_err_message( msg);
}
   return  msg;
}
void class_validate(Class class_def, Compiler* compiler_t) {
      if(compiler_t -> has_class ( class_def.id )    ) {
         c_err( ClassError:: Duplicate, class_def.id,true);
}
   auto inherit = class_def.inherit;
      if(inherit.is_none ( )    ) {
         
return ;
}
      if(compiler_t -> has_class ( inherit.value_or ( EMPTY ) )    ) {
         
return ;
}
   auto contains = compiler_t->has_class(inherit.value_or(EMPTY));
      if(class_def.inherit.is_some ( )    &&! contains    ) {
         c_err( ClassError:: Inheritance, class_def.id,true);
}
}
Class class_construct(Compiler* compiler_t, bool is_struct) {
   auto class_def = Class();
   class_def.is_struct= is_struct;
   class_def.id= get_id_or_exit( compiler_t-> next(), c_err( ClassError:: NoId));
   auto next = get_next_or_exit(compiler_t->next(),c_err(ClassError::Definition,class_def.id));
      if(next.token  == Token :: LessThan  ) {
         class_def.templates= template_construct( compiler_t);
         next= get_next_or_exit( compiler_t-> next(), c_err( ClassError:: Definition, class_def.id));
}
      if(next.token  == Token :: CoolArrow  ) {
         class_def.inherit= Some( get_id_or_exit( compiler_t-> next(), c_err( ClassError:: NoInheritor, class_def.id)));
}
   auto variable_state = !is_struct?VariableState::Private:VariableState::Public;
      while(true   ) {
         auto next = get_next_or_exit(compiler_t->next(),c_err(ClassError::Closed,class_def.id));
            if(next.token  == Token :: Function  ) {
               auto function = function_construct(compiler_t,variable_state,false);
                class_def.functions.push_back( function);
continue ;
}
            else if(any ( next.token , { Token :: Id , Token :: Type } )    ) {
                  if(next.name  == class_def.id  ) {
                     auto function = function_construct(compiler_t,VariableState::Public,true);
                     function.return_value= Some( Variable( EMPTY, class_def.id));
                      class_def.functions.push_back( function);
continue ;
}
               auto vnb = construct_args(compiler_t,Some(next.name));
               vnb.variable.variable_state= variable_state;
                class_def.variables.push_back( vnb.variable);
continue ;
}
            else if(any ( next.token , { Token :: Eof , Token :: SemiColon , Token :: Class } )    ) {
               
 break;
}
            switch(next.token    ) {
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
;
               
 break;
}
}
   class_validate( class_def, compiler_t);
   compiler_t-> add_class( class_def);
   return  class_def;
}
Global global_construct(Compiler* compiler_t) {
   get_arrow_or_exit( compiler_t-> next(),"[Global]: Requires => after glob keyword");
   auto global = Global();
   auto variables = get_variables(compiler_t);
      for(int i = 0; i < variables.size(); i++) {
         
 try_add_variable( compiler_t, &global, variables.at( i));
}
   compiler_t-> add_glob( global);
   return  global;
}
vector<Variable> get_variables(Compiler* compiler_t) {
   vector< Variable> variables={};
   auto variable = Variable();
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"[Global]: Unexpected end of global");
            switch(x.token    ) {
               case Token::Eof:
               case Token::SemiColon:
               
return  variables;
               case Token::NewLine:
               variables.push_back( variable);
               variable= Variable();
               break;
               default:
;
                  if(! variable.has_type ( )    ) {
                      variable.v_type= x.name;
break ;
}
                  else if(! variable.has_id ( )    ) {
                      variable.id= x.name;
break ;
}
               display_err_message("[Global]: Variable is already finished");
}
}
}
void try_add_variable(Compiler* compiler_t, Global* global, Variable variable) {
      if(! variable.has_minimum ( )    ) {
         
return ;
}
      for(int i = 0; i < global->variables.size(); i++) {
         auto v = global->variables.at(i);
            if(v.v_type  == variable.v_type  ) {
               display_err_message("[Global]: Multiple declarations of same value");
}
}
      if(compiler_t -> has_glob ( variable.v_type )    ) {
         display_err_message("[Global]: Multiple declarations of same value");
}
   global-> variables.push_back( variable);
}
struct CompileOutput {
 public:
   string output = EMPTY;
 public:
   string includes = EMPTY;
 public:
   string headers = EMPTY;
 public:
   string fnheaders = EMPTY;
 public:
   vector<string> arguments = {};
 public:
   string content() {
      
return  includes+ headers+ fnheaders+ output;
   }
 public:
   CompileOutput (string output, string includes, string headers, string fnheaders, vector<string> args) {
      this-> output= output;
      this-> includes= includes;
      this-> headers= headers;
      this-> fnheaders= fnheaders;
      this-> arguments= args;
   }
};
int main(int argc, char* argv[]) {
   bool should_remove_cpp = false;
   FpFn fpfn= get_folder_and_name( get_file_path( argc, argv));
   auto paths = CompilerPath(get_file_path(argc,argv),fpfn.f_p,fpfn.f_n);
   auto p = Program();
   auto output = compile_main(paths,&p);
   write_program( output.content(), paths);
   compile_program( paths, output.arguments, should_remove_cpp);
   return 0;
}
CompileOutput compile_main(CompilerPath paths, Program* p) {
   
return  compile( paths, p,true);
}
CompileOutput compile(CompilerPath paths, Program* p, bool is_main) {
   println("compiling: "+ paths.current);
   string output= EMPTY;
   string includes= EMPTY;
   string headers= EMPTY;
   string fnheaders= EMPTY;
   auto content = get_content(paths);
   auto ast = ast_create(content);
   auto compiler_t = Compiler(p,ast);
   vector<string> incs={};
   string args= EMPTY;
      while(true   ) {
         auto next = get_next_or_exit(compiler_t.next(),"Compiler failed to do unexpected EOF");
            if(! next.is_base ( )    ) {
               display_err_message("Token not allowed in base: "+ to_string( next.token));
}
            if(next.is_terminator ( )    ) {
               
 break;
}
            else if(next.is_nl ( )    ) {
               
 continue;
}
            else if(next.is_classy ( )    ) {
               auto classdef = class_construct(&compiler_t,next.token==Token::Struct);
               output+= classdef.to_cpp();
               headers+= classdef.to_cpp_h();
}
            else if(next.token  == Token :: Function  ) {
               auto fndef = function_construct(&compiler_t,VariableState::Public,false);
               output+= fndef.to_cpp(false);
               fnheaders+= fndef.to_cpp_h();
}
            else if(next.token  == Token :: Enum  ) {
               auto enumdef = enums_construct(&compiler_t);
               output+= enumdef.to_cpp();
               headers+= enumdef.to_cpp_h();
}
            else if(next.token  == Token :: Global  ) {
               auto global = global_construct(&compiler_t);
               headers+= global.to_cpp();
}
            else if(next.token  == Token :: Include  ) {
               incs= imports_creation( &compiler_t, next);
                  for(int i = 0; i < incs.size(); i++) {
                     
 includes+= Include( incs.at( i)) .to_cpp();
}
}
            else if(next.token  == Token :: Use  ) {
               incs= imports_creation( &compiler_t, next);
                  for(int i = 0; i < incs.size(); i++) {
                     
 includes+= Uses( incs.at( i)) .to_cpp();
}
}
            else if(next.token  == Token :: Get  ) {
               incs= imports_creation( &compiler_t, next);
                  for(int i = 0; i < incs.size(); i++) {
                     FpFn fpfn= get_folder_and_name( paths.folder_path+ incs.at( i)+ HA_SUFFIX);
                     auto get_path = CompilerPath(paths.folder_path+incs.at(i)+HA_SUFFIX,fpfn.f_p,fpfn.f_n);
                     auto get_out = compile(get_path,p,false);
                     output+= get_out.output;
                     includes+= get_out.includes;
                     headers+= get_out.headers;
                     fnheaders+= get_out.fnheaders;
                     compiler_t.add_args( get_out.arguments);
}
}
            else if(next.token  == Token :: Compiler  ) {
               get_arrow_or_exit( compiler_t.next(),"[Compiler] Missing start of compiler intent [=>]: "+ next.name);
               args= get_or_exit( compiler_t.next(), Token:: String,"[Compiler] Missing value of compiler intent [TString]: "+ next.name);
               compiler_t.add_arg( args);
}
            else {
               
 display_err_message("Token not handled: "+ next.name);
}
}
   validate_compiled( compiler_t, is_main);
   return  CompileOutput( output, includes, headers, fnheaders, compiler_t.arguments);
}
void validate_compiled(Compiler compiler, bool is_main) {
   bool has_main = false;
      for(int i = 0; i < compiler.program->functions.size(); i++) {
         auto f = compiler.program->functions.at(i);
            if(f.id  == "main"  ) {
                has_main=true;
break ;
}
}
      if(! has_main    &&is_main    ) {
         
 display_hint_message("Main function is not present!");
}
      if(has_main    &&! is_main    ) {
         
 display_hint_message("Main function not in main file");
}
}
