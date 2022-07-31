get => highlighter/[Syntax, Highlighter]
class IContent
protected
    Option<Highlighter> _highlighter = None<Highlighter>()
    List<string> _text = List<string>()
    IContainer *_origin
    Ncurses *n
pub
    fn draw => 
        _origin->SetContent(_text)
        _origin->draw(n)
    ;
    fn origin => IContainer* doremi _origin
;
