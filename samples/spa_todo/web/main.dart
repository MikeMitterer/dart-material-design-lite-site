import "dart:async";

import 'package:console_log_handler/console_log_handler.dart';
import 'package:dryice/dryice.dart';

import 'package:mdl/mdl.dart';

import "package:mdl_todo_sample/src/interfaces.dart";
import "package:mdl_todo_sample/components.dart";
import "package:mdl_todo_sample/datastore.dart";

import 'main.reflectable.dart';

@Model @inject
class Application implements MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    /// Added by the MDL/Dart-Framework (mdlapplication.dart)
    final ActionBus _actionbus;

    @inject
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
    initializeReflectable();

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
class SampleModule extends Module {
    configure() {
        final store = new ToDoDataStore(new ActionBus());
        register(ToDoInputStoreInterface).toInstance(store);
        register(ToDoListStoreInterface).toInstance(store);
    }
}

