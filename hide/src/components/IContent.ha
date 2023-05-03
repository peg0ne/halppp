get => highlighter/[Syntax, Highlighter]
class IContent
protected
    Option<Highlighter*> _highlighter = None<Highlighter*>()
    List<string> _text = List<string>()
    IContainer *_origin
pub
    fn draw => 
        _origin->SetContent(_text)
        _origin->draw()
    ;
    fn origin => IContainer* doremi _origin
;