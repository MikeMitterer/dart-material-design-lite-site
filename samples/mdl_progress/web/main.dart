import "dart:html" as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

main() {
    final Logger _logger = new Logger('example.progress.main');
    configLogging();

    registerMdl();

    componentFactory().run().then((_) {
        _logger.info("All components upgraded");

        // 1
        MaterialProgress.widget(dom.querySelector("#p1")).progress = 44;
        MaterialProgressVertical.widget(dom.querySelector("#p1v")).progress = 44;

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

            MaterialProgressVertical.widget(dom.querySelector("#p3v")).progress = value;

            _logger.info("Value1: ${component.progress}");
            _logger.info("Value2: ${component2.progress}");
        });

    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}