import 'dart:html' as dom;

import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'main.reflectable.dart';

main() async {
    configLogging();
    initializeReflectable();

    registerMdl();

    await componentFactory().run();

    final MaterialSlider slider2 = MaterialSlider.widget(dom.querySelector("#slider2"));
    final MaterialSlider slider4 = MaterialSlider.widget(dom.querySelector("#slider4"));

    slider2.hub.onChange.listen((_) {
        slider4.value = slider2.value;
    });

}

