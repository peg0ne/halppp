#define CHAR_QUOTE '"'
#define CHAR_SINGLE '\''
#define TAB "   "
#define SPACE " "
#define EMPTY ""
#define NEWLINE "\n"
#define ASSIGNMENT " = "
#define TEMPLATE "template <typename "
#define TEMPLATE_MID ", typename "
#define TEMPLATE_END ">\n"
#define INHERIT ": public "
#define VOID "void"
#define ARG_SEP ", "
#define ARG_END ") {\n"
#define LPAREN "("
#define RPAREN ")"
#define LARROW "<"
#define RARROW ">"
#define RBRACK "}"
#define STRUCT "struct "
#define CLASS "class "
#define ENUM "enum "
#define INCLUDE "#include "
#define NAMESPACE "using namespace "
#define ENUM_SEP ",\n"
#define BLOCK_START " {\n"
#define BLOCK_END "}\n"
#define LINE_END ";\n"
#define PRIVATE_STATE " private:\n"
#define PROTECTED_STATE " protected:\n"
#define PUBLIC_STATE " public:\n"
#define FOR_START "for(int "
#define FOR_MID " = 0; "
#define FOR_UNTIL " < "
#define FOR_AFTER_UNTIL "; "
#define FOR_END "++) {\n"
#define RETURN_VALUE_IDS "return_value"
#define CPP_SUFFIX ".cpp"
#define HA_SUFFIX ".ha"
#define COMPILER_OUT " -o "
#define QUOTE "\""

struct FpFn;
struct Expressioner;
struct Compiler;
struct AstToken;
FpFn get_folder_and_name(string main);
Expressioner expression_construct(Compiler *compiler_t, AstToken first);
Expressioner condition_construct(Compiler *compiler_t, string condition_type);