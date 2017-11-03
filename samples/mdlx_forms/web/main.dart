import 'dart:html' as dom;

import 'package:l10n/l10n.dart';
import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:dice/dice.dart' as di;

// For Date- and TimePicker
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:l10n/l10n.dart';

import 'package:mdl/mdl.dart';
import "package:mdl/mdldialog.dart";

import 'package:mdl_forms_sample/dialog.dart';

/// Simple Translation-Table for testing (see L10N for more)
final L10NTranslate translate = new L10NTranslate.withTranslations( {
    "de": {
        "Cancel":
            "Abbrechen",
        "Timeframe":
            "Zeitraum",
        "Begin:" :
            "Start:",
        "End:" :
            "Ende:",
        "Clear" :
            "Löschen",
        'Form checks if "Begin" is before "End"' :
            'Formular überprüft ob "Start" vor dem "Ende" liegt'
    },

    "en": {
        "Must not be empty": ""
    }
});

@di.injectable
class Application extends MaterialApplication {
    final Logger _logger = new Logger('form_sample.Application');

    @override run() {
        _bindEvents();
    }

    void _bindEvents() {
        final form = MaterialFormComponent.widget(dom.querySelector("#multicontrol"));

        form.onChange.listen((final FormChangedEvent event) {
            final MaterialNotification notification = new MaterialNotification();
            notification("${event.currentTarget.runtimeType} changed!",type: NotificationType.INFO).show();
            //_logger.info("${event.currentTarget.runtimeType} changed!");
        });

        final button = MaterialButton.widget(dom.querySelector("#open-dialog"));
        button.onClick.listen((_) {
            final dialog = new TimeFrameDialog();
            dialog.show().then((final MdlDialogStatus status) {
                if(status == MdlDialogStatus.OK) {
                    final message = "${new DateFormat("dd.MM.yyyy HH:mm").format(dialog.from)}"
                                    " - "
                                    "${new DateFormat("dd.MM.yyyy HH:mm").format(dialog.to)}";

                    final MaterialNotification notification = new MaterialNotification();
                    notification(message,type: NotificationType.INFO).show();
                }
            });
        });
    }
}

main() async {
    // final Logger _logger = new Logger('mdlx_form.main');

    configLogging();

    // Determine your locale automatically:
    final String locale = await findSystemLocale();
    translate.locale = Intl.shortLocale(locale);

    Intl.defaultLocale = locale;
    initializeDateFormatting(locale);

    registerMdl();

    final Application app = await componentFactory()
        .rootContext(Application)
        .addModule(new SampleModule())
        .run();

    app.run();
}

/**
 * Demo Module
 */
class SampleModule extends di.Module {
    configure() {
        // Configure Translator
        bind(Translator).toInstance(translate);
    }
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}