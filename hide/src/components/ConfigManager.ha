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
    ConfigManager =>
        _origin = new MainContainer(Vector(9,3))
        _origin->SetColor(-3)
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
    ;
pub
    fn show => Command
        loop
            draw()
            switch _state
                case ConfigState::Selector
                    select selected from _selector.run()
                        _state = ConfigState::Internal
                        _current = selected
                    ;
                    if Ncurses::key() == 27 doremi Command::Nop
                    break
                default
                    _selector.draw()
                    if Ncurses::key() == 27 do _state = ConfigState::Selector
                    break
            ;
        ;
        return Command::Nop
    ;
;
