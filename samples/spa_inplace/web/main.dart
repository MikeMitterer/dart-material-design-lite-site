import "dart:async";

import 'package:console_log_handler/console_log_handler.dart';
import 'package:dryice/dryice.dart';

import 'package:mdl/mdl.dart';

import 'package:mdl_inplace_edit_sample/components.dart';
import 'package:mdl_inplace_edit_sample/stores.dart';

import 'main.reflectable.dart';

@Component @inject
class Application extends MaterialApplication {
    //final Logger _logger = new Logger('main.Application');

    Application() {
    }

    @override
    void run() {

    }

//- private -----------------------------------------------------------------------------------

}

Future main() async {
    // final Logger _logger = new Logger('main.Inplace edit');

    configLogging();
    initializeReflectable();

    registerMdl();
    registerInplaceSampleComponents();

        final MaterialApplication application = await componentFactory()
            .rootContext(Application)
            .addModule(new SampleModule1())
            .run();

        application.run();
}

/**
 * Demo Module
 */
class SampleModule1 extends Module {
    configure() {
        install(new StoreModule());

        // -- services

        // -- stores
    }
}
