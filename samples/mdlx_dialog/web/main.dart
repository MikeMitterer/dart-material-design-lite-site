import "dart:html" as dom;
import 'package:dice/dice.dart' as di;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import "package:mdl/mdldialog.dart";

import "package:mdl_dialog_sample/customdialog1.dart";
import "package:mdl_dialog_sample/customdialog2.dart";

// For Date- and TimePicker
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:l10n/l10n.dart';

/// Simple Translation-Table for testing (see L10N for more)
final L10NTranslate translate = new L10NTranslate.withTranslations( {
    "de": {
        "Cancel": "Abbrechen"
    },

    "en": {
        "Must not be empty": ""
    }
});

@di.injectable
class Application extends MaterialApplication {
    final Logger _logger = new Logger('dialog.Application');

    int _mangoCounter = 0;

    final MaterialButton btnAlertDialog;
    final MaterialButton btnConfirmDialog;

    final MaterialButton btnCustomDialog1;
    final MaterialButton btnCustomDialog2;

    final MaterialButton _btnShowTimePicker;
    final MaterialButton _btnShowDatePicker;

    final MaterialButton _btnClear;

    final MaterialTextfield _dateInput;
    final MaterialTextfield _timeInput;

    final MaterialAlertDialog alertDialog;
    final MdlConfirmDialog confirmDialog;
    final CustomDialog1 customDialog1;
    final CustomDialog2 customDialog2;

    final MaterialTimePicker timePicker = new MaterialTimePicker();
    final MaterialDatePicker datePicker = new MaterialDatePicker();

    Application() :

        btnAlertDialog = MaterialButton.widget(dom.querySelector("#alertdialog")),
        btnConfirmDialog = MaterialButton.widget(dom.querySelector("#confirmdialog")),

        btnCustomDialog1 = MaterialButton.widget(dom.querySelector("#customdialog1")),
        btnCustomDialog2 = MaterialButton.widget(dom.querySelector("#customdialog2")),

        _dateInput = MaterialTextfield.widget(dom.querySelector("#date_input")),
        _timeInput = MaterialTextfield.widget(dom.querySelector("#time_input")),

        _btnShowDatePicker = MaterialButton.widget(dom.querySelector("#date-picker")),
        _btnShowTimePicker = MaterialButton.widget(dom.querySelector("#time-picker")),

        _btnClear = MaterialButton.widget(dom.querySelector("#clear")),

        alertDialog = new MaterialAlertDialog(),
        confirmDialog = new MdlConfirmDialog(),
        customDialog1 = new CustomDialog1(),
        customDialog2 = new CustomDialog2() {

        _bindEvents();
    }

    @override run() {
    }

    //- private --------------------------------------------------------------------------------------------------------

    void _bindEvents() {

        btnAlertDialog.onClick.listen((_) {
            _logger.info("Click on AlertButton");
            alertDialog("Testmessage").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });
        });

        btnConfirmDialog.onClick.listen((_) {
            _logger.info("Click on ConfirmButton");
            confirmDialog("Testmessage").show().then((final MdlDialogStatus status) {
                _logger.info(status);
            });
        });

        btnCustomDialog1.onClick.listen((_) {
            _logger.info("Click on ConfirmButton");
            customDialog1(title: "Mango #${_mangoCounter} (Fruit)",
                yesButton: "I buy it!", noButton: "Not now").show().then((final MdlDialogStatus status) {

                _logger.info(status);
                _mangoCounter++;
            });
        });

        btnCustomDialog2.onClick.listen((_) {
            _logger.info("Click on ConfirmButton");
            customDialog2(title: "Form-Sample").show().then((final MdlDialogStatus status) {

                _logger.info(status);
                if(status == MdlDialogStatus.OK) {
                    _logger.info("You entered: ${customDialog2.name.value}");
                }
            });
        });

        _btnShowDatePicker.onClick.listen((_) {

            // Not necessary but makes sense if you reuse the dialog
            datePicker.dateTime = new DateTime.now();

            datePicker.show().then((final MdlDialogStatus status) {
                if(status == MdlDialogStatus.OK) {
                    final MaterialSnackbar snackbar = new MaterialSnackbar();
                    final String date = new DateFormat.yMd().format(datePicker.dateTime);
                    final String time = new DateFormat("HH:mm:ss").format(timePicker.dateTime);

                    snackbar(date).show();
                    _logger.info("Seleted date: ${date} / ${time}");
                }
            });
        });

        _btnShowTimePicker.onClick.listen((_) {

            // Not necessary but makes sense if you reuse the dialog
            timePicker.dateTime = (new DateTime.now().add(new Duration(days: 1)));

            timePicker.show().then((final MdlDialogStatus status) {
                if(status == MdlDialogStatus.OK) {
                    final MaterialSnackbar snackbar = new MaterialSnackbar();
                    final String date = new DateFormat("dd.MM.yyyy").format(timePicker.dateTime);
                    final String time = new DateFormat.Hm().format(timePicker.dateTime);

                    snackbar(time).show();
                    _logger.info("Seleted time: ${time} / ${date} (Today + one additional day)");
                }
            });
        });

        _dateInput.onClick.listen((_) {
            // Not necessary but makes sense if you reuse the dialog
            datePicker.dateTime = new DateTime.now();

            datePicker.show().then((final MdlDialogStatus status) {
                if(status == MdlDialogStatus.OK) {
                    final String date = new DateFormat("dd.MM.yyyy").format(datePicker.dateTime);
                    final String time = new DateFormat("HH:mm:ss").format(timePicker.dateTime);

                    _dateInput.value = date;
                    
                    _logger.info("Seleted date: ${date} / ${time}");
                }
            });
        });

        _timeInput.onClick.listen((_) {
            // Not necessary but makes sense if you reuse the dialog
            timePicker.dateTime = new DateTime.now();

            timePicker.show().then((final MdlDialogStatus status) {
                if(status == MdlDialogStatus.OK) {
                    final String time = new DateFormat("HH:mm").format(timePicker.dateTime);

                    _timeInput.value = time;
                    _logger.info("Seleted time: ${time}");
                }
            });

        });

        _btnClear.onClick.listen((final dom.Event event) {
            event.preventDefault();
            
            _dateInput.value = "";
            _timeInput.value = "";
        });
    }
}

main() async {
    final Logger _logger = new Logger('dialog.main');
    configLogging();

    // Determine your locale automatically:
    final String locale = await findSystemLocale();
    translate.locale = Intl.shortLocale(locale);

    Intl.defaultLocale = locale;
    initializeDateFormatting(locale);

    registerMdl();

    _logger.info("Locale: $locale / (Short) ${Intl.shortLocale(locale)}");

    await componentFactory()
        .rootContext(Application)
        .addModule(new SampleModule())
        .run();
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