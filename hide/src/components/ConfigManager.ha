get => Selector

enum ConfigState
    Selector,
    Internal,
;

class ConfigManager => IContent
    Syntax _current = Syntax()
    ConfigState _state = ConfigState::Selector
    Dictionary<string, Syntax> _syntaxes = Dictionary<string, Syntax>()
    Selector<Syntax> _selector = Selector<Syntax>()
    HorizontalLayout _config = HorizontalLayout()
    IContainer _selector_spacer = IContainer(Fill::Static)
    VerticalLayout _content = VerticalLayout(Fill::Flex)
    HorizontalLayout _header_layout = HorizontalLayout(Fill::Static, Vector(0,1))
    IContainer _header = IContainer(Fill::Static)
    ConfigManager =>
        _origin = new MainContainer(Vector(9,3))
        _origin->SetColor(-3)
        _origin->add(&_config)
        _config.add(&_selector_spacer)
        _config.add(&_content)
        _content.add(&_header_layout)
        _header_layout.add(new IContainer())
        _header_layout.add(&_header)
        _header_layout.add(new IContainer())
        reload_configs()
    ;
    fn reload_configs =>
        let home = env("HOME").value_or(".")
        let configs = list_reg_files($"{home}/.config/hide")
        foreach config_file in configs
            let config = load_json($"{home}/.config/hide/{config_file}")
            let syntax = Syntax(config)
            _syntaxes.add(syntax.name(), syntax)
            config.destruct()
        ;
        _selector.destruct()
        _selector = Selector<Syntax>(_syntaxes, _origin->Offset(), _origin->Size())
        let size = _selector.origin()->Size()
        _selector_spacer.SetSize(size.x + 2, 0)
    ;
    fn draw => do ((MainContainer*)_origin)->draw()
pub
    fn show => Command
        loop
            draw()
            switch _state
                case ConfigState::Selector
                    select selected from _selector.run()
                        _state = ConfigState::Internal
                        _current = selected
                        _header.SetLabel(_current.name())
                        _header.SetSize(_current.name().size(), 0)
                        break
                    ;
                    return Command::Nop
                default
                    _selector.draw()
                    if Ncurses::key() == 27 do _state = ConfigState::Selector
                    break
            ;
        ;
        return Command::Nop
    ;
;
