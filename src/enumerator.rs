use crate::{
    enums::Token,
    structs::{Enum, EnumValue, Compiler},
    utils::{get_id_or_exit, get_arrow_or_exit, get_next_or_exit},
    message::display_err_message,
};

pub fn construct(compiler: &mut Compiler) -> Enum {
    let id = get_id_or_exit(compiler.next(), "[Enum] Requires Id in initialization");
    let mut enumerator = Enum::from(id);
    get_arrow_or_exit(compiler.next(), "[Enum] Requires [=>] after Id");
    let mut enum_def = EnumValue::new();
    loop {
        let next = get_next_or_exit(compiler.next(), "[Enum] Ends without closing itself");
        match next.token {
            Token::Id => {
                if enum_def.name.len() > 0 {
                    display_err_message("[Enum] Cannot assign id to EnumValue that already has id");
                }
                enum_def.name = next.name;
            },
            Token::Number => {
                if enum_def.name.len() == 0 {
                    display_err_message("[Enum] Cannot assign value to EnumValue without id");
                }
                enum_def.value = Some(next.name);
            },
            Token::Equals => {
                if enum_def.name.len() == 0 {
                    display_err_message("[Enum] Cannot assign value to EnumValue without id");
                }
            },
            Token::NewLine => continue,
            Token::Comma => {
                if enum_def.name.len() == 0 {
                    display_err_message("[Enum] Missing enum before separator");
                }
                enumerator.enums.push(enum_def);
                enum_def = EnumValue::new();
            },
            Token::SemiColon => break,
            Token::EOF => break,
            _ => display_err_message("[Enum] Invalid token inside Enum constructor"),
        }
    }
    validate(&enumerator, compiler);
    compiler.add_enum(enumerator.to_owned());
    enumerator
}

fn validate(enumerator: &Enum, compiler: &Compiler) {
    if compiler.contains_enum(&enumerator.name) {
        display_err_message(format!("Duplicate instances Enum of: {}", enumerator.name).as_str());
    }
}