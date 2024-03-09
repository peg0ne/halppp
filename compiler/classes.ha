enum ClassError
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
;

fn c_err ClassError err => string doremi c_err(err, EMPTY, false, "")
fn c_err ClassError err, string opt => string doremi c_err(err, opt, false, "")
fn c_err ClassError err, string opt, bool display, string recap => string
    let msg = "[Class] "
    switch err
    case ClassError::Closed       dobr msg += "Class is not closed "
    case ClassError::Definition   dobr msg += "Invalid class definition of: "
    case ClassError::Duplicate    dobr msg += "Duplicate instance of: "
    case ClassError::Extend       dobr msg += "Missing => after extend in: "
    case ClassError::ExtendClosed dobr msg += "Error when trying to extend in: "
    case ClassError::ExtendNoId   dobr msg += "Missing id in extend: "
    case ClassError::Inheritance  dobr msg += "Invalid inheritance of: "
    case ClassError::NoId         dobr msg += "Invalid class declaration"
    case ClassError::NoInheritor  dobr msg += "Invalid Inheritor Token\nExpected Id for inheritance for class: "
    case ClassError::ExtendNotValid    dobr msg += "Invalid class extendor: "
    case ClassError::StaticNotValid    dobr msg += "Cannot make this static: "
    case ClassError::ConstNotValid     dobr msg += "Cannot make this const: "
    case ClassError::VirtualNotValid   dobr msg += "Cannot make this virtual: "
    case ClassError::DoubleDeclaration dobr msg += "Duplicate instance of variable: "
    case ClassError::InheritanceTemplate  dobr msg += "Function inheritance template misaligned: "
    case ClassError::InheritanceArguments dobr msg += "Function inheritance arguments misaligned: "
    case ClassError::InheritanceReturnValue dobr msg += "Function inheritance return value misaligned: "
    case ClassError::InheritanceMissingFunc dobr msg += "Function inheritance not found: "
    default do break
    ;
    msg += opt
    if display do error(msg, recap)
    return msg
;

fn class_validate Class class_def, Compiler *compiler_t =>
    // Check Duplicate Classes
    if compiler_t->has_class(class_def.id)
        c_err(ClassError::Duplicate, class_def.id, true, compiler_t->recap())
    ;
    // Check Inheritance
    select inherit from class_def.inherit
        select inherited from compiler_t->get_class(inherit)
            foreach inherited_func in inherited.functions
                if !inherited_func.virtualness do continue
                bool inherits = false
                foreach func in class_def.functions
                    if func.id != inherited_func.id do continue
                    if func.templates != inherited_func.templates do c_err(ClassError::InheritanceTemplate, $"{class_def.id}::{inherited_func.id}", true, compiler_t->recap())
                    if func.arguments.size() != inherited_func.arguments.size()
                        c_err(ClassError::InheritanceArguments, $"{class_def.id}::{inherited_func.id} {func.arguments.size()} {inherited_func.arguments.size()}", true, compiler_t->recap())
                    ;
                    foreach i, inherited_arg in inherited_func.arguments
                        if func.arguments[i].v_type != inherited_arg.v_type do c_err(ClassError::InheritanceArguments, $"{class_def.id}::{inherited_func.id} {func.arguments[i].v_type} {inherited_arg.v_type}", true, compiler_t->recap())
                    ;
                    if func.return_value.value_or(Variable()).v_type != inherited_func.return_value.value_or(Variable()).v_type
                        c_err(ClassError::InheritanceReturnValue, $"{class_def.id}::{inherited_func.id}", true, compiler_t->recap())
                    ;
                    inherits = true
                ;
                if !inherits do c_err(ClassError::InheritanceMissingFunc, $"{class_def.id}::{inherited_func.id}", true, compiler_t->recap())
            ;
            return
        ;
        c_err(ClassError::Inheritance, class_def.id, true, compiler_t->recap())
    ;
;

fn class_construct Compiler *compiler_t, bool is_struct, CompilerPath paths => Class
    let class_def = Class()
    class_def.is_struct = is_struct
    
    class_def.id = id_or_exit(compiler_t, c_err(ClassError::NoId))
    // Set Inheritance Or Template
    let next = next_or_exit(compiler_t, c_err(ClassError::Definition, class_def.id))
    if next.token == Token::LessThan
        class_def.templates = template_construct(compiler_t)
        next = next_or_exit(compiler_t, c_err(ClassError::Definition, class_def.id))
    ;
    if next.token == Token::CoolArrow
        class_def.inherit = Some(id_or_exit(compiler_t, c_err(ClassError::NoInheritor, class_def.id)))
    ;
    class_internal_declarations(compiler_t, is_struct, &class_def, paths)
    class_validate(class_def, compiler_t)
    compiler_t->add(class_def)
    return class_def
;

fn class_internal_declarations Compiler *compiler_t, bool is_struct, Class *class_def, CompilerPath paths =>
    //Construct inner Class values
    let variable_state = !is_struct ? VariableState::Private : VariableState::Public
    loop
        let next = next_or_exit(compiler_t, c_err(ClassError::Closed, class_def->id))
        let staticness = false
        let constantness = false
        let virtualness = false
        if next.token == Token::Static
            next = next_or_exit(compiler_t, c_err(ClassError::Closed, class_def->id))
            if none(next.token, {Token::Id, Token::Type, Token::Function, Token::Const})
                c_err(ClassError::StaticNotValid, next.name, true, compiler_t->recap())
            ;
            staticness = true
        ;
        if next.token == Token::Const
            next = next_or_exit(compiler_t, c_err(ClassError::Closed, class_def->id))
            if none(next.token, {Token::Id, Token::Type})
                c_err(ClassError::ConstNotValid, next.name, true, compiler_t->recap())
            ;
            constantness = true
        ;
        if next.token == Token::Virtual
            next = next_or_exit(compiler_t, c_err(ClassError::Closed, class_def->id))
            if next.token != Token::Function do c_err(ClassError::VirtualNotValid, next.name, true, compiler_t->recap())
            virtualness = true
        ;
        if next.token == Token::Extend
            arrow_or_exit(compiler_t, c_err(ClassError::Extend, class_def->id)) 
            let extends = imports_construct_impl(compiler_t)
            foreach extender in extends
                select content from read(paths.folder_path + extender + HA_SUFFIX)
                    let ast = ast_create(content)
                    let extend_compiler = Compiler(compiler_t->program, ast, 0)
                    class_internal_declarations(&extend_compiler, is_struct, class_def, paths)
                    continue
                ;
                c_err(ClassError::ExtendNotValid, extender, true, compiler_t->recap())
            ;
        ;
        if next.token == Token::Function
            let function = function_construct(compiler_t, variable_state, false, class_def->variables)
            function.staticness = staticness
            function.virtualness = virtualness
            doco class_def->functions.push_back(function)
        ;
        elif any(next.token, {Token::Id, Token::Type})
            if next.name == class_def->id
                let function = function_construct(compiler_t, VariableState::Public, true, class_def->variables)
                function.return_value = Some(Variable(EMPTY, class_def->id))
                doco class_def->functions.push_back(function)
            ;
            let vnb = construct_args(compiler_t, Some(next.name))
            vnb.variable.variable_state = variable_state
            vnb.variable.staticness = staticness
            vnb.variable.constantness = constantness
            if class_def->contains(vnb.variable)
                c_err(ClassError::DoubleDeclaration, vnb.variable.id, true, compiler_t->recap())
            ;
            doco class_def->variables.push_back(vnb.variable)
        ;
        elif any(next.token, {Token::Eof, Token::SemiColon, Token::Class}) do break
        switch next.token
        case Token::Private dobr variable_state = VariableState::Private
        case Token::Protected dobr variable_state = VariableState::Protected
        case Token::Public dobr variable_state = VariableState::Public
        default do break
        ;
    ;
;
