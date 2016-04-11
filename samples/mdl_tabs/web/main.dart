import 'dart:html' as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

main() async {
    final Logger _logger = new Logger('mdl_tabs_sample.main');

    configLogging();

    registerMdl();

    await componentFactory().run();

    final MaterialSnackbar snackbar = new MaterialSnackbar();
    final MaterialTabs tabs = MaterialTabs.widget(dom.querySelector(".mdl-tabs"));

    _logger.info("${tabs.activePanel} is active!");
    snackbar("${tabs.activePanel} is active!").show();

    tabs.onChange.listen((final MaterialTabsChangedEvent event) {
        _logger.info("${event.targetID} is active!");

        snackbar("${event.targetID} is active!").show();
    });

}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}