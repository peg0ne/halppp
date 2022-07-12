#include <string>
#include <vector>
using namespace std;
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

return  is_some() ? "Some("+ std:: to_string( _value)+ ")": "None";
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
#include <iostream>
using namespace std;
template <typename T>
void print(T s) {

 cout<< s;
}
template <typename T>
void println(T s) {

 cout<< s<< "\n";;
}
string replace_string(string str, string from, string to) {
size_t start_pos= str.find( from);
    if(start_pos  == - 1  ) {

return str;
    }
str.replace( start_pos, from.length(), to);
return str;
}
bool starts_with(string str, string start) {

return  str.rfind( start, 0)== 0;
}
#include <vector>
#include <iostream>
using namespace std;
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
#include "cpp/strings.h"
#include "cpp/tokens.h"
enum Token {
    TAllEquals,
    TAllLessOrEquals,
    TAllLessThan,
    TAllMoreOrEquals,
    TAllMoreThan,
    TAllNotEquals,
    TAnd,
    TAnyEquals,
    TAsterix,
    TBang,
    TClass,
    TColon,
    TComma,
    TComment,
    TCompiler,
    TCondition,
    TCoolArrow,
    TDblLessThan,
    TDblMoreThan,
    TDo,
    TDobr,
    TDoco,
    TDore,
    TDoremi,
    TEof,
    TEquality,
    TEquals,
    TExtend,
    TFalse,
    TFor,
    TForwardSlash,
    TFunction,
    TGet,
    TGlobal,
    TId,
    TInclude,
    TLBrack,
    TLessThan,
    TLessThanOrEquals,
    TLet,
    TLParen,
    TMacroDefinition,
    TMoreThan,
    TMoreThanOrEquals,
    TNewLine,
    TNonEquality,
    TNumber,
    TOr,
    TPrivate,
    TProtected,
    TPublic,
    TRBrack,
    TReturn,
    TRParen,
    TSemiColon,
    TStruct,
    TSub,
    TSum,
    TTrue,
    TType,
    TUntil,
    TUse,
    TEnum,
    UNKNOWN,
};
struct Token_t {
  public:
    Token t = TId;
  public:
    Token_t (string s) {
    if(s  == TOKEN_SUB  ) {

 t= TSub;
return ;
    }
    else if(s  == TOKEN_COMMA  ) {

 t= TComma;
return ;
    }
    else if(s  == TOKEN_COLON  ) {

 t= TColon;
return ;
    }
    else if(s  == TOKEN_SEMICOLON  ) {

 t= TSemiColon;
return ;
    }
    else if(s  == TOKEN_NONEQUALITY  ) {

 t= TNonEquality;
return ;
    }
    else if(s  == TOKEN_LPAREN  ) {

 t= TLParen;
return ;
    }
    else if(s  == TOKEN_BANG  ) {

 t= TBang;
return ;
    }
    else if(s  == TOKEN_RPAREN  ) {

 t= TRParen;
return ;
    }
    else if(s  == TOKEN_LBRACK  ) {

 t= TLBrack;
return ;
    }
    else if(s  == TOKEN_RBRACK  ) {

 t= TRBrack;
return ;
    }
    else if(s  == TOKEN_ASTERIX  ) {

 t= TAsterix;
return ;
    }
    else if(s  == TOKEN_FORWARDSLASH  ) {

 t= TForwardSlash;
return ;
    }
    else if(s  == TOKEN_LINE_COMMENT  ) {

 t= TComment;
return ;
    }
    else if(s  == TOKEN_NEWLINE  ) {

 t= TNewLine;
return ;
    }
    else if(s  == TOKEN_AND  ) {

 t= TAnd;
return ;
    }
    else if(s  == TOKEN_SUM  ) {

 t= TSum;
return ;
    }
    else if(s  == TOKEN_LESSTHAN  ) {

 t= TLessThan;
return ;
    }
    else if(s  == TOKEN_DBLLESSTHAN  ) {

 t= TDblLessThan;
return ;
    }
    else if(s  == TOKEN_ALLLESSTHAN  ) {

 t= TAllLessThan;
return ;
    }
    else if(s  == TOKEN_LESSTHANOREQUALS  ) {

 t= TLessThanOrEquals;
return ;
    }
    else if(s  == TOKEN_ALLNOTEQUALS  ) {

 t= TAllNotEquals;
return ;
    }
    else if(s  == TOKEN_EQUALS  ) {

 t= TEquals;
return ;
    }
    else if(s  == TOKEN_ALLEQUALS  ) {

 t= TAllEquals;
return ;
    }
    else if(s  == TOKEN_ALLLESSOREQUALS  ) {

 t= TAllLessOrEquals;
return ;
    }
    else if(s  == TOKEN_EQUALITY  ) {

 t= TEquality;
return ;
    }
    else if(s  == TOKEN_COOLARROW  ) {

 t= TCoolArrow;
return ;
    }
    else if(s  == TOKEN_ALLMOREOREQUALS  ) {

 t= TAllMoreOrEquals;
return ;
    }
    else if(s  == TOKEN_ANYEQUALS  ) {

 t= TAnyEquals;
return ;
    }
    else if(s  == TOKEN_MORETHAN  ) {

 t= TMoreThan;
return ;
    }
    else if(s  == TOKEN_MORETHANOREQUALS  ) {

 t= TMoreThanOrEquals;
return ;
    }
    else if(s  == TOKEN_DBLMORETHAN  ) {

 t= TDblMoreThan;
return ;
    }
    else if(s  == TOKEN_ALLMORETHAN  ) {

 t= TAllMoreThan;
return ;
    }
    else if(s  == TOKEN_OR  ) {

 t= TOr;
return ;
    }
    else if(s  == TOKEN_ZERO  ) {

 t= TNumber;
return ;
    }
    else if(s  == TOKEN_ONE  ) {

 t= TNumber;
return ;
    }
    else if(s  == TOKEN_TWO  ) {

 t= TNumber;
return ;
    }
    else if(s  == TOKEN_THREE  ) {

 t= TNumber;
return ;
    }
    else if(s  == TOKEN_FOUR  ) {

 t= TNumber;
return ;
    }
    else if(s  == TOKEN_FIVE  ) {

 t= TNumber;
return ;
    }
    else if(s  == TOKEN_SIX  ) {

 t= TNumber;
return ;
    }
    else if(s  == TOKEN_SEVEN  ) {

 t= TNumber;
return ;
    }
    else if(s  == TOKEN_EIGHT  ) {

 t= TNumber;
return ;
    }
    else if(s  == TOKEN_NINE  ) {

 t= TNumber;
return ;
    }
    else if(s  == TOKEN_TYPE  ) {

 t= TType;
return ;
    }
    else if(s  == TOKEN_CLASS  ) {

 t= TClass;
return ;
    }
    else if(s  == TOKEN_COMPILER  ) {

 t= TCompiler;
return ;
    }
    else if(s  == TOKEN_MACRODEFINITION  ) {

 t= TMacroDefinition;
return ;
    }
    else if(s  == TOKEN_DO  ) {

 t= TDo;
return ;
    }
    else if(s  == TOKEN_DOBR  ) {

 t= TDobr;
return ;
    }
    else if(s  == TOKEN_DOCO  ) {

 t= TDoco;
return ;
    }
    else if(s  == TOKEN_DORE  ) {

 t= TDore;
return ;
    }
    else if(s  == TOKEN_DOREMI  ) {

 t= TDoremi;
return ;
    }
    else if(s  == TOKEN_ENUM  ) {

 t= TEnum;
return ;
    }
    else if(s  == TOKEN_ELIF  ) {

 t= TCondition;
return ;
    }
    else if(s  == TOKEN_ELSE  ) {

 t= TCondition;
return ;
    }
    else if(s  == TOKEN_EXTEND  ) {

 t= TExtend;
return ;
    }
    else if(s  == TOKEN_FALSE  ) {

 t= TFalse;
return ;
    }
    else if(s  == TOKEN_FUNCTION  ) {

 t= TFunction;
return ;
    }
    else if(s  == TOKEN_FOR  ) {

 t= TFor;
return ;
    }
    else if(s  == TOKEN_FOREACH  ) {

 t= TFor;
return ;
    }
    else if(s  == TOKEN_GET  ) {

 t= TGet;
return ;
    }
    else if(s  == TOKEN_GLOBAL  ) {

 t= TGlobal;
return ;
    }
    else if(s  == TOKEN_IFS  ) {

 t= TCondition;
return ;
    }
    else if(s  == TOKEN_INCLUDE  ) {

 t= TInclude;
return ;
    }
    else if(s  == TOKEN_INT  ) {

 t= TType;
return ;
    }
    else if(s  == TOKEN_LET  ) {

 t= TLet;
return ;
    }
    else if(s  == TOKEN_PRIVATE  ) {

 t= TPrivate;
return ;
    }
    else if(s  == TOKEN_PROTECTED  ) {

 t= TProtected;
return ;
    }
    else if(s  == TOKEN_PUBLIC  ) {

 t= TPublic;
return ;
    }
    else if(s  == TOKEN_RETURN  ) {

 t= TReturn;
return ;
    }
    else if(s  == TOKEN_STR  ) {

 t= TType;
return ;
    }
    else if(s  == TOKEN_STRING  ) {

 t= TType;
return ;
    }
    else if(s  == TOKEN_STRUCT  ) {

 t= TStruct;
return ;
    }
    else if(s  == TOKEN_SWITCH  ) {

 t= TCondition;
return ;
    }
    else if(s  == TOKEN_TRUE  ) {

 t= TTrue;
return ;
    }
    else if(s  == TOKEN_UNTIL  ) {

 t= TUntil;
return ;
    }
    else if(s  == TOKEN_USE  ) {

 t= TUse;
return ;
    }
    else if(s  == TOKEN_WHILE  ) {

 t= TCondition;
return ;
    }
    else if(s  == TOKEN_EOF  ) {

 t= TEof;
return ;
    }
t= TId;
    }
  public:
    bool is_base() {
    switch(t    ) {
case TClass:
return true;
case TEof:
return true;
case TFunction:
return true;
case TGet:
return true;
case TGlobal:
return true;
case TInclude:
return true;
case TMacroDefinition:
return true;
case TNewLine:
return true;
case TSemiColon:
return true;
case TStruct:
return true;
case TUse:
return true;
case TCompiler:
return true;
case TEnum:
return true;
default:
return false;
    }
    }
  public:
    bool is_do() {
    switch(t    ) {
case TDo:
return true;
case TDobr:
return true;
case TDoco:
return true;
case TDore:
return true;
case TDoremi:
return true;
default:
return false;
    }
    }
  public:
    bool is_conditional() {
    switch(t    ) {
case TEquality:
return true;
case TNonEquality:
return true;
case TMoreThanOrEquals:
return true;
case TLessThanOrEquals:
return true;
case TLessThan:
return true;
case TMoreThan:
return true;
case TAnyEquals:
return true;
case TAllEquals:
return true;
case TAllNotEquals:
return true;
case TAllLessThan:
return true;
case TAllMoreThan:
return true;
case TAllLessOrEquals:
return true;
case TAllMoreOrEquals:
return true;
default:
return false;
    }
    }
  public:
    bool is_conditional_sep() {
    switch(t    ) {
case TAnd:
return true;
case TOr:
return true;
default:
return false;
    }
    }
};
string token_to_string(Token t) {
    if(t  == TSub  ) {

return  "TSub";
    }
    else if(t  == TComma  ) {

return  "TComma";
    }
    else if(t  == TColon  ) {

return  "TColon";
    }
    else if(t  == TSemiColon  ) {

return  "TSemiColon";
    }
    else if(t  == TNonEquality  ) {

return  "TNonEquality";
    }
    else if(t  == TLParen  ) {

return  "TLParen";
    }
    else if(t  == TBang  ) {

return  "TBang";
    }
    else if(t  == TRParen  ) {

return  "TRParen";
    }
    else if(t  == TLBrack  ) {

return  "TLBrack";
    }
    else if(t  == TRBrack  ) {

return  "TRBrack";
    }
    else if(t  == TAsterix  ) {

return  "TAsterix";
    }
    else if(t  == TForwardSlash  ) {

return  "TForwardSlash";
    }
    else if(t  == TComment  ) {

return  "TComment";
    }
    else if(t  == TNewLine  ) {

return  "TNewLine";
    }
    else if(t  == TAnd  ) {

return  "TAnd";
    }
    else if(t  == TSum  ) {

return  "TSum";
    }
    else if(t  == TLessThan  ) {

return  "TLessThan";
    }
    else if(t  == TDblLessThan  ) {

return  "TDblLessThan";
    }
    else if(t  == TAllLessThan  ) {

return  "TAllLessThan";
    }
    else if(t  == TLessThanOrEquals  ) {

return  "TLessThanOrEquals";
    }
    else if(t  == TAllNotEquals  ) {

return  "TAllNotEquals";
    }
    else if(t  == TEquals  ) {

return  "TEquals";
    }
    else if(t  == TAllEquals  ) {

return  "TAllEquals";
    }
    else if(t  == TAllLessOrEquals  ) {

return  "TAllLessOrEquals";
    }
    else if(t  == TEquality  ) {

return  "TEquality";
    }
    else if(t  == TCoolArrow  ) {

return  "TCoolArrow";
    }
    else if(t  == TAllMoreOrEquals  ) {

return  "TAllMoreOrEquals";
    }
    else if(t  == TAnyEquals  ) {

return  "TAnyEquals";
    }
    else if(t  == TMoreThan  ) {

return  "TMoreThan";
    }
    else if(t  == TMoreThanOrEquals  ) {

return  "TMoreThanOrEquals";
    }
    else if(t  == TDblMoreThan  ) {

return  "TDblMoreThan";
    }
    else if(t  == TAllMoreThan  ) {

return  "TAllMoreThan";
    }
    else if(t  == TOr  ) {

return  "TOr";
    }
    else if(t  == TNumber  ) {

return  "TNumber";
    }
    else if(t  == TNumber  ) {

return  "TNumber";
    }
    else if(t  == TNumber  ) {

return  "TNumber";
    }
    else if(t  == TNumber  ) {

return  "TNumber";
    }
    else if(t  == TNumber  ) {

return  "TNumber";
    }
    else if(t  == TNumber  ) {

return  "TNumber";
    }
    else if(t  == TNumber  ) {

return  "TNumber";
    }
    else if(t  == TNumber  ) {

return  "TNumber";
    }
    else if(t  == TNumber  ) {

return  "TNumber";
    }
    else if(t  == TNumber  ) {

return  "TNumber";
    }
    else if(t  == TType  ) {

return  "TType";
    }
    else if(t  == TClass  ) {

return  "TClass";
    }
    else if(t  == TCompiler  ) {

return  "TCompiler";
    }
    else if(t  == TMacroDefinition  ) {

return  "TMacroDefinition";
    }
    else if(t  == TDo  ) {

return  "TDo";
    }
    else if(t  == TDobr  ) {

return  "TDobr";
    }
    else if(t  == TDoco  ) {

return  "TDoco";
    }
    else if(t  == TDore  ) {

return  "TDore";
    }
    else if(t  == TDoremi  ) {

return  "TDoremi";
    }
    else if(t  == TEnum  ) {

return  "TEnum";
    }
    else if(t  == TCondition  ) {

return  "TCondition";
    }
    else if(t  == TCondition  ) {

return  "TCondition";
    }
    else if(t  == TExtend  ) {

return  "TExtend";
    }
    else if(t  == TFalse  ) {

return  "TFalse";
    }
    else if(t  == TFunction  ) {

return  "TFunction";
    }
    else if(t  == TFor  ) {

return  "TFor";
    }
    else if(t  == TFor  ) {

return  "TFor";
    }
    else if(t  == TGet  ) {

return  "TGet";
    }
    else if(t  == TGlobal  ) {

return  "TGlobal";
    }
    else if(t  == TCondition  ) {

return  "TCondition";
    }
    else if(t  == TInclude  ) {

return  "TInclude";
    }
    else if(t  == TType  ) {

return  "TType";
    }
    else if(t  == TLet  ) {

return  "TLet";
    }
    else if(t  == TPrivate  ) {

return  "TPrivate";
    }
    else if(t  == TProtected  ) {

return  "TProtected";
    }
    else if(t  == TPublic  ) {

return  "TPublic";
    }
    else if(t  == TReturn  ) {

return  "TReturn";
    }
    else if(t  == TType  ) {

return  "TType";
    }
    else if(t  == TType  ) {

return  "TType";
    }
    else if(t  == TStruct  ) {

return  "TStruct";
    }
    else if(t  == TCondition  ) {

return  "TCondition";
    }
    else if(t  == TTrue  ) {

return  "TTrue";
    }
    else if(t  == TUntil  ) {

return  "TUntil";
    }
    else if(t  == TUse  ) {

return  "TUse";
    }
    else if(t  == TCondition  ) {

return  "TCondition";
    }
return  "TId";
}
enum VariableState {
    Private_State,
    Protected_State,
    Public_State,
};
string variable_state_to_cpp(VariableState self) {
    switch(self    ) {
case Private_State:
return  PRIVATE_STATE;
case Protected_State:
return  PROTECTED_STATE;
case Public_State:
return  PUBLIC_STATE;
    }
return  PRIVATE_STATE;
}
struct AstToken {
  public:
    string name = EMPTY;
  public:
    Token token = TId;
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
string cpp= replace_string( main, HA_SUFFIX, CPP_SUFFIX);
string bin= replace_string( main, HA_SUFFIX, EMPTY);
this-> folder_path= f_p;
this-> file_path= f_n;
this-> main_path= main;
this-> main_path_cpp= cpp;
this-> main_path_bin= bin;
this-> output= cpp+ COMPILER_OUT+ bin;
this-> current= f_p+ f_n;
    }
};
enum MessageSeverity {
    Hint,
    Error,
};
void display_message(MessageSeverity severity, string msg) {
println( to_string( severity)+ " "+ msg);
}
void display_hint_message(string msg) {

 display_message( Hint, msg);
}
void display_err_message(string msg) {
display_message( Error, msg);
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

return  get_or_exit( next, TId, s);
}
string get_arrow_or_exit(Option<AstToken> next, string s) {

return  get_or_exit( next, TCoolArrow, s);
}
string get_eq_or_exit(Option<AstToken> next, string s) {

return  get_or_exit( next, TEquals, s);
}
FpFn get_folder_and_name(string file_path) {
string file_name= EMPTY;
string folder_path= file_path;
    while(true    ) {
auto i= folder_path.size();
    if(i  == 0  ) {

 break;
    }
auto ch= folder_path.back();
folder_path.pop_back();
    if(ch  == '/'  ) {

 folder_path.push_back( '/');
break ;
    }
file_name.push_back( ch);
    }
string reversed= EMPTY;
    while(file_name.size ( )  > 0  ) {
reversed.push_back( file_name.back());
file_name.pop_back();
    }
file_name= reversed;
return  FpFn( folder_path, file_name);
}
#include <fstream>
string get_file_path(int argc, char** argv) {
    if(argc  < 2  ) {

 display_err_message( "No file path supplied in arguments!\nExiting...");
    }
string fp= EMPTY;
auto i= 0;
    while(argv [ 1 ] [ i ]  != '\0'  ) {

 fp.push_back( argv[ 1][ i++]);
    }
return  fp;
}
string get_content(CompilerPath paths) {
string content= " ";
string linebuf;
ifstream reader( paths.current);
    if(! reader    ) {

 display_err_message( "Couldn't open file\nExiting...");
    }
    while(! reader.eof ( )    ) {
getline( reader, linebuf);
content+= linebuf+ "\n";
    }
return  content;
}
void write_program(string program, CompilerPath paths) {
return ;
}
void compile_program(CompilerPath paths, vector<string> arguments, bool should_remove_cpp) {
return ;
}
struct Variable {
  public:
    string id = EMPTY;
  public:
    string v_type = EMPTY;
  public:
    Option<string> v_value = None<string>();
  public:
    VariableState variable_state = Private_State;
  public:
    Variable () {
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
    string to_cpp() {
string enum_str= ENUM+ name+ BLOCK_START;
    for(int i = 0; i < enums.size(); i++) {
auto e= enums.at( i);
enum_str+= TAB+ e.name;
enum_str+= e.value.is_some() ? ASSIGNMENT+ e.value.value_or( EMPTY): EMPTY;
enum_str+= ENUM_SEP;
    }
enum_str+= RBRACK;
enum_str+= LINE_END;
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
string include_str= INCLUDE;
include_str+= starts_with( include, QUOTE) ? include: RARROW+ include+ LARROW;
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
    string to_cpp(int indentation) {
string for_str= EMPTY;
    for(int i = 0; i < indentation; i++) {

 for_str+= TAB;
    }
for_str+= FOR_START+ iterator;
for_str+= FOR_MID+ iterator;
for_str+= FOR_UNTIL+until;
for_str+= FOR_AFTER_UNTIL+ iterator+ FOR_END;
    for(int i = 0; i < indentation; i++) {

 for_str+= TAB;
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
auto expr_str= value_left+ SPACE;
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
    for(int i = 0; i < indentation; i++) {

 condition_str+= TAB;
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
    Expressioner (Option<Conditions> conditions, Option<For> fors, Option<string> line) {
this-> e_condition= conditions;
this-> e_for= fors;
this-> line= line;
    }
  public:
    string to_cpp(int indentation) {
    if(e_condition.is_some ( )    ) {

return  e_condition.value_or( Conditions( EMPTY)) .to_cpp( indentation+ 1);
    }
    if(e_for.is_some ( )    ) {

return  e_for.value_or( For()) .to_cpp( indentation+ 1);
    }
string expression= EMPTY;
    for(int i = 0; i < indentation; i++) {

 expression+= TAB;
    }
auto line_value= line.value_or( EMPTY);
expression+= line_value.size()== 0 ? EMPTY: line_value+ LINE_END;
return  expression;
    }
};
struct Function {
  public:
    string id = EMPTY;
  public:
    VariableState variable_state = Public_State;
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
    string to_cpp(bool in_class) {
string fun_str= templates.size()> 0 ? TEMPLATE: EMPTY;
    for(int i = 0; i < templates.size(); i++) {
fun_str+= templates.at( i);
fun_str+= i+ 1< templates.size() ? TEMPLATE_MID: TEMPLATE_END;
    }
fun_str+= in_class ? TAB: EMPTY;
fun_str+= return_value.value_or( Variable(true)) .v_type;
fun_str+= SPACE+ id+ LPAREN;
    for(int i = 0; i < arguments.size(); i++) {
auto a= arguments.at( i);
fun_str+= a.to_cpp( EMPTY, EMPTY);
fun_str+= i+ 1< arguments.size() ? ARG_SEP: ARG_END;
    }
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
    string to_cpp() {
string class_str= templates.size()> 0 ? TEMPLATE: EMPTY;
    for(int i = 0; i < templates.size(); i++) {
class_str+= templates.at( i);
class_str+= i+ 1< templates.size() ? TEMPLATE_MID: TEMPLATE_END;
    }
class_str+= is_struct ? STRUCT: CLASS;
class_str+= id;
class_str+= inherit.is_some() ? INHERIT: EMPTY;
class_str+= inherit.value_or( EMPTY);
class_str+= BLOCK_START;
    for(int i = 0; i < variables.size(); i++) {
auto v= variables.at( i);
class_str+= variable_state_to_cpp( v.variable_state);
class_str+= v.to_cpp( TAB, LINE_END);
    }
    for(int i = 0; i < functions.size(); i++) {
auto f= functions.at( i);
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
    Program program = Program();
  public:
    Peekable<AstToken> ast;
  public:
    vector<string> arguments = {};
  public:
    Compiler (Program p, Peekable<AstToken> ast) {
this-> program= p;
this-> ast= ast;
    }
  public:
    int size() {

return  ast.size();
    }
  public:
    Option<AstToken> next() {
// println( ast.peek() .value_or( AstToken( "NONE")) .name);
return  ast.next();
    }
  public:
    Option<AstToken> peek() {

return  ast.peek();
    }
  public:
    void add_fn(Function function) {

 program.functions.push_back( function);
    }
  public:
    void add_class(Class class_obj) {

 program.classes.push_back( class_obj);
    }
  public:
    void add_enum(Enum enum_def) {

 program.enums.push_back( enum_def);
    }
  public:
    void add_inc(vector<string> includes) {
    for(int i = 0; i < includes.size(); i++) {
program.includes.push_back( Include( includes.at( i)));
    }
    }
  public:
    void add_use(vector<string> usings) {
    for(int i = 0; i < usings.size(); i++) {
program.usings.push_back( Uses( usings.at( i)));
    }
    }
  public:
    void add_arg(string arg) {

 arguments.push_back( replace_string( arg, QUOTE, EMPTY));
    }
  public:
    void add_args(vector<string> args) {
    for(int i = 0; i < args.size(); i++) {
arguments.push_back( args.at( i));
    }
    }
  public:
    bool contains_use(string id) {
    for(int i = 0; i < program.usings.size(); i++) {
    if(program.usings.at ( i ) .usings  == id  ) {

return true;
    }
    }
return false;
    }
  public:
    bool contains_function(string id) {
    for(int i = 0; i < program.functions.size(); i++) {
    if(program.functions.at ( i ) .id  == id  ) {

return true;
    }
    }
return false;
    }
  public:
    bool contains_class(string id) {
    for(int i = 0; i < program.classes.size(); i++) {
    if(program.classes.at ( i ) .id  == id  ) {

return true;
    }
    }
return false;
    }
  public:
    bool contains_inc(string id) {
    for(int i = 0; i < program.includes.size(); i++) {
    if(program.includes.at ( i ) .include  == id  ) {

return true;
    }
    }
return false;
    }
  public:
    bool contains_enum(string id) {
    for(int i = 0; i < program.enums.size(); i++) {
    if(program.enums.at ( i ) .name  == id  ) {

return true;
    }
    }
return false;
    }
};
string try_add_token(string id, vector<AstToken>* ast) {
    if(id.size ( )  > 0  ) {
ast-> push_back( AstToken( id));
return  EMPTY;
    }
return  id;
}
bool is_char_token(char ch) {
string s( 1, ch);
    switch(Token_t ( s ) .t    ) {
case TId:
return false;
default:
return true;
    }
}
bool is_char_number(char ch) {
string s( 1, ch);
    switch(Token_t ( s ) .t    ) {
case TNumber:
return true;
default:
return false;
    }
}
Option<string> try_get_dbl(Peekable<char>* peekable, char ch) {
auto peek= peekable-> peek();
    if(peek.is_some ( )    &&peek.value_or ( ' ' )  == ch  ) {
string dbl( 1, ch);
dbl+= dbl;
peekable-> next();
return  Some( dbl);
    }
return  None<string>();
}
string get_matching(Peekable<char>* peekable, char ch) {
string matching( 1, ch);
    while(true    ) {
auto c= peekable-> next();
    if(c.is_none ( )    ) {

return  matching;
    }
string matchbuf( 1, c.value_or( ' '));
matching+= matchbuf;
    if(c.value_or ( ' ' )  == ch  ) {

 break;
    }
    }
return  matching;
}
string collect_num(Peekable<char>* peekable, char ch) {
string num( 1, ch);
    while(true    ) {
auto peeked= peekable-> peek() .value_or( ' ');
    if(! is_char_number ( peeked )    &&peeked  != '.'  ) {

return  num;
    }
peekable-> next();
string numbuf( 1, peeked);
num+= numbuf;
    }
}
vector<AstToken> ast_create(string content) {
vector<char> vec= {};
    for(int i = 0; i < content.size(); i++) {
vec.push_back( content[ i]);
    }
auto peekable= Peekable<char>( vec);
string id= EMPTY;
vector< AstToken> ast= {};
    while(true    ) {
auto c_opt= peekable.next();
    if(c_opt.is_none ( )    ) {

 break;
    }
auto c= c_opt.value_or( ' ');
    if(any ( c , {CHAR_QUOTE , CHAR_SINGLE} )    ) {
auto matched= get_matching( &peekable, c);
id= try_add_token( id, &ast);
try_add_token( matched, &ast);
continue;
    }
    if(is_char_number ( c )    ) {
auto num= collect_num( &peekable, c);
id= try_add_token( id, &ast);
try_add_token( num, &ast);
continue;
    }
    if(is_char_token ( c )    ) {
auto dbl_less= id!= "<"&& c== '<';
auto dbl_more= id!= ">"&& c== '>';
auto dbl_eq= id!= "="&& c== '=';
    if(dbl_less    ||dbl_more    ||dbl_eq    ) {
auto dbl= try_get_dbl( &peekable, c);
    if(dbl.is_some ( )    ) {
id= try_add_token( id, &ast);
try_add_token( dbl.value_or( EMPTY), &ast);
continue;
    }
    }
    }
    if(is_char_token ( c )    ) {
id= try_add_token( id, &ast);
auto next= peekable.peek() .value_or( ' ');
auto is_cool= c== '='&& next== '>';
auto is_non_eq= c== '!'&& next== '=';
    if(is_cool    ) {
peekable.next();
ast.push_back( AstToken( "=>"));
continue;
    }
    else if(is_non_eq    ) {
peekable.next();
ast.push_back( AstToken( "!="));
continue;
    }
ast.push_back( AstToken( c));
continue;
    }
    if(any ( c , { ' ' , '\t' , '\n' } )    ) {
id= try_add_token( id, &ast);
    if(c  == '\n'  ) {

 ast.push_back( AstToken( "\n"));
    }
continue;
    }
string ch( 1, c);
id+= ch;
    }
// Push extra sets of EOF to ensure it wont break badly;
ast.push_back( AstToken( "EOF"));
ast.push_back( AstToken( "EOF"));
ast.push_back( AstToken( "EOF"));
ast.push_back( AstToken( "EOF"));
ast.push_back( AstToken( "EOF"));
ast.push_back( AstToken( "EOF"));
return  ast;
}
bool imports_check_duplicate(vector<string> imports, string id) {
    for(int i = 0; i < imports.size(); i++) {
    if(imports.at ( i )  == id  ) {
display_hint_message( "[Import]: Token duplicate in entry "+ id);
return true;
    }
    }
return false;
}
vector<string> imports_construct(Compiler* compiler_t) {
vector<string> imports= {};
get_arrow_or_exit( compiler_t-> next(), "[Import]: Missing [=>] in declaration");
string id= EMPTY;
auto can_continue=true;
    while(can_continue    ) {
auto next= get_next_or_exit( compiler_t-> next(), "[Import]: Import declaration invalid");
    switch(next.token    ) {
case TEof:
 can_continue=false;
case TNewLine:
 can_continue=false;
    if(! imports_check_duplicate ( imports , id )    ) {

 imports.push_back( id);
    }
break;
case TComma:
 can_continue=true;
    if(! imports_check_duplicate ( imports , id )    ) {

 imports.push_back( id);
    }
id= EMPTY;
break;;
default:
 can_continue=true;
    if(next.t.is_base ( )    ) {

 display_err_message( "[Import]: Token not allowed: "+ next.name);
    }
id+= next.name;
break;
    }
    }
return  imports;
}
vector<string> imports_creation(Compiler* compiler_t, AstToken next) {
auto import= imports_construct( compiler_t);
auto import_return= import;
auto found=false;
auto contains=false;
    for(int i = 0; i < import.size(); i++) {
auto imp= import.at( i);
    switch(next.token    ) {
case TUse:
 contains= compiler_t-> contains_use( imp);
    if(contains    ) {
display_hint_message( "[Use]: Duplicate entry of: "+ token_to_string( next.token));
found=true;
    }
break;
case TInclude:
 contains= compiler_t-> contains_inc( imp);
    if(contains    ) {
display_hint_message( "[Include]: Duplicate entry of: "+ token_to_string( next.token));
found=true;
    }
break;
case TGet:
 break;
default:
 display_err_message( "["+ token_to_string( next.token)+ "]: Unhandled import");
break ;
    }
    }
    if(! found    ) {
    switch(next.token    ) {
case TUse:
 compiler_t-> add_use( import);
break ;
case TInclude:
 compiler_t-> add_inc( import);
break ;
case TGet:
 break;
default:
 display_err_message( "["+ token_to_string( next.token)+ "]: Unhandled import");
break ;
    }
    }
return  import_return;
}
void validate_enum(Enum enumerator, Compiler* compiler_t) {
auto contains= compiler_t-> contains_enum( enumerator.name);
    if(contains    ) {
display_err_message( "Duplicate instances Enum of: "+ enumerator.name);
    }
}
Enum enums_construct(Compiler* compiler_t) {
auto id= get_id_or_exit( compiler_t-> next(), "[Enum] Requires Id in initialization");
auto enumerator= Enum( id);
get_arrow_or_exit( compiler_t-> next(), "[Enum] Requires [=>] after Id");
auto enum_def= EnumValue();
auto can_continue=true;
    while(can_continue    ) {
auto next= get_next_or_exit( compiler_t-> next(), "[Enum] Ends without closing itself");
    switch(next.token    ) {
case TId:
 can_continue=true;
    if(enum_def.name.size ( )  > 0  ) {
display_err_message( "[Enum] Cannot assign id to EnumValue that already has id");;
    }

 enum_def.name= next.name;
break ;
case TNumber:
 can_continue=true;
case TEquals:
 can_continue=true;
    if(enum_def.name.size ( )  == 0  ) {
display_err_message( "[Enum] Cannot assign value to EnumValue without id");
    }
break;
case TNewLine:
 break;
case TComma:
 can_continue=true;
    if(enum_def.name.size ( )  == 0  ) {
display_err_message( "[Enum] Missing enum before separator");
    }
enumerator.enums.push_back( enum_def);

 enum_def= EnumValue();
break ;
case TSemiColon:
 can_continue=false;
break ;
case TEof:
 can_continue=false;
break ;
default:
 display_err_message( "[Enum] Invalid token inside Enum constructor");
break ;
    }
    }
validate_enum( enumerator, compiler_t);
compiler_t-> add_enum( enumerator);
return  enumerator;
}
Expressioner for_construct(Compiler* compiler_t) {
auto for_def= For();
for_def.iterator= get_id_or_exit( compiler_t-> next(), "[For] For loop is not closed");
get_or_exit( compiler_t-> next(), TUntil, "[For] Missing until keyword");
for_def.until= compiler_t-> next() .value_or( AstToken( "NONE")) .name;
    while(true    ) {
auto x= get_next_or_exit( compiler_t-> next(), "[For] For loop is not closed");
    if(x.t.is_do ( )    ) {
for_def.lines.push_back( expression_construct( compiler_t, x));
return  Expressioner( None< Conditions>(), Some( for_def), None<string>());
    }
    if(x.token = TNewLine    ) {

 break;
    }
for_def.until+= x.name;
    }
auto can_continue=true;
    while(can_continue    ) {
auto x= get_next_or_exit( compiler_t-> next(), "[For] For loop is not closed");
    switch(x.token    ) {
case TCondition:
 for_def.lines.push_back( condition_construct( compiler_t, x.name));;
break ;
case TFor:
 for_def.lines.push_back( for_construct( compiler_t));
break ;
case TSemiColon:
 can_continue=false;
break ;
case TEof:
 can_continue=false;
break ;
case TNewLine:
 can_continue=true;
break ;
default:
 for_def.lines.push_back( expression_construct( compiler_t, x));
break ;
    }
    }
return  Expressioner( None< Conditions>(), Some( for_def), None<string>());
}
Expressioner expression_construct(Compiler* compiler_t, AstToken first) {
string doing= EMPTY;
string expression= EMPTY;
    switch(first.token    ) {
case TDoco:
 doing= ";\ncontinue ";
break ;
case TDobr:
 doing= ";\nbreak ";
break ;
case TDore:
 doing= ";\nreturn ";
case TDo:
 expression= "\n";
break ;
case TDoremi:
 expression= "\nreturn ";
break ;
case TLet:
 expression= "auto";
break ;
case TReturn:
 expression= "return ";
break ;
default:
 expression= first.name;
break ;
    }
auto can_continue=true;
    while(can_continue    ) {
auto x= get_next_or_exit( compiler_t-> next(), "[Expression] Expression ended unexpectedly");
    switch(x.token    ) {
case TEof:
 can_continue=false;
break ;
case TNewLine:
 can_continue=false;
break ;
case TDore:
 doing= ";\nreturn ";
case TDobr:
 doing= ";\nbreak ";
case TDoco:
 doing= ";\ncontinue ";
case TDo:
 expression+= "\n";
break ;
case TDoremi:
 expression+= "\nreturn ";
break ;
case TLet:
 expression+= "auto";
break ;
case TNumber:
 expression+= " "+ x.name;
break ;
case TId:
 expression+= " "+ x.name;
break ;
case TReturn:
 expression+= "return ";
break ;
default:
 expression+= x.name;
break ;
    }
    }
expression+= doing;
return  Expressioner( None< Conditions>(), None< For>(), Some( expression));
}
Expressioner condition_construct(Compiler* compiler_t, string condition_type) {
auto condition_def= condition_type!= "elif" ? Conditions( condition_type): Conditions( "else if");
auto expression= ConditionalExpression();
    while(true    ) {
auto x= get_next_or_exit( compiler_t-> next(), "[Condition] Condition is not closed");
    if(x.t.is_do ( )    ) {
condition_def.expressions.push_back( expression);
condition_def.lines.push_back( expression_construct( compiler_t, x));
return  Expressioner( Some( condition_def), None< For>(), None<string>());
    }
    if(x.t.is_conditional_sep ( )    ) {
expression.continuation= x.name;
condition_def.expressions.push_back( expression);
expression= ConditionalExpression();
continue;
    }
    if(x.t.is_conditional ( )    ) {

 expression.operator_value= x.name;
continue ;
    }
    if(x.token  == TNewLine  ) {

 condition_def.expressions.push_back( expression);
break ;
    }
    if(expression.operator_value.size ( )  == 0  ) {

 expression.value_left+= x.name+ " ";
continue ;
    }
expression.value_right+= x.name+ " ";
    }
auto can_continue=true;
    while(can_continue    ) {
auto x= get_next_or_exit( compiler_t-> next(), "[Condition] Condition is not closed");
    switch(x.token    ) {
case TCondition:
 condition_def.lines.push_back( condition_construct( compiler_t, x.name));
break ;
case TFor:
 condition_def.lines.push_back( for_construct( compiler_t));
break ;
case TSemiColon:
 can_continue=false;
break ;
case TEof:
 can_continue=false;
break ;
case TNewLine:
 break;
default:
 condition_def.lines.push_back( expression_construct( compiler_t, x));
break ;
    }
    }
return  Expressioner( Some( condition_def), None< For>(), None<string>());
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
auto next= AstToken( "NONE");
auto can_continue=true;
    if(! found_setter    ) {

 get_eq_or_exit( compiler_t-> next(), "[Variable]: Invalid value setter");
    }
    while(can_continue    ) {
next= get_next_or_exit( compiler_t-> next(), "[Variable]: Invalid value");
    switch(next.token    ) {
case TNewLine:
 can_continue=false;
    if(value.size ( )  == 0  ) {

return  None<string>();
    }
return  Some( value);
default:
 value+= next.name;
break ;
    }
    }
return  None<string>();;
}
Variable get_type(Compiler* compiler_t) {
auto next= get_next_or_exit( compiler_t-> next(), "[Variable]: Invalid Function Return Value");
auto variable= Variable(true);
    switch(next.token    ) {
case TId:
 variable.v_type= next.name;
break ;
case TType:
 variable.v_type= next.name;
break ;
case TNewLine:
 break;
default:
 display_err_message( "[Variable]: Expected return value type got:\n"+ token_to_string( next.token));
break ;
    }
auto tried= try_get( compiler_t-> peek(), TLessThan);
    if(tried    ) {
    if(! variable.has_id ( )    ) {
display_err_message( "[Variable]: Variable declaration cannot have template without id:\n"+ variable.v_type);
    }
next= get_next_or_exit( compiler_t-> next(), "[Variable]: Invalid Declaration");
variable.v_type+= next.name;
auto can_continue=true;
    while(can_continue    ) {
next= get_next_or_exit( compiler_t-> next(), "[Variable]: Invalid Declaration");
    switch(next.token    ) {
case TMoreThan:
 can_continue=false;
default:
 variable.v_type+= next.name;
break ;
    }
    }
    }
return  variable;
}
VariableNBool construct_args(Compiler* compiler_t, Option<string> type_name) {
auto variable= Variable();
    if(type_name.is_some ( )    ) {

 variable.v_type= type_name.value_or( "void");
    }
auto is_end=false;
auto can_continue=true;
    while(can_continue    ) {
auto next= get_next_or_exit( compiler_t-> next(), "[Variable]: Invalid Declaration");
    switch(next.token    ) {
case TNewLine:
 can_continue=false;
case TCoolArrow:
 can_continue=false;

 is_end=true;
break ;
case TEquals:
 can_continue=false;

 variable.v_value= get_value( compiler_t,true);
break ;
case TComma:
 can_continue=false;
break ;
case TAsterix:
 can_continue=true;
    if(! variable.has_type ( )    ) {
display_err_message( "[Variable]: Pointer infront of type not allowed:\n"+ variable.v_type);
    }

 variable.v_type+= next.name;
break ;
case TLessThan:
 can_continue=true;
    if(! variable.has_id ( )    &&! variable.has_type ( )    ) {
display_err_message( "[Variable]: Variable declaration cannot have template without id and type:\n"+ variable.v_type);
    }
variable.v_type+= "<";
    while(true    ) {
next= get_next_or_exit( compiler_t-> next(), "[Variable]: Invalid Declaration");
    if(next.token  == TMoreThan  ) {
variable.v_type+= ">";
break;
    }
variable.v_type+= next.name;
    }
break;
default:
 can_continue=true;
    if(! variable.has_type ( )    ) {

 variable.v_type= next.name;
break ;
    }
    if(! variable.has_id ( )    ) {

 variable.id= next.name;
break ;
    }
display_err_message( "[Variable]: Variable declaration already complete:\n"+ variable.id);
break;
    }
    }
    if(! variable.has_minimum ( )    &&! is_end    ) {
display_err_message( "[Variable]: Variable declaration incomplete:\n"+ variable.id);
    }
return  VariableNBool( variable, is_end);
}
vector<string> template_construct(Compiler* compiler_t) {
vector<string> templates= {};
auto can_continue=true;
    while(can_continue    ) {
auto next= get_next_or_exit( compiler_t-> next(), "[Template]: Template declaration invalid");
    switch(next.token    ) {
case TId:
 templates.push_back( next.name);
break ;
case TComma:
 break;
case TLessThan:
 break;
case TMoreThan:
 can_continue=false;
break ;
default:
 display_err_message( "[Template]: Token not allowed: "+ next.name);
break ;
    }
    }
return  templates;
}
void validate_function(Function function, Compiler* compiler_t) {
auto contains= compiler_t-> contains_function( function.id);
    if(contains    ) {
    for(int i = 0; i < compiler_t->program.functions.size(); i++) {
auto f= compiler_t-> program.functions.at( i);
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
display_err_message( "Duplicate instances Function of: "+ function.id);
    }
}
Function function_construct(Compiler* compiler_t, VariableState variable_state, bool constructor) {
auto function= Function( variable_state);
    if(! constructor    ) {
function.id= get_id_or_exit( compiler_t-> next(), "[FunctionError]: No Function Id");
    }
auto peeked_opt= compiler_t-> peek();
    if(peeked_opt.is_none ( )    ) {

 display_err_message( "Error when trying to parse function: "+ function.id);
    }
    if(peeked_opt.value_or ( AstToken ( "NONE" ) ) .token  == TLessThan  ) {

 function.templates= template_construct( compiler_t);
    }
    while(true    ) {
auto vnb= construct_args( compiler_t, None<string>());
    if(! vnb.variable.has_minimum ( )    ) {

 break;
    }
function.arguments.push_back( vnb.variable);
    if(vnb.is_end    ) {

 break;
    }
    }
    if(function.id  == "main"  ) {
function.arguments.push_back( Variable( "argc", "int", None<string>(), Private_State));
function.arguments.push_back( Variable( "argv[]", "char*", None<string>(), Private_State));
function.return_value= Some( Variable( "", "int", None<string>(), Private_State));
    }
    else {
   
 function.return_value= Some( get_type( compiler_t));
    }
auto can_continue=true;
    while(can_continue    ) {
auto x= get_next_or_exit( compiler_t-> next(), "Function is not closed "+ function.id);
    switch(x.token    ) {
case TFor:
 function.expressions.push_back( for_construct( compiler_t));
break ;
case TCondition:
 function.expressions.push_back( condition_construct( compiler_t, x.name));
break ;
case TSemiColon:
 can_continue=false;
break ;
case TFunction:
 can_continue=false;
break ;
case TEof:
 can_continue=false;
break ;
case TNewLine:
 break;
default:
 function.expressions.push_back( expression_construct( compiler_t, x));
    if(x.t.is_do ( )    ) {

 can_continue=false;
    }
break;
    }
    }
    if(function.id  == "main"  ) {
function.expressions.push_back( Expressioner( None< Conditions>(), None< For>(), Some((string) "return 0")));
    }
// validate_function( function, compiler_t);
compiler_t-> add_fn( function);
return  function;
}
void class_validate(Class class_def, Compiler* compiler_t) {
// Check Duplicate Classes;
auto contains= compiler_t-> contains_class( class_def.id);
    if(contains    ) {
display_err_message( "Duplicate instances of: "+ class_def.id);
    }
// Check Inheritance;
contains= compiler_t-> contains_class( class_def.inherit.value_or( EMPTY));
    if(class_def.inherit.is_some ( )    &&! contains    ) {
display_err_message( "Invalid Inheritance of: "+ class_def.id+ ", Inherits: "+ class_def.inherit.value_or( EMPTY));
    }
}
Class class_construct(Compiler* compiler_t, bool is_struct) {
auto class_def= Class();
class_def.is_struct= is_struct;
class_def.id= get_id_or_exit( compiler_t-> next(), "[ClassError] Invalid Class Declaration");
// Set Inheritance Or Template;
auto next= get_next_or_exit( compiler_t-> next(), "[ClassError] Invalid class definition of: "+ class_def.id);
    switch(next.token    ) {
case TLessThan:
 class_def.templates= template_construct( compiler_t);
next= get_next_or_exit( compiler_t-> next(), "[ClassError] Invalid class definition of: "+ class_def.id);
    switch(next.token    ) {
case TCoolArrow:;
class_def.inherit= Some( get_id_or_exit( compiler_t-> next(), "[ClassError] Invalid Inheritor Token\nExpected Id for inheritance for class: "+ class_def.id));
break;
    }
break;
case TCoolArrow:
 class_def.inherit= Some( get_id_or_exit( compiler_t-> next(), "[ClassError] Invalid Inheritor Token\nExpected Id for inheritance for class: "+ class_def.id));
break ;
    }
// Construct inner Class values;
auto variable_state=! is_struct ? Private_State: Public_State;
auto can_continue=true;
auto vnb= VariableNBool( Variable(true),false);
auto function= Function( variable_state);
    while(can_continue    ) {
auto next= get_next_or_exit( compiler_t-> next(), "[ClassError] Class is not closed "+ class_def.id);
    switch(next.token    ) {
case TEof:
 can_continue=false;
break ;
case TSemiColon:
 can_continue=false;
break ;
case TClass:
 can_continue=false;
break ;
case TPrivate:
 variable_state= Private_State;
break ;
case TProtected:
 variable_state= Protected_State;
break ;
case TPublic:
 variable_state= Public_State;
break ;
case TFunction:
 function= function_construct( compiler_t, variable_state,false);
class_def.functions.push_back( function);
break;
case TId:
 can_continue=true;
    if(next.name  == class_def.id  ) {
auto function= function_construct( compiler_t, Public_State,true);
function.return_value= Some( Variable( EMPTY, class_def.id, None<string>(), Private_State));
class_def.functions.push_back( function);
break;
    }
vnb= construct_args( compiler_t, Some( next.name));
vnb.variable.variable_state= variable_state;

 class_def.variables.push_back( vnb.variable);
break ;
case TType:;
vnb= construct_args( compiler_t, Some( next.name));
vnb.variable.variable_state= variable_state;

 class_def.variables.push_back( vnb.variable);
break ;
    }
    }
class_validate( class_def, compiler_t);
compiler_t-> add_class( class_def);
return  class_def;
}
struct CompileOutput {
  public:
    string output = EMPTY;
  public:
    vector<string> arguments = {};
  public:
    CompileOutput (string output, vector<string> arguments) {
this-> output= output;
this-> arguments= arguments;
    }
};
void validate_compiled(Compiler compiler, bool is_main) {
auto has_main=false;
    for(int i = 0; i < compiler.program.functions.size(); i++) {
auto f= compiler.program.functions.at( i);
    if(f.id  == "main"  ) {

 has_main=true;
break ;
    }
    }
    if(! has_main    &&is_main    ) {

 display_hint_message( "Main function is not present!");
    }
    if(has_main    &&! is_main    ) {

 display_hint_message( "Main function not in main file");
    }
}
CompileOutput compile(CompilerPath paths, Program p, bool is_main) {
println( "compiling: "+ paths.current);
string output= EMPTY;
auto content= get_content( paths);
auto ast= ast_create( content);
auto compiler_t= Compiler( p, ast);
auto can_continue=true;
auto a= 0;
auto class_def= Class();
auto function= Function( Private_State);
auto enum_def= Enum( "NONE");
vector<string> incs= {};
string args= EMPTY;
    while(can_continue    ) {
auto next= get_next_or_exit( compiler_t.next(), "Compiler failed to do unexpected EOF");
    if(! next.t.is_base ( )    ) {
display_err_message( "Token not allowed in base: "+ next.name+ ", Type: "+ token_to_string( next.token));
    }
    switch(next.token    ) {
case TStruct:
 class_def= class_construct( &compiler_t,true);

 output+= class_def.to_cpp();
break ;
case TClass:
 class_def= class_construct( &compiler_t,false);

 output+= class_def.to_cpp();
break ;
case TFunction:
 function= function_construct( &compiler_t, Public_State,false);

 output+= function.to_cpp(false);
break ;
case TEnum:
 enum_def= enums_construct( &compiler_t);

 output+= enum_def.to_cpp();
break ;
case TInclude:
 incs= imports_creation( &compiler_t, next);
    for(int i = 0; i < incs.size(); i++) {

 output+= Include( incs.at( i)) .to_cpp();
    }
break;
case TUse:
 incs= imports_creation( &compiler_t, next);
    for(int i = 0; i < incs.size(); i++) {

 output+= Uses( incs.at( i)) .to_cpp();
    }
break;
case TGet:
 incs= imports_creation( &compiler_t, next);
    for(int i = 0; i < incs.size(); i++) {
FpFn fpfn= get_folder_and_name( paths.folder_path+ incs.at( i)+ HA_SUFFIX);
auto get_path= CompilerPath( paths.folder_path+ incs.at( i)+ HA_SUFFIX, fpfn.f_p, fpfn.f_n);
auto get_out= compile( get_path, compiler_t.program,false);
output+= get_out.output;
compiler_t.add_args( get_out.arguments);
    }
break;
case TCompiler:
 a= 0;
get_arrow_or_exit( compiler_t.next(), "[Compiler] Missing start of compiler intent [=>]: "+ next.name);
args= get_id_or_exit( compiler_t.next(), "[Compiler] Missing value of compiler intent [Token::Id]: "+ next.name);

 compiler_t.add_arg( args);
break ;
case TNewLine:
 break;
case TEof:
 can_continue=false;
break ;
default:
 display_err_message( "Token not handled: "+ next.name);
break ;
    }
    }
validate_compiled( compiler_t, is_main);
return  CompileOutput( output, compiler_t.arguments);
}
CompileOutput compile_main(CompilerPath paths, Program p) {

return  compile( paths, p,true);
}
int main(int argc, char* argv[]) {
auto should_remove_cpp=false;
FpFn fpfn= get_folder_and_name( get_file_path( argc, argv));
auto paths= CompilerPath( get_file_path( argc, argv), fpfn.f_p, fpfn.f_n);
auto p= Program();
auto output= compile_main( paths, p);
write_program( output.output, paths);
compile_program( paths, output.arguments, should_remove_cpp);
return 0;
}
