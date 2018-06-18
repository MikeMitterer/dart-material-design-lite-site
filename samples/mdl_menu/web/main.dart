import "dart:html" as dom;
import "dart:async";

import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'main.reflectable.dart';

main() async {
    const int TIMEOUT_IN_SECS = 5;

    configLogging();
    initializeReflectable();

    registerMdl();

    await componentFactory().run();

    final dom.HtmlElement element = dom.querySelector(".mdl-menu");
    final MaterialMenu menu1 = MaterialMenu.widget(element);

    void _showMessage(final int secsToClose) {
        final dom.DivElement message = dom.querySelector("#message");
        message.text = "Menu closes in ${secsToClose} seconds...";
        if(secsToClose <= 0) {
            message.text = "Closed!";
        }
    }

    menu1.show();
    _showMessage(TIMEOUT_IN_SECS);
    int tick = 0;
    new Timer.periodic(new Duration(milliseconds: 1000) , (final Timer timer) {

        _showMessage(TIMEOUT_IN_SECS - tick - 1);
        if(tick >= TIMEOUT_IN_SECS - 1) {
            timer.cancel();
            menu1.hide();
        }
        tick++;
    });
}
