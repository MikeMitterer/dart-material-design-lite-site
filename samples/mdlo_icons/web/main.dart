import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'main.reflectable.dart';

main() async {
    configLogging();
    initializeReflectable();
    
    registerMdl();

    await componentFactory().run();
}

