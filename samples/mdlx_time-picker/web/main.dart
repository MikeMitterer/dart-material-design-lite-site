import "dart:html" as dom;
import 'package:dice/dice.dart' as di;
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import "package:mdl/mdldialog.dart";

@di.injectable
class Application extends MaterialApplication {
    final Logger _logger = new Logger('dialog.Application');

    final MaterialButton _btnShowTimePicker;

    final MaterialTimePicker timePicker = new MaterialTimePicker();

    Application() :
        _btnShowTimePicker = MaterialButton.widget(dom.querySelector("#time-picker")) {

        _bindEvents();
    }

    @override run() {
    }

    //- private --------------------------------------------------------------------------------------------------------

    void _bindEvents() {
        _btnShowTimePicker.onClick.listen((_) {

            // Not necessary but makes sense if you reuse the dialog
            timePicker.dateTime = new DateTime.now();

            timePicker.show().then((final MdlDialogStatus status) {
                if(status == MdlDialogStatus.OK) {
                    final MaterialSnackbar snackbar = new MaterialSnackbar();
                    final String date = new DateFormat.Hm().format(timePicker.dateTime);

                    snackbar(date).show();
                    _logger.info("Seleted date: ${date}");
                }
            });
        });
    }
}

main() async {
    configLogging();

    final Logger _logger = new Logger('dialog.main');

    registerMdl();

    // Determine your locale automatically:
    final String locale = await findSystemLocale();

    Intl.defaultLocale = locale;
    initializeDateFormatting(locale);
    
    _logger.info("Locale: $locale");

    //translate.locale = Intl.shortLocale(locale);


    await componentFactory().rootContext(Application).run();
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}