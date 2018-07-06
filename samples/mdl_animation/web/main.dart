import 'dart:async';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'package:mdl/mdldemo.dart';

import 'main.reflectable.dart';

Future main() async {
    configLogging();
    initializeReflectable();

    // registerDemoAnimation and import mdldemo.dart is only necessary for animation sample
    registerDemoAnimation();
    registerMdl();

    await componentFactory().run();
}
