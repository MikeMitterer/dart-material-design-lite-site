import 'dart:html' as dom;
import 'dart:async';

import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'package:dryice/dryice.dart';

import 'main.reflectable.dart';

@inject
class Application extends MaterialApplication {
    final Logger _logger = new Logger('mdl_button.main');

    @override
    void run() {
        MaterialButton.widget(dom.querySelector("#with-event")).onClick.listen((_) {
            _logger.info("Clicked!");
        });
    }
}

Future main() async {
    configLogging(show: Level.INFO);
    initializeReflectable();
    
    registerMdl();

    final Application app = await componentFactory().rootContext(Application).run();
    app.run();
}

