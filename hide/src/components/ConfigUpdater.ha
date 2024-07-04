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

    fn edit_custom SyntaxCustom custom, int pos, string file_type =>
        let color_container = IContainer(Fill::Static, Vector(0,1)) 
        color_container.SetLabel($"{custom.color}")
        let capture_container = IContainer(Fill::Static, Vector(0,1)) 
        capture_container.SetLabel($"{custom.capture}")
        let bold_container = IContainer(Fill::Static, Vector(0,1)) 
        bold_container.SetLabel($"{custom.bold}")
        let dim_container = IContainer(Fill::Static, Vector(0,1)) 
        dim_container.SetLabel($"{custom.dim}")
        let regex_container = IContainer(Fill::Static, Vector(0,1)) 
        regex_container.SetLabel($"{custom.regex_str}")

        let container = ConfigUpdaterContent($"Edit Custom")
        container.add(&color_container)
        container.add(&capture_container)
        container.add(&bold_container)
        container.add(&dim_container)
        container.add(&regex_container)
        container.draw()

        let color = ConfigUpdater::get_new_word($"{custom.color}", &color_container)
        if color == "%<command abort>%" dore container.destruct()
        custom.color = (short)String(color).to_num().value_or(0)
        
        let capture = ConfigUpdater::get_new_word($"{custom.capture}", &capture_container)
        if capture == "%<command abort>%" dore container.destruct()
        custom.capture = (int)String(capture).to_num().value_or(0)

        let bold = ConfigUpdater::get_new_word($"{custom.bold}", &bold_container)
        if bold == "%<command abort>%" dore container.destruct()
        custom.bold = (int)String(bold).to_num().value_or(0) == 1

        let dim = ConfigUpdater::get_new_word($"{custom.dim}", &dim_container)
        if dim == "%<command abort>%" dore container.destruct()
        custom.dim = (int)String(bold).to_num().value_or(0) == 1

        let regex_s = ConfigUpdater::get_new_word($"{custom.regex_str}", &regex_container)
        if regex_s == "%<command abort>%" dore container.destruct()
        custom.regex_str = regex_s

        let new_custom = new Json()
        new_custom->add(new Json("color", (int)custom.color))
        new_custom->add(new Json("capture", custom.capture))
        new_custom->add(new Json("bold", (bool)custom.bold))
        new_custom->add(new Json("dim", (bool)custom.dim))
        new_custom->add(new Json("expr", custom.regex_str))

        let home = home_env().value_or(".")
        let path = $"{home}/.config/hide/{file_type}.json"
        let config = load_json(path)
        vector<Json*> keep = {}
        select customs from config.try_get("custom")
            for i until customs->size()
                select custom from customs->try_get(i)
                    if i != pos doco keep.push_back(custom)
                    keep.push_back(new_custom)
                    custom->destruct()
                ;
            ;
            while customs->size() > 0 do customs->pop()
            foreach c in keep do customs->add(c)
        ;
        write_json(path, config)
        config.destruct()
        container.destruct()
    ;
;
