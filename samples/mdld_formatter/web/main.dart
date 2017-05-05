import 'dart:html' as dom;

import "dart:async";
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:dice/dice.dart' as di;

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlobservable.dart';

@MdlComponentModel
class Application extends MaterialApplication {
    // final Logger _logger = new Logger('main.Application');

    final ObservableProperty<double> pi = new ObservableProperty<double>(3.14159265359);
    final ObservableProperty<String> name = new ObservableProperty<String>("Mike");
    final ObservableProperty<bool> checkStatus = new ObservableProperty<bool>(false);

    final List<String> xmen;
    
    Application() : xmen = ['Angel/Archangel', 'Apocalypse', 'Bishop', 'Beast','Caliban','Colossus',
                            'Cyclops','Firestar','Emma Frost','Gambit','High Evolutionary','Dark Phoenix',
                            'Marvel Girl','Iceman','Juggernaut','Magneto','Minos','Mr. Sinister','Mystique',
                            'Nightcrawler','Professor X','Pyro','Psylocke','Rogue','Sabretooth','Shadowcat','Storm',
                            'Talker','Wolverine','X-23' ];

    @override
    void run() {
        final Math.Random rnd = new Math.Random();
        new Timer.periodic(new Duration(milliseconds: 500),(final Timer timer) {
            final int index = rnd.nextInt(xmen.length);
            name.value = xmen[index];

            checkStatus.value = index % 2;

            _labelfield1.value = xmen[index];
            _labelfield2.value = xmen[index];
            _textfield.value = xmen[index];
            _labelfield3.value = (index * pi.value).toString();
            _badge.value = xmen[index].substring(0,1);
            _button.value = xmen[index];

            _checkbox.label = "Name #$index";;

            _labelfield4.label = "Name #$index";
            _labelfield4.value = xmen[index];

            _radioWifi1.label = "wifi I #$index";
            _radioWifi1.label = "wifi II #$index";

            _switch.label = "Name #$index";
        });
    }

    //- private -----------------------------------------------------------------------------------

    MaterialLabelfield get _labelfield1 => MaterialLabelfield.widget(dom.querySelector("#labelfield1"));
    MaterialLabelfield get _labelfield2 => MaterialLabelfield.widget(dom.querySelector("#labelfield2"));
    MaterialTextfield get _textfield => MaterialTextfield.widget(dom.querySelector("#textfield"));
    MaterialLabelfield get _labelfield3 => MaterialLabelfield.widget(dom.querySelector("#labelfield3"));
    MaterialLabelfield get _labelfield4 => MaterialLabelfield.widget(dom.querySelector("#labelfield4"));
    MaterialBadge get _badge => MaterialBadge.widget(dom.querySelector(".mdl-badge"));
    MaterialButton get _button => MaterialButton.widget(dom.querySelector(".mdl-button"));
    MaterialCheckbox get _checkbox => MaterialCheckbox.widget(dom.querySelector("#checkbox-1"));
    MaterialRadio get _radioWifi1 => MaterialRadio.widget(dom.querySelector("#wifi1"));
    MaterialSwitch get _switch => MaterialSwitch.widget(dom.querySelector(".mdl-switch"));
}

main() async {
    configLogging();

    registerMdl();

    final MaterialApplication application = await componentFactory().
        rootContext(Application).run(enableVisualDebugging: true);

    application.run();
}


void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}