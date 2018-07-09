import "dart:async";

import 'package:console_log_handler/console_log_handler.dart';
import 'package:dryice/dryice.dart';
import 'package:reflected_mustache/mustache.dart';

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlobservable.dart';

import 'main.reflectable.dart';

@Model @mustache
class Language {
    final String name;
    final String type;
    Language(this.name, this.type);
}

@Model @mustache
class Name {
    final String first;
    final String last;
    Name(this.first, this.last);

    @override
    String toString() {
        return "$first $last";
    }
}

@mustache
class Natural extends Language {
    Natural(final String name) : super(name,"natural");
}

@Model @inject @mustache
class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    final ObservableList<Language>  languages = new ObservableList<Language>();
    final ObservableProperty<String> time = new ObservableProperty<String>("",interval: new Duration(seconds: 1));
    final ObservableProperty<String> records = new ObservableProperty<String>("");
    final ObservableProperty<Name>  nameObject = new ObservableProperty<Name>(null);
    final ObservableProperty<bool>   isNameNull = new ObservableProperty<bool>(true);

    final List<Name> _names = new List<Name>();

    Application() {
        records.observes(() => (languages.isNotEmpty ? languages.length.toString() : "<empty>"));
        time.observes(() => _getTime());

        languages.add(new Natural("English"));
        languages.add(new Natural("German"));
        languages.add(new Natural("Italian"));
        languages.add(new Natural("French"));
        languages.add(new Natural("Spanish"));

        _names.add(new Name("Bill","Gates"));
        _names.add(new Name("Steven","Jobs"));
        _names.add(new Name("Larry","Page"));
        _names.add(null);

    }

    @override
    void run() {

        new Timer(new Duration(seconds: 2),() {
            for(int index = 0;index < 10;index++) {
                languages.add(new Natural("Sample - $index"));
            }
        });

        int counter = 0;
        new Timer.periodic(new Duration(milliseconds: 1000),(final Timer timer) {
            nameObject.value = _names[counter % 4]; // 0,1,2,...
            isNameNull.value = nameObject.value == null;
            counter++;
        });
    }

    void remove(final String language) {
        _logger.info("Remove $language clicked!!!!!");

        final Language lang = languages.firstWhere(
                (final Language check) {

                    final bool result = (check.name.toLowerCase() == language.toLowerCase());
                    _logger.fine("Check: ${check.name} -> $language, Result: $result");

                    return result;
                });

        if(language == "German") {

            int index = languages.indexOf(lang);
            languages[index] = new Natural("Austrian");

        } else {
            languages.remove(lang);
        }
    }

    //- private -----------------------------------------------------------------------------------

    String _getTime() {
      final DateTime now = new DateTime.now();
      return "${now.hour.toString().padLeft(2,"0")}:${now.minute.toString().padLeft(2,"0")}:${now.second.toString().padLeft(2,"0")}";
    }
}

main() {
    // final Logger _logger = new Logger('main.MaterialRepeat');

    configLogging();
    initializeReflectable();

    registerMdl();

    componentFactory().rootContext(Application).run(enableVisualDebugging: true)
        .then((final MaterialApplication application) {
            application.run();
    });

}
              