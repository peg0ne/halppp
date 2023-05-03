get => IContainer
class GroupedContainer => IContainer
protected
    GroupedContainer =>
        _type = ContainerType::Grouped
    ;
pub
    fn draw =>
        if !is_active do return
        ((IContainer*)this)->draw()
        foreach c in _containers do draw_container_impl(c)
    ;
;