import 'package:console_log_handler/console_log_handler.dart';
import 'package:dryice/dryice.dart';

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlobservable.dart';

import 'main.reflectable.dart';

@inject
class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    final ObservableProperty<bool> checkBorder = new ObservableProperty<bool>(false);

    Application() {
        _logger.info("CTOR Application");

    }

    @override
    void run() {
    }

    //- private -----------------------------------------------------------------------------------

}

main() async {
    configLogging();
    initializeReflectable();

    registerMdl();

    final MaterialApplication application = await componentFactory().
        rootContext(Application).run(enableVisualDebugging: true);

    application.run();
}
