#[derive(Debug)]
pub enum MessageSeverity {
    Hint,
    Error,
}

impl MessageSeverity {
    pub fn name(&self) -> String {
        match self {
            MessageSeverity::Hint => "Hint".to_string(),
            MessageSeverity::Error => "Error".to_string(),
        }
    }

    pub fn ansi_color_code(&self) -> String {
        match self {
            MessageSeverity::Hint => "94".to_string(),
            MessageSeverity::Error => "31".to_string(),
        }
    }
}

pub fn display_err_message(msg: &str) { 
    display_message(MessageSeverity::Error, msg);
}

pub fn display_hint_message(msg: &str) {
    display_message(MessageSeverity::Hint, msg);
}

fn display_message(severity: MessageSeverity, msg: &str) {
    println!(
        "\u{001b}[{}m{}: >> {}\u{001b}[0m",
        severity.ansi_color_code(),
        severity.name(),
        msg
    );
}