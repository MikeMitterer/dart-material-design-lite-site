import "dart:html" as dom;

import 'package:console_log_handler/console_log_handler.dart';
import 'package:dryice/dryice.dart';

import 'package:mdl/mdl.dart';
import 'main.reflectable.dart';

@inject
class Application extends MaterialApplication {
    // final Logger _logger = new Logger('main.Application');

    Application() {
    }

    @override
    void run() {
        final MaterialButton button = MaterialButton.widget(dom.querySelector(".mdl-button"));
        button.onClick.listen((final dom.Event event) {
            event.preventDefault();

            final MaterialLabelfield label = MaterialLabelfield.widget(dom.querySelector("#search_engine"));
            label.label = "Another search engine";
            label.value = "Yahoo";

            final MaterialLabelfield label2 = MaterialLabelfield.widget(dom.querySelector("#interruption"));
            label2.label = "Do not disturbe!";

            final MaterialLabelfield label3 = MaterialLabelfield.widget(dom.querySelector("#ringtone"));
            label3.value = "I am <strong>escaped</strong>";
        });
    }
}

main() async {
    // final Logger _logger = new Logger('main.Labelfield');

    configLogging();
    initializeReflectable();

    registerMdl();

    final MaterialApplication application = await componentFactory().
        rootContext(Application).run(enableVisualDebugging: true);

    application.run();
}
