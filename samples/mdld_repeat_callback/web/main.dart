import 'dart:async';
import 'dart:math';

import 'package:console_log_handler/console_log_handler.dart';
import 'package:dryice/dryice.dart';

import 'package:mdl/mdl.dart';
import 'package:mdl_repeat_callback_sample/components/interfaces.dart';
import 'package:mdl_repeat_callback_sample/components.dart';
import 'package:mdl_repeat_callback_sample/datastore.dart';

import 'main.reflectable.dart';

@inject
class Application implements MaterialApplication {
    //final Logger _logger = new Logger('main.Application');

    final ActionBus _actionbus;

    @inject
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
    initializeReflectable();

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
class SampleModule extends Module {
    configure() {
        register(SampleStore).toType(SampleStoreImpl).asSingleton();
    }
}
