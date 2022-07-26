class IContent
protected
    vector<string> _text = {}
    IContainer *_origin
    Ncurses *n
pub
    fn draw => 
        _origin->SetContent(_text)
        _origin->draw(n)
    ;
    fn origin => IContainer* doremi _origin
;
