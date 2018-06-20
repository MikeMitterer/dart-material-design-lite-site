import 'package:console_log_handler/console_log_handler.dart';

import 'package:dryice/dryice.dart';
import 'package:mustache/mustache.dart';

import 'package:mdl/mdl.dart';
import 'main.reflectable.dart';

@Model @mustache
class Language {
    final String name;
    final String type;

    Language(this.name, this.type);
}

@Model @mustache
class Programming extends Language {
    Programming(final String name) : super(name,"programming");
}

@Model @mustache
class Natural extends Language {
    Natural(final String name) : super(name,"natural");
}

@inject
class Application extends MaterialApplication {
    // final _logger = new Logger('dnd.Application');

    final languages = new ObservableList<Language>();
    final natural = new ObservableList<Language>();
    final programming = new ObservableList<Language>();

    Application() {
        languages.add(new Natural("English"));
        languages.add(new Natural("German"));
        languages.add(new Natural("Italian"));
        languages.add(new Natural("French"));
        languages.add(new Natural("Spanish"));

        languages.add(new Programming("CPP"));
        languages.add(new Programming("Dart"));
        languages.add(new Programming("Java"));
    }

    @override
    void run() {

    }

    void addToProgrammingLanguages(final Language language) {
        if(language.type == "programming") {
            if(!programming.contains(language)) {
                programming.add(language);
            }
        }
    }

    void addToNaturalLanguages(final Language language) {
        if(language.type == "natural") {
            if(!natural.contains(language)) {
                natural.add(language);
            }
        }
    }

    void moveToTrash(final Language language) {
        if(language.type == "programming" && programming.contains(language)) {
            programming.remove(language);

        } else if(language.type == "natural" && natural.contains(language)) {
            natural.remove(language);
        }
    }
}

main() async {
    configLogging(show: Level.FINER);
    initializeReflectable();

    registerMdl();
    registerMdlDND();

    final application = await componentFactory().rootContext(Application).run();
    application.run();
}
