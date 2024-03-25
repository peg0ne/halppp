get => ../lib/[linq, stringextensions]

fn main =>
    let range = linq::range(10000).as_vec()
    let filtered = map<int>(range)
        .where(x => x > 50)
        .select(x => $"{x}")
        .where(x => x.size() > 2)
        .select(x => String(x))
        .where(x => x.starts_with("1"))
        .where(x => x.ends_with("1"))
        .select(x => x.to_num())
        .where(x => x.is_some())
        .select(x => x.value_or(0))
;
