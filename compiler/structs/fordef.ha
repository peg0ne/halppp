struct For
    string iterator = EMPTY
    Option<string> named_variable = None<string>()
    string until = EMPTY
    vector<Expression> lines = {}
    bool is_foreach = false
    For => do return
    For bool is_foreach =>
        this->is_foreach = is_foreach
    ;
    fn to_cpp int indent => string
        let for_str = ""
        string iter = is_foreach && named_variable.is_none() ? $"{iterator}_iterator" : iterator
        // Evaluate the foreach collection once: `foreach x in f()` must not call f() every iteration.
        // auto&& binds to lvalues by reference and extends the lifetime of temporaries.
        let container = $"{iter}_container"
        string to = is_foreach ? $"(int){container}.size()" : until
        for i until indent do for_str += TAB
        if is_foreach
            for_str += "\n{\n"
            for_str += $"auto&& {container} = {until}{LINE_END}"
            for_str += $"auto {iter}_cursor = halppp_cursor({container}){LINE_END}"
        ;
        for_str += $"{FOR_START}{iter}{FOR_MID}{iter}{FOR_UNTIL}{to}"
        for_str += $"{FOR_AFTER_UNTIL}{iter}{FOR_END}"
        if is_foreach
            for_str += "auto "
            for_str += named_variable.is_some() ? named_variable.value_or("") : iterator
            for_str += $" = halppp_nth({container}, {iter}, {iter}_cursor);"
        ;
        for i until lines.size() do for_str += expr_to_cpp(&lines.at(i), indent + 1)
        for_str += BLOCK_END
        if is_foreach do for_str += "}\n"
        return for_str
    ;
;
// foreach indexes containers with .at(i) when it can, and walks an iterator otherwise
// (map, set, list, ...), so `foreach kv in some_map` works
fn foreach_helper => string
    let h = "#include <iterator>\n#include <type_traits>\n#include <utility>\n"
    h += "template <class C, class = void> struct halppp_iterable : std::false_type {};\n"
    h += "template <class C> struct halppp_iterable<C, std::void_t<decltype(std::begin(std::declval<C&>()))>> : std::true_type {};\n"
    h += "template <class C> auto halppp_cursor(C& c) {\n"
    h += "    if constexpr (halppp_iterable<C>::value) return std::begin(c);\n"
    h += "    else return 0;\n"
    h += "}\n"
    h += "template <class C, class It> decltype(auto) halppp_nth(C& c, int i, It& it) {\n"
    h += "    if constexpr (std::is_same_v<It, int>) return c.at(i);\n"
    h += "    else if constexpr (std::is_base_of_v<std::random_access_iterator_tag, typename std::iterator_traits<It>::iterator_category>) return c.at(i);\n"
    h += "    else {\n"
    h += "        if (i > 0) ++it;\n"
    h += "        return *it;\n"
    h += "    }\n"
    h += "}\n"
    return h
;
