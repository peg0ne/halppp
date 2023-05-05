use crate::{structs::{Condition, For, Select, Match}, message::display_err_message};

#[derive(Clone, Debug)]
pub struct Expression {
    pub e_condition: Option<Condition>,
    pub e_for: Option<For>,
    pub e_select: Option<Select>,
    pub e_match: Option<Match>,
    pub line: Option<String>,
}

impl Expression {
    pub fn to_cpp(self: &Expression, indentation: i32) -> String {
        let mut expression = String::new();
        let spacing = "    ";
        match self.e_condition.as_ref() {
            Some(condition) => return condition.to_cpp(indentation),
            _ => {}
        }
        match self.e_for.as_ref() {
            Some(for_e) => {
                let mut iter = for_e.iterator.to_owned();
                let mut to = for_e.until.to_owned();
                if for_e.is_foreach {
                    if for_e.named_variable.is_none() {
                        iter.push_str("_iterator");
                    }
                    to.push_str(".size()");
                }
                let formatted = format!(
                    "{}for(int {} = 0; {} < {}; {}++) {{\n",
                    spacing, iter, iter, to, iter
                );
                expression.push_str(formatted.as_str());
                if for_e.is_foreach {
                    let name_var = if for_e.named_variable.is_some() {
                        for_e.named_variable.to_owned().unwrap()
                    } else {
                        for_e.iterator.to_owned()
                    };
                    expression.push_str(format!("auto {} = {}.at({});\n", name_var, for_e.until, iter).as_str());
                }
                for line in for_e.lines.iter() {
                    expression.push_str(line.to_cpp(indentation + 1).as_str());
                }
                expression.push_str(format!("{}}}\n", spacing).as_str());
                return expression;
            }
            _ => {}
        }
        match self.e_select.as_ref() {
            Some(select_e) => {
                expression.push_str(format!("if ({}.is_some()) {{\n", select_e.optional_value).as_str());
                expression.push_str(format!("auto {} = {}.value_unsafe();\n", select_e.value_name, select_e.optional_value).as_str());
                for line in select_e.lines.iter() {
                    expression.push_str(line.to_cpp(indentation + 1).as_str());
                }
                expression.push_str(format!("{}}}\n", spacing).as_str());
                return expression;
            }
            _ => {}
        }
        match self.e_match.as_ref() {
            Some(match_e) => {
                if match_e.is_let {
                    match match_e.id.as_ref() {
                        Some(id) => {
                            expression.push_str(format!("auto {} =", id).as_str());
                            let mut default_statement: i32 = -1;
                            for (i,line) in match_e.statements.iter().enumerate() {
                                if line == "_" {
                                    default_statement = i.try_into().unwrap_or_default();
                                    break;
                                }
                            }
                            if default_statement == -1 {
                                display_err_message("[Match] match let statement requires default statement!");
                            }
                            let d_s: usize = default_statement.try_into().unwrap();
                            let l = &match_e.lines[d_s];
                            expression.push_str(l.last().unwrap());
                        }
                        _ => {}
                    }
                }
                expression.push_str(format!("{{\n    auto _match_expr_ = {} ;\n", match_e.matcher_expr).as_str());
                for (i, statement) in match_e.statements.iter().enumerate() {
                    if i == 0 {
                        expression.push_str(format!("if (_match_expr_ == {}) {{\n", statement).as_str());
                    } else if statement != "_" {
                        expression.push_str(format!("else if (_match_expr_ == {}) {{\n", statement).as_str());
                    } else {
                        expression.push_str("else {\n");
                    }
                    for (j, line) in match_e.lines[i].iter().enumerate() {
                        if j == match_e.lines[i].len() {
                            match match_e.id.as_ref() {
                                Some(id) => expression.push_str(format!("{} = ", id).as_str()),
                                _ => {}
                            }
                        }
                        expression.push_str(format!("{}\n", line).as_str());
                    }
                    expression.push_str("}\n");
                }
                expression.push_str("}\n");
                return expression;
            }
            _ => {}
        }
        if self.line.is_some() {
            let line = self.line.as_ref().unwrap();
            if line.len() != 0 {
                expression.push_str(line);
                if !line.starts_with("case") {
                    expression.push_str(";");
                }
            }
            expression.push_str("\n")
        }
        expression
    }
}