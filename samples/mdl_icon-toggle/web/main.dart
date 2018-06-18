import "dart:html" as dom;
import "dart:async";

import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'main.reflectable.dart';

main() async {
    configLogging();
    initializeReflectable();

    registerMdl();

    await componentFactory().run();

    final MaterialIconToggle toggle = MaterialIconToggle.widget(dom.querySelector("#public-checkbox-1"));
    new Timer.periodic(new Duration(milliseconds: 500), (final Timer timer) {
        toggle.checked = !toggle.checked;
    });
}

