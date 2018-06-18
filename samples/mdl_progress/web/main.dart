import "dart:html" as dom;

import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'main.reflectable.dart';

main() async {
    final Logger _logger = new Logger('example.progress.main');
    
    configLogging();
    initializeReflectable();

    registerMdl();

    await componentFactory().run();

    _logger.info("All components upgraded");

    // 1
    MaterialProgress.widget(dom.querySelector("#p1")).progress = 44;
    MaterialProgressVertical.widget(dom.querySelector("#p1v")).progress = 44;
    MaterialProgressVertical.widget(dom.querySelector("#p11v")).progress = 44;

    // 2
    MaterialProgress.widget(dom.querySelector("#p3")).progress = 33;
    MaterialProgress.widget(dom.querySelector("#p3")).buffer = 87;

    MaterialProgressVertical.widget(dom.querySelector("#p3v")).progress = 33;
    MaterialProgressVertical.widget(dom.querySelector("#p3v")).buffer = 87;

    (dom.querySelector("#slider") as dom.RangeInputElement).onInput.listen((final dom.Event event) {
        final int value = int.parse((event.target as dom.RangeInputElement).value);

        final component = MaterialProgress.widget(dom.querySelector("#p1"))
            ..progress = value
            ..classes.toggle("test");

        MaterialProgress.widget(dom.querySelector("#p3")).progress = value;

        final component2 = MaterialProgressVertical.widget(dom.querySelector("#p1v"))
            ..progress = value
            ..classes.toggle("test");

        MaterialProgressVertical.widget(dom.querySelector("#p11v")).progress = value;
        MaterialProgressVertical.widget(dom.querySelector("#p3v")).progress = value;

        _logger.info("Value1: ${component.progress}");
        _logger.info("Value2: ${component2.progress}");
    });
}