inc => regex
use => std
get => vector

struct RegexMatch
    string reg_match
    int position = 0
    RegexMatch => do return
    RegexMatch string reg_match, int pos =>
        this->reg_match = reg_match
        this->position = pos
    ;
;

fn re string line, regex reg, int capture, vector<Vector> claimed => vector<RegexMatch>
    vector<RegexMatch> matches_str = {}
    sregex_iterator current(line.begin(), line.end(), reg)
    sregex_iterator last
    while current != last
        let reg_match = *current
        if reg_match.str(capture).size() != 0
            let pos = reg_match.position(capture)
            let already_claimed = false
            foreach claim in claimed
                let in_start = pos >= claim.x
                let in_end = pos <= claim.y
                if in_start && in_end dobr already_claimed = true
            ;
            if !already_claimed
                matches_str.push_back(RegexMatch(reg_match.str(capture), reg_match.position(capture)))
            ;
        ;
        current++
    ;
    return matches_str
;

fn re string line, regex reg, int capture => vector<RegexMatch>
    vector<RegexMatch> matches_str = {}
    sregex_iterator current(line.begin(), line.end(), reg)
    sregex_iterator last
    while current != last
        let reg_match = *current
        if reg_match.str(capture).size() != 0
            matches_str.push_back(RegexMatch(reg_match.str(capture), reg_match.position(capture)))
        ;
        current++
    ;
    return matches_str
;

fn re string line, string rex, int capture => vector<RegexMatch>
    vector<RegexMatch> matches_str = {}
    regex reg(rex)
    sregex_iterator current(line.begin(), line.end(), reg)
    sregex_iterator last
    while current != last
        let reg_match = *current
        if reg_match.str(capture).size() != 0
            matches_str.push_back(RegexMatch(reg_match.str(capture), reg_match.position(capture)))
        ;
        current++
    ;
    return matches_str
;