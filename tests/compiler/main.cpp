#include <string>
#include <vector>
using namespace std;
#include <iostream>
using namespace std;
#include <vector>
#include <iostream>
using namespace std;
#include "cpp/strings.h"
#include "cpp/tokens.h"
#include <fstream>
template <typename T>
struct Option;
template <typename T>
struct Peekable;
class String;
enum Token: int;
struct Token_t;
enum VariableState: int;
struct AstToken;
struct CompilerPath;
enum MessageSeverity: int;
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
struct VariableNBool;
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
string token_to_string(Token t);
string variable_state_to_cpp(VariableState self);
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
string expr_to_cpp(Expressioner* self, int indentation);
string try_add_token(string id, vector<AstToken>* ast);
bool is_str_tokens(string s);
bool is_char_token(char ch);
bool is_char_number(char ch);
Option<string> try_get_dbl(Peekable<char>* peekable, char ch);
string get_matching(Peekable<char>* peekable, char ch);
AstToken collect_num(Peekable<char>* peekable, char ch);
vector<AstToken> ast_create(string content);
vector<string> imports_construct(Compiler* compiler_t);
vector<string> imports_construct_impl(Compiler* compiler_t);
vector<string> imports_creation(Compiler* compiler_t, AstToken next);
bool imports_check_duplicate(vector<string> imports, string id);
void validate_enum(Enum enumerator, Compiler* compiler_t);
Enum enums_construct(Compiler* compiler_t);
Expressioner for_construct(Compiler* compiler_t);
Expressioner expression_construct(Compiler* compiler_t, AstToken first);
Expressioner get_let_expr(Compiler* compiler_t);
Expressioner switch_construct(Compiler* compiler_t);
vector<Expressioner> create_case(Compiler* compiler_t, bool is_default);
Expressioner condition_construct(Compiler* compiler_t, string condition_type);
Option<string> get_value(Compiler* compiler_t, bool found_setter);
Variable get_type(Compiler* compiler_t);
VariableNBool construct_args(Compiler* compiler_t, Option<string> type_name);
vector<string> template_construct(Compiler* compiler_t);
void validate_function(Function function, Compiler* compiler_t);
Function function_construct(Compiler* compiler_t, VariableState variable_state, bool constructor);
void class_validate(Class class_def, Compiler* compiler_t);
Class class_construct(Compiler* compiler_t, bool is_struct);
int main(int argc, char* argv[]);
CompileOutput compile_main(CompilerPath paths, Program p);
CompileOutput compile(CompilerPath paths, Program p, bool is_main);
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
   bool starts_with(string start) {
      
return  _value.rfind( start, 0)== 0;
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
enum Token: int {
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
   TLBlock,
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
   TRBlock,
   TReturn,
   TRParen,
   TPointer,
   TSemiColon,
   TStruct,
   TSub,
   TSum,
   TTrue,
   TType,
   TUntil,
   TUse,
   TEnum,
   TString,
   TChar,
   TFloat,
   TDefault,
   TCase,
   TSwitch,
   UNKNOWN,
};
struct Token_t {
 public:
   Token t = TId;
 public:
   Token_t (string s) {
      auto S = String(s);
         if(S.starts_with ( QUOTE )    ) {
            
 t= TString;
return ;
}
         else if(S.starts_with ( "'" )    ) {
            
 t= TChar;
return ;
}
         else if(s  == TOKEN_SUB  ) {
            
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
         else if(s  == TOKEN_LBLOCK  ) {
            
 t= TLBlock;
return ;
}
         else if(s  == TOKEN_RBLOCK  ) {
            
 t= TRBlock;
return ;
}
         else if(s  == TOKEN_ASTERIX  ) {
            
 t= TAsterix;
return ;
}
         else if(s  == TOKEN_POINTER  ) {
            
 t= TPointer;
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
         else if(any ( s , { TOKEN_ZERO , TOKEN_ONE , TOKEN_TWO } )    ) {
            
 t= TNumber;
return ;
}
         else if(any ( s , { TOKEN_THREE , TOKEN_FOUR , TOKEN_FIVE } )    ) {
            
 t= TNumber;
return ;
}
         else if(any ( s , { TOKEN_SIX , TOKEN_SEVEN , TOKEN_EIGHT , TOKEN_NINE } )    ) {
            
 t= TNumber;
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
         else if(any ( s , { TOKEN_WHILE , TOKEN_LOOP } )    ) {
            
 t= TCondition;
return ;
}
         else if(any ( s , { TOKEN_IFS , TOKEN_ELIF , TOKEN_ELSE } )    ) {
            
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
         else if(any ( s , { TOKEN_FOR , TOKEN_FOREACH } )    ) {
            
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
         else if(s  == TOKEN_INCLUDE  ) {
            
 t= TInclude;
return ;
}
         else if(any ( s , { TOKEN_INT , TOKEN_STR , TOKEN_STRING } )    ) {
            
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
         else if(s  == TOKEN_STRUCT  ) {
            
 t= TStruct;
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
         else if(s  == TOKEN_EOF  ) {
            
 t= TEof;
return ;
}
         else if(s  == TOKEN_CASE  ) {
            
 t= TCase;
return ;
}
         else if(s  == TOKEN_DEFAULT  ) {
            
 t= TDefault;
return ;
}
         else if(s  == TOKEN_SWITCH  ) {
            
 t= TSwitch;
return ;
}
      t= TId;
   }
 public:
   bool is_base() {
         switch(t    ) {
            case TClass:
            case TEof:
            case TFunction:
            case TGet:
            case TGlobal:
            case TInclude:
            case TMacroDefinition:
            case TNewLine:
            case TSemiColon:
            case TStruct:
            case TUse:
            case TCompiler:
            case TEnum:
            
return true;
            default:
;
            
return false;
}
   }
 public:
   bool is_do() {
      
return  any( t,{ TDo, TDobr, TDoco, TDore, TDoremi});
   }
 public:
   bool is_conditional() {
         switch(t    ) {
            case TEquality:
            case TNonEquality:
            case TMoreThanOrEquals:
            case TLessThanOrEquals:
            case TLessThan:
            case TMoreThan:
            case TAnyEquals:
            case TAllEquals:
            case TAllNotEquals:
            case TAllLessThan:
            case TAllMoreThan:
            case TAllLessOrEquals:
            case TAllMoreOrEquals:
            
return true;
            default:
;
            
return false;
}
   }
 public:
   bool is_conditional_sep() {
      
return  any( t,{ TAnd, TOr});
   }
};
string token_to_string(Token t) {
      switch(t    ) {
         case TSub:
         
return "TSub";
         case TComma:
         
return "TComma";
         case TColon:
         
return "TColon";
         case TSemiColon:
         
return "TSemiColon";
         case TNonEquality:
         
return "TNonEquality";
         case TLParen:
         
return "TLParen";
         case TBang:
         
return "TBang";
         case TRParen:
         
return "TRParen";
         case TLBrack:
         
return "TLBrack";
         case TRBrack:
         
return "TRBrack";
         case TLBlock:
         
return "TLBlock";
         case TRBlock:
         
return "TRBlock";
         case TAsterix:
         
return "TAsterix";
         case TForwardSlash:
         
return "TForwardSlash";
         case TComment:
         
return "TComment";
         case TNewLine:
         
return "TNewLine";
         case TAnd:
         
return "TAnd";
         case TSum:
         
return "TSum";
         case TLessThan:
         
return "TLessThan";
         case TDblLessThan:
         
return "TDblLessThan";
         case TAllLessThan:
         
return "TAllLessThan";
         case TLessThanOrEquals:
         
return "TLessThanOrEquals";
         case TAllNotEquals:
         
return "TAllNotEquals";
         case TEquals:
         
return "TEquals";
         case TAllEquals:
         
return "TAllEquals";
         case TAllLessOrEquals:
         
return "TAllLessOrEquals";
         case TEquality:
         
return "TEquality";
         case TCoolArrow:
         
return "TCoolArrow";
         case TAllMoreOrEquals:
         
return "TAllMoreOrEquals";
         case TAnyEquals:
         
return "TAnyEquals";
         case TMoreThan:
         
return "TMoreThan";
         case TMoreThanOrEquals:
         
return "TMoreThanOrEquals";
         case TDblMoreThan:
         
return "TDblMoreThan";
         case TAllMoreThan:
         
return "TAllMoreThan";
         case TOr:
         
return "TOr";
         case TNumber:
         
return "TNumber";
         case TFloat:
         
return "TFloat";
         case TClass:
         
return "TClass";
         case TCompiler:
         
return "TCompiler";
         case TMacroDefinition:
         
return "TMacroDefinition";
         case TDo:
         
return "TDo";
         case TDobr:
         
return "TDobr";
         case TDoco:
         
return "TDoco";
         case TDore:
         
return "TDore";
         case TDoremi:
         
return "TDoremi";
         case TEnum:
         
return "TEnum";
         case TExtend:
         
return "TExtend";
         case TFalse:
         
return "TFalse";
         case TFunction:
         
return "TFunction";
         case TFor:
         
return "TFor";
         case TGet:
         
return "TGet";
         case TGlobal:
         
return "TGlobal";
         case TInclude:
         
return "TInclude";
         case TType:
         
return "TType";
         case TLet:
         
return "TLet";
         case TPrivate:
         
return "TPrivate";
         case TProtected:
         
return "TProtected";
         case TPublic:
         
return "TPublic";
         case TReturn:
         
return "TReturn";
         case TStruct:
         
return "TStruct";
         case TTrue:
         
return "TTrue";
         case TUntil:
         
return "TUntil";
         case TUse:
         
return "TUse";
         case TCondition:
         
return "TCondition";
         case TDefault:
         
return "TDefault";
         case TCase:
         
return "TCase";
         case TSwitch:
         
return "TSwitch";
         default:
;
         
return "TId";
}
}
enum VariableState: int {
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
         default:
;
         
return  PRIVATE_STATE;
}
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
 public:
   string to_string() {
      
return "["+ name+"]: Token: "+ token_to_string( token);
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
enum MessageSeverity: int {
   Hint,
   Error,
};
void display_message(MessageSeverity severity, string msg) {
   
 println( to_string( severity)+" "+ msg);
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
   string to_cpp_start() {
      
return  ENUM+ name+": int";
   }
 public:
   string to_cpp_h() {
      
return  to_cpp_start()+ LINE_END;
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
         for(int i = 0; i < lines.size(); i++) {
            
 for_str+= expr_to_cpp( &lines.at( i), indentation+ 1);
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
string expr_to_cpp(Expressioner* self, int indentation) {
   auto condition = self->e_condition;
   auto foreacher = self->e_for;
   auto line = self->line;
      if(condition.is_some ( )    ) {
         
return  condition.value_or( Conditions( EMPTY)) .to_cpp( indentation+ 1);
}
      if(foreacher.is_some ( )    ) {
         
return  foreacher.value_or( For()) .to_cpp( indentation+ 1);
}
   string expression= EMPTY;
      for(int i = 0; i < indentation; i++) {
         
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
      // println( ast.peek() .value_or( AstToken()) .to_string());
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
      
 arguments.push_back( String( arg) .replace( QUOTE, EMPTY));
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
      if(id.size ( )  == 0  ) {
         
return  id;
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
   return  Token_t( s) .t!= TId;
}
bool is_char_token(char ch) {
   string s( 1, ch);
   return  Token_t( s) .t!= TId;
}
bool is_char_number(char ch) {
   string s( 1, ch);
   return  Token_t( s) .t== TNumber;
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
   string matching( 1, ch);
      while(true   ) {
         auto c = peekable->next();
            if(c.is_none ( )    ) {
               
return  matching;
}
         string matchbuf( 1, c.value_or(' '));
         matching+= matchbuf;
            if(c.value_or ( ' ' )  == ch  ) {
               
return  matching;
}
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
               token.token= is_float ? TFloat: TNumber;
               token.t= Token_t("0");
               token.t.t= is_float ? TFloat: TNumber;
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
            if(c_opt.is_none ( )    ) {
                try_add_token( id, &ast);
break ;
}
         auto c = c_opt.value_or(' ');
            if(any ( c , { CHAR_QUOTE , CHAR_SINGLE } )    ) {
               auto matched = get_matching(&peekable,c);
               id= try_add_token( id, &ast);
                try_add_token( matched, &ast);
continue ;
}
            else if(is_char_number ( c )    ) {
               auto num = collect_num(&peekable,c);
               id= try_add_token( id, &ast);
                ast.push_back( num);
continue ;
}
         string ch( 1, c);
         auto is_white_space = any(c,{'\n',' ','\t'});
         auto is_both_token = is_str_tokens(id)==is_char_token(c);
            if(! is_both_token    ) {
               id= try_add_token( id, &ast);
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
               id= try_add_token( id, &ast);
                ast.push_back( AstToken( c));
continue ;
}
            else if(is_white_space    ) {
               id= try_add_token( id, &ast);
                  if(c  == '\n'  ) {
                     
 ast.push_back( AstToken("\n"));
}
               continue;
}
         id+= ch;
}
   //"Push extra sets of EOF to ensure it wont break badly";
   ast.push_back( AstToken("EOF"));
   ast.push_back( AstToken("EOF"));
   ast.push_back( AstToken("EOF"));
   ast.push_back( AstToken("EOF"));
   ast.push_back( AstToken("EOF"));
   ast.push_back( AstToken("EOF"));
   return  ast;
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
            if(any ( next.token , { TEof , TNewLine , TComma , TRBrack } )    ) {
                  if(id.size ( )  > 0  &&! imports_check_duplicate ( imports , id )    ) {
                     
 imports.push_back( id);
}
               id= EMPTY;
}
            else if(next.token  == TLBrack  ) {
               auto combined = imports_construct_impl(compiler_t);
                  for(int i = 0; i < combined.size(); i++) {
                     auto base = id;
                     base+= combined.at( i);
                     imports.push_back( base);
}
               id= EMPTY;
}
            else if(next.t.is_base ( )    ) {
               
 display_err_message("[Import]: Token not allowed: "+ next.name);
}
            else {
               
 id+= next.name;
}
            if(any ( next.token , { TEof , TNewLine , TRBrack } )    ) {
               
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
            if(next.token  == TUse  ) {
               contains= compiler_t-> contains_use( imp);
                  if(contains    ) {
                     display_hint_message("[Use]: Duplicate entry of: "+ token_to_string( next.token));
                     found=true;
}
               continue;
}
            else if(next.token  == TInclude  ) {
               contains= compiler_t-> contains_inc( imp);
                  if(contains    ) {
                     display_hint_message("[Include]: Duplicate entry of: "+ token_to_string( next.token));
                     found=true;
}
               continue;
}
            else if(next.token  == TGet  ) {
               
 continue;
}
         display_err_message("["+ token_to_string( next.token)+"]: Unhandled import");
}
      if(! found    ) {
            if(next.token  == TUse  ) {
               
 compiler_t-> add_use( import);
}
            else if(next.token  == TInclude  ) {
               
 compiler_t-> add_inc( import);
}
            else if(next.token  == TGet  ) {
               
return  import_return;
}
            else {
               
 display_err_message("["+ token_to_string( next.token)+"]: Unhandled import");
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
void validate_enum(Enum enumerator, Compiler* compiler_t) {
   auto contains = compiler_t->contains_enum(enumerator.name);
      if(contains    ) {
         
 display_err_message("Duplicate instances Enum of: "+ enumerator.name);
}
}
Enum enums_construct(Compiler* compiler_t) {
   auto id = get_id_or_exit(compiler_t->next(),"[Enum] Requires Id in initialization");
   auto enumerator = Enum(id);
   get_arrow_or_exit( compiler_t-> next(),"[Enum] Requires [=>] after Id");
   auto enum_def = EnumValue();
      while(true   ) {
         auto next = get_next_or_exit(compiler_t->next(),"[Enum] Ends without closing itself");
            if(next.token  == TId  ) {
                  if(enum_def.name.size ( )  == 0  ) {
                      enum_def.name= next.name;
continue ;
}
               display_err_message("[Enum] Cannot assign id to EnumValue that already has id");
}
            else if(next.token  == TComma  ) {
                  if(enum_def.name.size ( )  == 0  ) {
                     
 display_err_message("[Enum] Missing enum before separator");
}
               enumerator.enums.push_back( enum_def);
               enum_def= EnumValue();
}
            else if(any ( next.token , { TNumber , TEquals } )    ) {
                  if(enum_def.name.size ( )  != 0  ) {
                     
 break;
}
               display_err_message("[Enum] Cannot assign value to EnumValue without id");
}
            if(any ( next.token , { TSemiColon , TEof } )    ) {
               
 break;
}
            if(any ( next.token , { TId , TNewLine , TComma } )    ) {
               
 continue;
}
         display_err_message("[Enum] Invalid token inside Enum constructor");
}
   validate_enum( enumerator, compiler_t);
   compiler_t-> add_enum( enumerator);
   return  enumerator;
}
Expressioner for_construct(Compiler* compiler_t) {
   auto for_def = For();
   for_def.iterator= get_id_or_exit( compiler_t-> next(),"[For] For loop is not closed");
   get_or_exit( compiler_t-> next(), TUntil,"[For] Missing until keyword");
   for_def.until= compiler_t-> next() .value_or( AstToken("NONE")) .name;
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"[For] For loop is not closed");
            if(x.t.is_do ( )    ) {
               for_def.lines.push_back( expression_construct( compiler_t, x));
               return  Expressioner( None< Conditions>(), Some( for_def), None<string>());
}
            if(x.token  == TNewLine  ) {
               
 break;
}
         for_def.until+= x.name;
}
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"[For] For loop is not closed");
            if(any ( x.token , { TSemiColon , TEof } )    ) {
               
 break;
}
            if(x.token  == TNewLine  ) {
               
 continue;
}
            switch(x.token    ) {
               case TCondition:
                for_def.lines.push_back( condition_construct( compiler_t, x.name));
break ;
               case TFor:
                for_def.lines.push_back( for_construct( compiler_t));
break ;
               case TSwitch:
                for_def.lines.push_back( switch_construct( compiler_t));
break ;
               default:
;
                for_def.lines.push_back( expression_construct( compiler_t, x));
break ;
}
}
   return  Expressioner( None< Conditions>(), Some( for_def), None<string>());
}
Expressioner expression_construct(Compiler* compiler_t, AstToken first) {
   string doing= EMPTY;
   string expression= EMPTY;
      if(first.token  == TLet  ) {
         
return  get_let_expr( compiler_t);
}
      switch(first.token    ) {
         case TDoco:
          doing=";\ncontinue ";
break ;
         case TDobr:
          doing=";\nbreak ";
break ;
         case TDore:
         
 doing=";\nreturn ";
         case TDo:
          expression="\n";
break ;
         case TDoremi:
          expression="\nreturn ";
break ;
         case TReturn:
          expression="return ";
break ;
         default:
;
          expression= first.name;
break ;
}
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"[Expression] Expression ended unexpectedly");
            if(any ( x.token , { TEof , TNewLine } )    ) {
                expression+= doing;
break ;
}
            if(any ( x.token , { TNumber , TId } )    ) {
               
 expression+=" ";
}
            if(x.t.is_do ( )    ) {
               
 expression+="\n";
}
            switch(x.token    ) {
               case TDo:
               
 break;
               case TDore:
                doing=";\nreturn ";
break ;
               case TDobr:
                doing=";\nbreak ";
break ;
               case TDoco:
                doing=";\ncontinue ";
break ;
               case TDoremi:
                expression+="return ";
break ;
               case TLet:
                expression+="auto";
break ;
               case TReturn:
                expression+="return ";
break ;
               default:
;
                expression+= x.name;
break ;
}
}
   return  Expressioner( None< Conditions>(), None< For>(), Some( expression));
}
Expressioner get_let_expr(Compiler* compiler_t) {
   auto id = get_id_or_exit(compiler_t->next(),"[Let] Required id after let");
   get_or_exit( compiler_t-> next(), TEquals,"[Let] Required equals after id");
   string expression= EMPTY;
   string value= EMPTY;
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"LET exception");
            if(any ( x.token , { TEof , TNewLine } )    ) {
               
 break;
}
         value+= x.name;
}
   auto token = Token_t(value).t;
      if(any ( token , { TFalse , TTrue } )    ) {
         
 expression="bool ";
}
      else if(token  == TNumber  ) {
         
 expression="int ";
}
      else if(token  == TFloat  ) {
         
 expression="float ";
}
      else if(token  == TChar  ) {
         
 expression="char ";
}
      else if(token  == TString  ) {
         
 expression="string ";
}
      else {
         
 expression="auto ";
}
   expression+= id+" = "+ value;
   return  Expressioner( None< Conditions>(), None< For>(), Some( expression));
}
Expressioner switch_construct(Compiler* compiler_t) {
   auto cond = Conditions("switch");
   auto expression = ConditionalExpression();
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"[Switch] Switch is not closed");
            if(x.t.is_do ( )    ) {
               
 display_err_message("[Switch] Switch statements cannot have a do parameter");
}
            if(x.token  == TNewLine  ) {
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
               case TDefault:
               result= create_case( compiler_t, x.token== TDefault);
                  for(int i = 0; i < result.size(); i++) {
                     
 cond.lines.push_back( result.at( i));
}
               break;
               case TCase:
               result= create_case( compiler_t, x.token== TDefault);
                  for(int i = 0; i < result.size(); i++) {
                     
 cond.lines.push_back( result.at( i));
}
               break;
               case TEof:
                exit=true;
break ;
               case TSemiColon:
                exit=true;
break ;
               case TNewLine:
               
 break;
               default:
;
                display_err_message("[Switch] Token not allowed in switch "+ x.token);
break ;
}
            if(exit    ) {
               
 break;
}
}
   return  Expressioner( Some( cond), None< For>(), None<string>());
}
vector<Expressioner> create_case(Compiler* compiler_t, bool is_default) {
   vector< Expressioner> lines={};
   string label= EMPTY;
      if(! is_default    ) {
         auto next = get_next_or_exit(compiler_t->next(),"[Switch] Case unfinished");
            if(none ( next.token , { TId , TNumber , TChar } )    ) {
               
 display_err_message("Token not allowed in switch: ");
}
         label="case "+ next.name+":\n";
         lines.push_back( Expressioner( None< Conditions>(), None< For>(), Some( label)));
}
      else {
         label="default:\n";
         lines.push_back( Expressioner( None< Conditions>(), None< For>(), Some( label)));
}
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"[Switch] Case unfinished");
         vector< Expressioner> result={};
            switch(x.token    ) {
               case TCase:
               compiler_t-> prev();
               
return  lines;
               case TDefault:
               compiler_t-> prev();
               
return  lines;
               case TSemiColon:
               compiler_t-> prev();
               
return  lines;
               case TCondition:
                lines.push_back( condition_construct( compiler_t, x.name));
break ;
               case TFor:
                lines.push_back( for_construct( compiler_t));
break ;
               case TSwitch:
                lines.push_back( switch_construct( compiler_t));
break ;
               case TNewLine:
               
 break;
               default:
;
                lines.push_back( expression_construct( compiler_t, x));
break ;
}
}
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
         auto x = get_next_or_exit(compiler_t->next(),"[Condition] Condition is not closed");
            if(x.t.is_do ( )    ) {
               cond.add_expr( expression);
               cond.lines.push_back( expression_construct( compiler_t, x));
               return  Expressioner( Some( cond), None< For>(), None<string>());
}
            if(x.t.is_conditional_sep ( )    ) {
               expression.continuation= x.name;
               cond.add_expr( expression);
                expression= ConditionalExpression();
continue ;
}
            if(x.t.is_conditional ( )    ) {
                expression.operator_value= x.name;
continue ;
}
            if(x.token  == TNewLine  ) {
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
         auto x = get_next_or_exit(compiler_t->next(),"[Condition] Condition is not closed");
            if(any ( x.token , { TSemiColon , TEof } )    ) {
               
 break;
}
            if(x.token  == TNewLine  ) {
               
 continue;
}
            switch(x.token    ) {
               case TCondition:
                cond.lines.push_back( condition_construct( compiler_t, x.name));
break ;
               case TFor:
                cond.lines.push_back( for_construct( compiler_t));
break ;
               case TSwitch:
                cond.lines.push_back( switch_construct( compiler_t));
break ;
               default:
;
                cond.lines.push_back( expression_construct( compiler_t, x));
break ;
}
}
   return  Expressioner( Some( cond), None< For>(), None<string>());
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
         
 get_eq_or_exit( compiler_t-> next(),"[Variable]: Invalid value setter");
}
      while(true   ) {
         auto next = get_next_or_exit(compiler_t->next(),"[Variable]: Invalid value");
            if(next.token  == TNewLine  ) {
               
 break;
}
         value+= next.name;
}
   return  value.size()== 0 ? None<string>(): Some( value);
}
Variable get_type(Compiler* compiler_t) {
   auto next = get_next_or_exit(compiler_t->next(),"[Variable]: Invalid Function Return Value");
   auto variable = Variable(true);
      if(any ( next.token , { TId , TType } )    ) {
         
 variable.v_type= next.name;
}
      else if(next.token  != TNewLine  ) {
         
 display_err_message("[Variable]: Expected return value type got:\n"+ token_to_string( next.token));
}
   auto tried = try_get(compiler_t->peek(),TLessThan);
      if(tried    ) {
            if(! variable.has_id ( )    ) {
               
 display_err_message("[Variable]: Variable declaration cannot have template without id:\n"+ variable.v_type);
}
         next= get_next_or_exit( compiler_t-> next(),"[Variable]: Invalid Declaration");
         variable.v_type+= next.name;
            while(true   ) {
               next= get_next_or_exit( compiler_t-> next(),"[Variable]: Invalid Declaration");
               variable.v_type+= next.name;
                  if(next.token  == TMoreThan  ) {
                     
 break;
}
}
}
   tried= try_get( compiler_t-> peek(), TAsterix);
      if(tried    ) {
         
 variable.v_type+= get_or_exit( compiler_t-> next(), TAsterix,"[Variable] Unexpected error");
}
   return  variable;
}
VariableNBool construct_args(Compiler* compiler_t, Option<string> type_name) {
   auto variable = Variable();
      if(type_name.is_some ( )    ) {
         
 variable.v_type= type_name.value_or("void");
}
   bool is_end = false;
      while(true   ) {
         auto next = get_next_or_exit(compiler_t->next(),"[Variable]: Invalid Declaration");
            if(any ( next.token , { TNewLine , TCoolArrow } )    ) {
                is_end=true;
break ;
}
            if(next.token  == TEquals  ) {
                variable.v_value= get_value( compiler_t,true);
break ;
}
            else if(next.token  == TComma  ) {
               
 break;
}
            else if(next.token  == TAsterix  ) {
                  if(! variable.has_type ( )    ) {
                     
 display_err_message("[Variable]: Pointer infront of type not allowed:\n"+ variable.v_type);
}
               variable.v_type+= next.name;
}
            else if(next.token  == TLessThan  ) {
                  if(! variable.has_id ( )    &&! variable.has_type ( )    ) {
                     
 display_err_message("[Variable]: Variable declaration cannot have template without id and type:\n"+ variable.v_type);
}
               variable.v_type+= next.name;
                  while(true   ) {
                     next= get_next_or_exit( compiler_t-> next(),"[Variable]: Invalid Declaration");
                     variable.v_type+= next.name;
                        if(next.token  == TMoreThan  ) {
                           
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
               display_err_message("[Variable]: Variable declaration already complete:\n"+ variable.id);
}
}
      if(! variable.has_minimum ( )    &&! is_end    ) {
         
 display_err_message("[Variable]: Variable declaration incomplete:\n"+ variable.id);
}
   return  VariableNBool( variable, is_end);
}
vector<string> template_construct(Compiler* compiler_t) {
   vector<string> templates={};
      while(true   ) {
         auto next = get_next_or_exit(compiler_t->next(),"[Template]: Template declaration invalid");
            if(next.token  == TId  ) {
                templates.push_back( next.name);
continue ;
}
            else if(any ( next.token , { TComma , TLessThan } )    ) {
               
 continue;
}
            else if(next.token  == TMoreThan  ) {
               
 break;
}
         display_err_message("[Template]: Token not allowed: "+ next.name);
}
   return  templates;
}
void validate_function(Function function, Compiler* compiler_t) {
   auto contains = compiler_t->contains_function(function.id);
      if(contains    ) {
            for(int i = 0; i < compiler_t->program.functions.size(); i++) {
               auto f = compiler_t->program.functions.at(i);
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
Function function_construct(Compiler* compiler_t, VariableState variable_state, bool constructor) {
   auto function = Function(variable_state);
      if(! constructor    ) {
         function.id= get_id_or_exit( compiler_t-> next(),"[FunctionError]: No Function Id");
}
   auto peeked_opt = compiler_t->peek();
      if(peeked_opt.is_none ( )    ) {
         
 display_err_message("Error when trying to parse function: "+ function.id);
}
      if(peeked_opt.value_or ( AstToken ( "NONE" ) ) .token  == TLessThan  ) {
         
 function.templates= template_construct( compiler_t);
}
      while(true   ) {
         auto vnb = construct_args(compiler_t,None<string>());
            if(! vnb.variable.has_minimum ( )    ) {
               
 break;
}
         function.add_args( vnb.variable);
            if(vnb.is_end    ) {
               
 break;
}
}
      if(function.id  == "main"  ) {
         function.add_args( Variable("argc","int", None<string>(), Private_State));
         function.add_args( Variable("argv[]","char*", None<string>(), Private_State));
         function.return_value= Some( Variable("","int", None<string>(), Private_State));
}
      else {
         
 function.return_value= Some( get_type( compiler_t));
}
      while(true   ) {
         auto x = get_next_or_exit(compiler_t->next(),"Function is not closed "+function.id);
            if(any ( x.token , { TSemiColon , TFunction , TEof } )    ) {
               
 break;
}
            if(x.token  == TNewLine  ) {
               
 continue;
}
            switch(x.token    ) {
               case TFor:
                function.add_expr( for_construct( compiler_t));
break ;
               case TCondition:
                function.add_expr( condition_construct( compiler_t, x.name));
break ;
               case TSwitch:
                function.add_expr( switch_construct( compiler_t));
break ;
               default:
;
                function.add_expr( expression_construct( compiler_t, x));
break ;
}
            if(x.t.is_do ( )    ) {
               
 break;
}
}
      if(function.id  == "main"  ) {
         
 function.add_expr( Expressioner( None< Conditions>(), None< For>(), Some((string)"return 0")));
}
   // validate_function( function, compiler_t);
   compiler_t-> add_fn( function);
   return  function;
}
void class_validate(Class class_def, Compiler* compiler_t) {
   // Check Duplicate Classes;
   auto contains = compiler_t->contains_class(class_def.id);
      if(contains    ) {
         
 display_err_message("Duplicate instances of: "+ class_def.id);
}
   // Check Inheritance;
   contains= compiler_t-> contains_class( class_def.inherit.value_or( EMPTY));
      if(class_def.inherit.is_some ( )    &&! contains    ) {
         display_err_message("Invalid Inheritance of: "+ class_def.id+", Inherits: "+ class_def.inherit.value_or( EMPTY));
}
}
Class class_construct(Compiler* compiler_t, bool is_struct) {
   auto class_def = Class();
   class_def.is_struct= is_struct;
   class_def.id= get_id_or_exit( compiler_t-> next(),"[ClassError] Invalid Class Declaration");
   // Set Inheritance Or Template;
   auto next = get_next_or_exit(compiler_t->next(),"[ClassError] Invalid class definition of: "+class_def.id);
      if(next.token  == TLessThan  ) {
         class_def.templates= template_construct( compiler_t);
         next= get_next_or_exit( compiler_t-> next(),"[ClassError] Invalid class definition of: "+ class_def.id);
}
      if(next.token  == TCoolArrow  ) {
         
 class_def.inherit= Some( get_id_or_exit( compiler_t-> next(),"[ClassError] Invalid Inheritor Token\nExpected Id for inheritance for class: "+ class_def.id));
}
   // Construct inner Class values;
   auto variable_state = !is_struct?Private_State:Public_State;
      while(true   ) {
         auto next = get_next_or_exit(compiler_t->next(),"[ClassError] Class is not closed "+class_def.id);
            if(next.token  == TFunction  ) {
               auto function = function_construct(compiler_t,variable_state,false);
                class_def.functions.push_back( function);
continue ;
}
            else if(any ( next.token , { TId , TType } )    ) {
                  if(next.name  == class_def.id  ) {
                     auto function = function_construct(compiler_t,Public_State,true);
                     function.return_value= Some( Variable( EMPTY, class_def.id, None<string>(), Private_State));
                      class_def.functions.push_back( function);
continue ;
}
               auto vnb = construct_args(compiler_t,Some(next.name));
               vnb.variable.variable_state= variable_state;
                class_def.variables.push_back( vnb.variable);
continue ;
}
            else if(any ( next.token , { TEof , TSemiColon , TClass } )    ) {
               
 break;
}
            switch(next.token    ) {
               case TPrivate:
                variable_state= Private_State;
break ;
               case TProtected:
                variable_state= Protected_State;
break ;
               case TPublic:
                variable_state= Public_State;
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
   CompileOutput (string output, string includes, string headers, string fnheaders, vector<string> arguments) {
      this-> output= output;
      this-> includes= includes;
      this-> headers= headers;
      this-> fnheaders= fnheaders;
      this-> arguments= arguments;
   }
};
int main(int argc, char* argv[]) {
   bool should_remove_cpp = false;
   FpFn fpfn= get_folder_and_name( get_file_path( argc, argv));
   auto paths = CompilerPath(get_file_path(argc,argv),fpfn.f_p,fpfn.f_n);
   auto p = Program();
   auto output = compile_main(paths,p);
   write_program( output.content(), paths);
   compile_program( paths, output.arguments, should_remove_cpp);
   return 0;
}
CompileOutput compile_main(CompilerPath paths, Program p) {
   
return  compile( paths, p,true);
}
CompileOutput compile(CompilerPath paths, Program p, bool is_main) {
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
            if(! next.t.is_base ( )    ) {
               
 display_err_message("Token not allowed in base: "+ next.name+", Type: "+ token_to_string( next.token));
}
            if(next.token  == TEof  ) {
               
 break;
}
            else if(next.token  == TNewLine  ) {
               
 continue;
}
            else if(any ( next.token , { TStruct , TClass } )    ) {
               auto classdef = class_construct(&compiler_t,next.token==TStruct);
               output+= classdef.to_cpp();
               headers+= classdef.to_cpp_h();
}
            else if(next.token  == TFunction  ) {
               auto fndef = function_construct(&compiler_t,Public_State,false);
               output+= fndef.to_cpp(false);
               fnheaders+= fndef.to_cpp_h();
}
            else if(next.token  == TEnum  ) {
               auto enumdef = enums_construct(&compiler_t);
               output+= enumdef.to_cpp();
               headers+= enumdef.to_cpp_h();
}
            else if(next.token  == TInclude  ) {
               incs= imports_creation( &compiler_t, next);
                  for(int i = 0; i < incs.size(); i++) {
                     
 includes+= Include( incs.at( i)) .to_cpp();
}
}
            else if(next.token  == TUse  ) {
               incs= imports_creation( &compiler_t, next);
                  for(int i = 0; i < incs.size(); i++) {
                     
 includes+= Uses( incs.at( i)) .to_cpp();
}
}
            else if(next.token  == TGet  ) {
               incs= imports_creation( &compiler_t, next);
                  for(int i = 0; i < incs.size(); i++) {
                     FpFn fpfn= get_folder_and_name( paths.folder_path+ incs.at( i)+ HA_SUFFIX);
                     auto get_path = CompilerPath(paths.folder_path+incs.at(i)+HA_SUFFIX,fpfn.f_p,fpfn.f_n);
                     auto get_out = compile(get_path,compiler_t.program,false);
                     output+= get_out.output;
                     includes+= get_out.includes;
                     headers+= get_out.headers;
                     fnheaders+= get_out.fnheaders;
                     compiler_t.add_args( get_out.arguments);
}
}
            else if(next.token  == TCompiler  ) {
               get_arrow_or_exit( compiler_t.next(),"[Compiler] Missing start of compiler intent [=>]: "+ next.name);
               args= get_or_exit( compiler_t.next(), TString,"[Compiler] Missing value of compiler intent [TString]: "+ next.name);
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
      for(int i = 0; i < compiler.program.functions.size(); i++) {
         auto f = compiler.program.functions.at(i);
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
