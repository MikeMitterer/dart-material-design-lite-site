import 'dart:html' as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import "package:mdl/mdldialog.dart";

main() async {
    // final Logger _logger = new Logger('mdlx_form.main');

    configLogging();

    registerMdl();

    await componentFactory().run();

    final MaterialFormComponent form = MaterialFormComponent.widget(dom.querySelector("#multicontrol"));
    form.onChange.listen((final FormChangedEvent event) {
        final MaterialNotification notification = new MaterialNotification();
        notification("${event.currentTarget.runtimeType} changed!",type: NotificationType.INFO).show();
        //_logger.info("${event.currentTarget.runtimeType} changed!");
    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}