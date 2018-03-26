import "dart:html" as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:dryice/dryice.dart' as di;

import 'package:mdl/mdl.dart';

@MdlComponentModel 
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

    registerMdl();

    final MaterialApplication application = await componentFactory().
        rootContext(Application).run(enableVisualDebugging: true);

    application.run();
}


void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}