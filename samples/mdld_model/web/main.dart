import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:dice/dice.dart' as di;

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlobservable.dart';

@MdlComponentModel
class ModelTest {
    final ObservableProperty<String> minimodel = new ObservableProperty<String>("test");

    final ObservableProperty<String> os1 = new ObservableProperty<String>("");
    final ObservableProperty<String> os2 = new ObservableProperty<String>("");

    final ObservableProperty<String> wifi = new ObservableProperty<String>("never");

    final List<ObservableProperty<String>> lights = [ new ObservableProperty<String>(""), new ObservableProperty<String>("") ];

    final ObservableProperty<int> intensity = new ObservableProperty<int>(90);
}

@MdlComponentModel
class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    final ModelTest modelTest = new ModelTest();

    Application() {
        _bind();
    }

    @override
    void run() {
    }

    //- private -----------------------------------------------------------------------------------

    void _bind() {
        modelTest.os1.onChange.listen((final PropertyChangeEvent event) {
            _logger.info("OS1-Value changed from: ${event.oldValue} to ${event.value}");
        });
    }
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