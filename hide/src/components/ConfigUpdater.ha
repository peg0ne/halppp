get => ConfigUpdaterContent

named => ConfigUpdater
    fn get_new_word string word, IContainer* container => string
        String new_word = String(word)
        loop
            let key = Ncurses::key()
            if key == '\n' do break
            switch key
            case 27 doremi "%<command abort>%"
            case '\b'
            case 127
            case KEY_BACKSPACE dobr new_word.remove_back(1)
            default
                if key == ' ' dobr new_word = new_word + key
                if !isgraph(key) do break
                new_word = new_word + key
                break
            ;
            container->SetLabel(new_word.to_string())
            container->draw()
        ;
        return new_word.to_string()
    ;

    fn add_word string file_type =>
        let word_container = IContainer(Fill::Static, Vector(0,1))
        let container = ConfigUpdaterContent("Add Word")
        container.add(&word_container)
        container.draw()

        let new_word = ConfigUpdater::get_new_word("", &word_container)
        if new_word == "%<command abort>%" dore container.destruct()
        let home = home_env().value_or(".")
        let path = $"{home}/.config/hide/{file_type}.json"
        let config = load_json(path)
        select wl from config.try_get("wordlist") do wl->add<string>(new_word)
        write_json(path, config)
        config.destruct()
        container.destruct()
    ;
    
    fn edit_word string word, string file_type =>
        let word_container = IContainer(Fill::Static, Vector(0,1))
        word_container.SetLabel(word)
        let container = ConfigUpdaterContent($"Edit Word: {word}")
        container.add(&word_container)
        container.draw()

        let new_word = ConfigUpdater::get_new_word(word, &word_container)
        if new_word == "%<command abort>%" dore container.destruct()
        let home = home_env().value_or(".")
        let path = $"{home}/.config/hide/{file_type}.json"
        let config = load_json(path)
        vector<Json*> keep = {};
        select wl from config.try_get("wordlist")
            for i until wl->size()
                select w from wl->try_get(i)
                    if w->value_or((string)"") != word doco keep.push_back(w)
                    keep.push_back(new Json("", new_word))
                    w->destruct()
                ;
            ;
            while wl->size() > 0 do wl->pop()
            foreach w in keep do wl->add(w)
        ;
        write_json(path, config)
        config.destruct()
        container.destruct()
    ;
;
