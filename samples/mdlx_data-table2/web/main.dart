import 'dart:html' as dom;

import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

import 'main.reflectable.dart';

main() async {
    configLogging();
    initializeReflectable();

    registerMdl();

    await componentFactory().run();
    
    final MaterialDivDataTable table = MaterialDivDataTable.widget(dom.querySelector(".mdl-data-tableex"));
    final MaterialLabelfield label = MaterialLabelfield.widget(dom.querySelector("#selection"));

    table.onRowClick.listen((final DataTableRowClickedEvent event) {
        final dom.DivElement div = event.row.element;
        final dom.HtmlElement child = div.querySelector(".material");

        label.value = child.text.replaceAll(new RegExp(r"\s{2,}"),"");
    });
}
