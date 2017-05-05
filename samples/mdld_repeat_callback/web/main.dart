import 'dart:async';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:dice/dice.dart' as di;

import 'package:mdl/mdl.dart';
import 'package:mdl_repeat_callback_sample/components/interfaces.dart';
import 'package:mdl_repeat_callback_sample/components.dart';
import 'package:mdl_repeat_callback_sample/datastore.dart';

@MdlComponentModel
class Application implements MaterialApplication {
    //final Logger _logger = new Logger('main.Application');

    final ActionBus _actionbus;

    @di.inject
    Application(this._actionbus);

    @override
    void run() {
        new Timer.periodic(new Duration(milliseconds: 500),(_) {
            final List<RandomItem> items = new List<RandomItem>();

            DateTime next = new DateTime.now();
            for(int counter = 0;counter < 20;counter++) {
                items.add(new RandomItem(next,new Random().nextInt(99) + (counter * 100) ));
                next = next.add(new Duration(days: 1));
            }
            _actionbus.fire(new ModelChangedAction(items));
        });
    }

    //- private -----------------------------------------------------------------------------------
}

main() async {
    configLogging();

    registerMdl();
    registerRepeatCallbackComponents();

    final Application application = await componentFactory().rootContext(Application)
        .addModule(new SampleModule())
        .run();
    
    application.run();
}

/**
 * Application-Config via DI
 */
class SampleModule extends di.Module {
    configure() {
        register(SampleStore).toType(SampleStoreImpl).asSingleton();
    }
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}