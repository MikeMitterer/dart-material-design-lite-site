import "dart:async";

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:dryice/dryice.dart' as di;

import 'package:mdl/mdl.dart';

import 'package:mdl_inplace_edit_sample/components.dart';
import 'package:mdl_inplace_edit_sample/stores.dart';

@MdlComponentModel
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
            .addModule(new SampleModule1())
            .run();

        application.run();
}

/**
 * Demo Module
 */
class SampleModule1 extends di.Module {
    configure() {
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