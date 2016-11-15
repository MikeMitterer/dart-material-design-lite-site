import "dart:async";

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:di/di.dart' as di;

import 'package:mdl/mdl.dart';

import 'package:mdl_inplace_edit_sample/components.dart';
import 'package:mdl_inplace_edit_sample/stores.dart';

@MdlComponentModel @di.Injectable()
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

    registerMdl();
    registerInplaceSampleComponents();

        final MaterialApplication application = await componentFactory()
            .rootContext(Application)
            .addModule(new SampleModule())
            .run();

        application.run();
}

/**
 * Demo Module
 */
class SampleModule extends di.Module {
    SampleModule() {
        install(new StoreModule());

        // -- services

        // -- stores
    }
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}