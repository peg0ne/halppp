struct Program
    vector<Global> global = {}
    vector<Struct> structs = {}
    vector<Function> functions = {}
    vector<Class> classes = {}
    vector<Include> includes = {}
    vector<Uses> usings = {}
    vector<string> gets = {}
    vector<Enum> enums = {}
    Program => do return
;