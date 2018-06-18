import 'dart:html' as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

import 'main.reflectable.dart';

main() {
    configLogging();
    initializeReflectable();

    registerMdl();

    componentFactory().run().then((_) {
        final MaterialDivDataTable table = MaterialDivDataTable.widget(dom.querySelector(".mdl-data-tableex"));
        final MaterialLabelfield label = MaterialLabelfield.widget(dom.querySelector("#selection"));

        table.onRowClick.listen((final DataTableRowClickedEvent event) {
            final dom.DivElement div = event.row.element;
            final dom.HtmlElement child = div.querySelector(".material");

            label.value = child.text.replaceAll(new RegExp(r"\s{2,}"),"");
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