import "dart:async";
/**
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import "dart:html" as dom;

import 'package:console_log_handler/console_log_handler.dart';
import 'package:dryice/dryice.dart' as di;
import 'package:logging/logging.dart';
import 'package:mdl/mdl.dart';
import 'package:mdl/mdlanimation.dart';
import "package:mdl/mdldialog.dart";
import 'package:mdl/mdlobservable.dart';
import 'package:route/browser.dart';
import "package:spa_template/dialogs.dart";

final MdlAnimation bounceInRight = new MdlAnimation.fromStock(StockAnimation.BounceInRight);
final MdlAnimation fadeIn = new MdlAnimation.fromStock(StockAnimation.FadeIn);

/**
 * Application - you can get the Application via final Application app = componentFactory().application;
 * Sample:
 *      final Application app = componentFactory().application;
 */
@di.injectable
class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');
    final Router _router = new Router(useFragment: true);

    /// Title will be displayed
    final ObservableProperty<String> title = new ObservableProperty<String>("");

    /// Adds "debug" class to body!
    final ObservableProperty<bool> checkDebug = new ObservableProperty<bool>(false);

    /// Make the Properties always visible
    final ObservableProperty<bool> keepProperties = new ObservableProperty<bool>(false);

    /// Shows the Drawer permanently
    final ObservableProperty<bool> fixDrawer = new ObservableProperty<bool>(false);

    bool isUserLoggedIn = false;

    Application() {
        _logger.info("Application created");
        _bindSignals();
    }

    @override
    void run() {
        //        _login().then((final MdlDialogStatus status) {
        //            _checkStatus(status);
        //        });
        isUserLoggedIn = true;
        _checkStatus(MdlDialogStatus.OK);
    }

    void go(final String routePath, final Map params) {
        _router.go(routePath, params);
    }

    //- private -----------------------------------------------------------------------------------

    void _bindSignals() {
        final MaterialButton login = MaterialButton.widget(dom.querySelector("#login"));
        login.onClick.listen((final dom.Event event) async {
            event.preventDefault();

            final MdlDialogStatus status = await _login();
            _checkStatus(status);
        });

        final MaterialButton properties = MaterialButton.widget(dom.querySelector("#showprops"));
        properties.onClick.listen((final dom.Event event) async {
            event.preventDefault();

            final dom.Element body = dom.querySelector("body");
            body.classes.toggle("show-properties");

            final dom.Element properties = dom.querySelector(".mdl-properties");
            if (properties != null) {
                AnimationState.removeAllStatesFrom(properties);
            }

            if (body.classes.contains("show-properties")) {
                bounceInRight(properties).then((_) {
                    AnimationState.setState(properties, AnimationState.last);
                    _logger.info("Animation completed!");
                });
            }
        });
    }

    Future<MdlDialogStatus> _login() async {
        final LoginDialog dialog = new LoginDialog();
        final MdlDialogStatus status = await dialog(title: "Login").show();

        if (status == MdlDialogStatus.OK) {
            _logger.info("You entered - username: ${dialog.username.value}, password: ${dialog.password.value}");
        }

        return status;
    }

    void _checkStatus(final MdlDialogStatus status) {
        _logger.info("Status: ${status}");
        isUserLoggedIn = (status == MdlDialogStatus.OK);

        if (isUserLoggedIn) {
            go("view1", {});
        }
        else {
            go("home", {});
        }
    }
}

class ApplicationModule extends di.Module {
    @override
    configure() {
        // TODO: implement configure
    }
}

main() async {
    // final Logger _logger = new Logger('main.MaterialContent');

    configLogging();

    registerMdl();
    registerMdlDND();

    final Application application = await componentFactory().rootContext(Application)
        .addModule(new ApplicationModule()).run();

    configRouter(application._router, (final RoutePreEnterEvent event) {
        event.allowEnter(new Future<bool>(() => application.isUserLoggedIn));
    });

    application.run();

    //- private -----------------------------------------------------------------------------------

}

/// Default Controller!!!
class DefaultController extends MaterialController {
    static final Logger _logger = new Logger('main.DefaultController');

    @override
    void loaded(final Route route) {
        final Application app = componentFactory().application;
        app.title.value = route.name;

        _logger.info("DefaultController loaded!");
    }
// - private ------------------------------------------------------------------------------------------------------
}

class ControllerView1 extends DefaultController {
    static final Logger _logger = new Logger('main.ControllerView1');

    @override
    void loaded(final Route route) {
        super.loaded(route);
        _logger.info("ControllerView1 loaded!");
    }

    @override
    void unload() {
        _logger.info("ControllerView1 unloaded!");
    }
// - private ------------------------------------------------------------------------------------------------------
}

class ControllerView2 extends DefaultController {
    static final Logger _logger = new Logger('main.ControllerView2');

    bool keepPropertiesState;

    @override
    void loaded(final Route route) {
        super.loaded(route);

        final Application app = componentFactory().application;
        keepPropertiesState = app.keepProperties.value;
        app.keepProperties.value = true;

        _logger.info("ControllerView2 loaded!");
    }

    @override
    void unload() {
        final Application app = componentFactory().application;
        app.keepProperties.value = keepPropertiesState;
        _logger.info("ControllerView2 unloaded!");
    }
// - private ------------------------------------------------------------------------------------------------------
}

class ControllerView3 extends DefaultController {
    static final Logger _logger = new Logger('main.ControllerView3');

    @override
    void loaded(final Route route) {
        super.loaded(route);
        _logger.info("ControllerView3 loaded!");
    }

    @override
    void unload() {
        _logger.info("ControllerView3 unloaded!");
    }
// - private ------------------------------------------------------------------------------------------------------
}

void configRouter(final Router router, final RoutePreEnterEventHandler routeChecker) {
    final ViewFactory view = new ViewFactory();

    router.root..addRoute(name: 'view1', path: '/view1',
        enter: view("views/view1.html", new ControllerView1()),
        preEnter: routeChecker)..addRoute(name: 'view2', path: '/view2',
        enter: view("views/view2.html", new ControllerView2()),
        preEnter: routeChecker)..addRoute(name: 'view3', path: '/view3',
        enter: view("views/view3.html", new ControllerView2()),
        preEnter: routeChecker)

    /// Leave default-route as the last one
        ..addRoute(name: 'home', defaultRoute: true, path: '/',
            enter: view("views/home.html", new DefaultController()))

    ;

    router.listen();
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}