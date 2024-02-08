get => ngui, stringextensions, files
get => print

struct Stats
    string header
    int files
    int lines
    int words
    int chars
    int nalfa
    int maxle
    Stats vector<double> stats, int starting, string header =>
        this->header = header
        files = stats[0 + starting]
        lines = stats[1 + starting]
        words = stats[2 + starting]
        chars = stats[3 + starting]
        nalfa = stats[4 + starting]
        maxle = stats[5 + starting]
    ;
    fn max_num => int
        let max = files
        if lines > max do max = lines
        if words > max do max = words
        if chars > max do max = chars
        if nalfa > max do max = nalfa
        if maxle > max do max = maxle
        return max
    ;
;

fn to_string Stats *s => string
    return $"{s->header} {s->files} {s->lines} {s->words} {s->chars} {s->nalfa} {s->maxle}"
;

fn get_stats => vector<Stats>
    let output = system_output("./get-info.sh")
    let filtered = map<double>(output)
        .select(x => String(x).strip())
        .select(x => String(x).split())
        .where(x => x.size() > 0)
        .select(x => x[x.size() - 1])
        .select(x => String(x).to_num())
        .where(x => x.is_some() && x.value_or(0) > 0)
        .select(x => x.value_or(0))
    
    vector<Stats> stats = {}
    stats.push_back(Stats(filtered, 0, "Rust"))
    stats.push_back(Stats(filtered, 6, "Self"))
    return stats
;

fn get_stat_bars int stat_a, int stat_b, string header => HorizontalLayout*
    let max = stat_a > stat_b ? stat_a : stat_b
    let bars = new HorizontalLayout()

    let bar_a = new VerticalLayout()
    let a_fill = new IContainer()
    let a = new IContainer(Fill::Static, Vector(0, ((double)stat_a/(double)max * (LINES - 2)) + 1))
    a->SetColor(-1)
    a->SetLabel($"{header}: {stat_a}")
    bar_a->add(a_fill)
    bar_a->add(a)
    bars->add(bar_a)

    let bar_b = new VerticalLayout()
    let b_fill = new IContainer()
    let b = new IContainer(Fill::Static, Vector(0, ((double)stat_b/(double)max * (LINES - 2)) + 1))
    b->SetColor(-2)
    b->SetLabel($"{header}:{stat_b}")
    bar_b->add(b_fill)
    bar_b->add(b)
    bars->add(bar_b)
    
    return bars
;

fn draw vector<Stats> stats =>
    let max = stats[0].max_num()
    if stats[1].max_num() > max do max = stats[1].max_num()
    let main = MainContainer()
    main.SetLabel($"{max}")
    let horizontal = HorizontalLayout()

    let files = get_stat_bars(stats[0].files, stats[1].files, "Files")
    horizontal.add(files)
    let lines = get_stat_bars(stats[0].lines, stats[1].lines, "Lines")
    horizontal.add(lines)
    let words = get_stat_bars(stats[0].words, stats[1].words, "Words")
    horizontal.add(words)
    let chars = get_stat_bars(stats[0].chars, stats[1].chars, "Chars")
    horizontal.add(chars)
    let nalfa = get_stat_bars(stats[0].nalfa, stats[1].nalfa, "Non Alpha")
    horizontal.add(nalfa)
    let maxle = get_stat_bars(stats[0].maxle, stats[1].maxle, "Max Len")
    horizontal.add(maxle)

    main.add(&horizontal)
    main.update()
    main.draw()
;

fn main =>
    Ncurses::init()
    draw(get_stats())
    while Ncurses::key() != 'q' do continue
    Ncurses::stop()
;
