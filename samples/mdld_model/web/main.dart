import 'package:console_log_handler/console_log_handler.dart';

import 'package:dryice/dryice.dart';
import 'package:reflected_mustache/mustache.dart';

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlobservable.dart';

import 'main.reflectable.dart';

@inject @mustache
class ModelTest {
    final ObservableProperty<String> minimodel = new ObservableProperty<String>("test");

    final ObservableProperty<String> os1 = new ObservableProperty<String>("");
    final ObservableProperty<String> os2 = new ObservableProperty<String>("");

    final ObservableProperty<String> wifi = new ObservableProperty<String>("never");

    final List<ObservableProperty<String>> lights = [ new ObservableProperty<String>(""), new ObservableProperty<String>("") ];

    final ObservableProperty<int> intensity = new ObservableProperty<int>(90);
}

@inject
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
    initializeReflectable();

    registerMdl();

    final MaterialApplication application = await componentFactory().
    rootContext(Application).run(enableVisualDebugging: true);

    application.run();
}
