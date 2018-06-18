import "dart:html" as dom;

import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'main.reflectable.dart';

main() async {
    configLogging();
    initializeReflectable();

    registerMdl();

    await componentFactory().run();
    MaterialRadio.widget(dom.querySelector("#wifi2")).disable();

    MaterialButton.widget(dom.querySelector("#show-wifi-value")).onClick.listen((_) {

        final MaterialRadioGroup group = MaterialRadioGroup.widget(dom.querySelector("#wifi"));
        final MaterialAlertDialog alertDialog = new MaterialAlertDialog();

        alertDialog("Value is: ${group.value}").show();
    });
}

