import "dart:async";

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:dryice/dryice.dart' as di;

import 'package:mdl/mdl.dart';

import "package:mdl_todo_sample/src/interfaces.dart";
import "package:mdl_todo_sample/components.dart";
import "package:mdl_todo_sample/datastore.dart";

@Model @di.inject
class Application implements MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    /// Added by the MDL/Dart-Framework (mdlapplication.dart)
    final ActionBus _actionbus;

    @di.inject
    Application(this._actionbus) {
    }

    @override
    void run() {
        _bindSignals();
    }

    //- private -----------------------------------------------------------------------------------

    void _bindSignals() {
        // Not necessary - just a demonstration how to listen to the "global" ActionBus
        _actionbus.on(AddItemAction.NAME).listen((_) {
            _logger.info("User clicked on 'Add'!");
        });
    }
}

Future main() async {
    // final Logger _logger = new Logger('main.ToDo');

    configLogging();

    registerMdl();
    registerToDoComponents();

    final MaterialApplication application = await componentFactory().rootContext(Application)
        .addModule(new SampleModule())
        .run();

    application.run();

}

/**
 * Application-Config via DI
 */
class SampleModule extends di.Module {
    configure() {
        final store = new ToDoDataStore(new ActionBus());
        register(ToDoInputStoreInterface).toInstance(store);
        register(ToDoListStoreInterface).toInstance(store);
    }
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}
