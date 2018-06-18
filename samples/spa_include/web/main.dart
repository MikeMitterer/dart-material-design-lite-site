import "dart:html" as dom;

import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'main.reflectable.dart';

import 'package:prettify/prettify.dart';

main() {
    final Logger _logger = new Logger('main.MaterialInclude');

    configLogging();
    initializeReflectable();

    registerMdl();

    componentFactory().run().then((_) {
        final MaterialInclude include = MaterialInclude.widget(dom.querySelector("#main"));

        include.onLoadEnd.listen((_) {

            prettyPrint();
            _logger.info("Loaded");
        });
    });
}
