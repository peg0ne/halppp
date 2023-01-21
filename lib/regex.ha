inc => regex
use => std
get => vector

struct RegexMatch
    string match
    int position = 0
    RegexMatch => do return
    RegexMatch string match, int pos =>
        this->match = match
        this->position = pos
    ;
;

fn re string line, regex reg, int capture, vector<Vector> claimed => vector<RegexMatch>
    vector<RegexMatch> matches_str = {}
    sregex_iterator current(line.begin(), line.end(), reg)
    sregex_iterator last
    while current != last
        smatch match = *current
        if match.str(capture).size() != 0
            let pos = match.position(capture)
            let already_claimed = false
            foreach claim in claimed
                let in_start = pos >= claim.x
                let in_end = pos <= claim.y
                if in_start && in_end dobr already_claimed = true
            ;
            if !already_claimed
                matches_str.push_back(RegexMatch(match.str(capture), match.position(capture)))
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
        smatch match = *current
        if match.str(capture).size() != 0
            matches_str.push_back(RegexMatch(match.str(capture), match.position(capture)))
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
        smatch match = *current
        if match.str(capture).size() != 0
            matches_str.push_back(RegexMatch(match.str(capture), match.position(capture)))
        ;
        current++
    ;
    return matches_str
;