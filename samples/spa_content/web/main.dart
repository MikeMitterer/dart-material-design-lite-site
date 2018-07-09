import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:intl/intl.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';
import 'package:mus/mustache.dart';

import 'package:mdl/mdlapplication.dart';
import 'package:mdl/mdlobservable.dart';
import 'package:m4d_router/browser.dart';

import 'main.reflectable.dart';

class ModelChangedEvent { }

/// Model is a Singleton
@mustache
class Model {
    static Model _model;

    final StreamController<ModelChangedEvent> _controller = new StreamController<ModelChangedEvent>.broadcast();

    Stream<ModelChangedEvent> onChange;

    int _sliderValue = 20;

    List<int> randomValues = new List<int>();

    factory Model() {
        if(_model == null) {  _model = new Model._internal(); }
        return _model;
    }

    int get sliderValue => _sliderValue;

    set sliderValue(final int value) {
        _sliderValue = value;
        randomValues.clear();
        for(int counter = 0;counter < _sliderValue;counter++) {
            randomValues.add(new Math.Random().nextInt(1000));
        }
        _controller.add(new ModelChangedEvent());
    }

    //- private -----------------------------------------------------------------------------------

    Model._internal() {
        onChange = _controller.stream;
    }
}


main() async {
    final Logger _logger = new Logger('main.MaterialContent');
    final Model model = new Model();
    final router = new Router();

    configLogging(show: Level.INFO);
    initializeReflectable();

    registerMdl();

    await componentFactory().run();

    _configRouter(router);

    final MaterialSlider mainslider = MaterialSlider.widget(dom.querySelector("#mainslider2"));
    final MaterialContent list = MaterialContent.widget(dom.querySelector("#list"));
    final MaterialMustache mustache = MaterialMustache.widget(dom.querySelector("#mustache"));

    mustache.template = """
        <div>
            Slider value: {{sliderValue}}
                <ol>
                {{#randomValues}}
                    <li>{{ . }},</li>
                {{/randomValues}}
                {{^randomValues }}
                    <li>No values</li>
                {{/randomValues }}
                </ol>
        </div>""";

    mainslider.value = model.sliderValue;

    mainslider.onInput.listen((_) => model.sliderValue = mainslider.value);

    model.onChange.listen((_) {

        String items() {
            final StringBuffer line = new StringBuffer();
            for(int counter = 0; counter < model.sliderValue; counter++) {
                final String id = "${counter + 1}";

                line.write("<li>");
                line.write("Item #${id}");
                line.write('<button id="btn$id" class="mdl-button mdl-button--raised mdl-button--colored mdl-ripple-effect">Button #${id}</button>');
                line.write("</li>");
            }
            return line.toString();
        }

        new Future(() {
            mainslider.value = model.sliderValue;
            _logger.info("Model ${model.sliderValue}");

            list.render("<ul>" + items() + "</ul>").then((_) {
                for(int counter = 0; counter < model.sliderValue; counter++) {
                    final dom.Element element  = list.element.querySelector("#btn${counter+1}");

                    // check for null - if elements are added to fast it could be possible that
                    // the element you are searching for was already removed
                    if(element != null) {
                        element.onClick.listen((final dom.MouseEvent event) {
                            dom.window.alert("Clicked on Button #${counter+1}");
                        });

                    }
                }
            });
        });

        mustache.render(model);
    });
}

@mustache
class Day {
    final DateTime _date;

    Day(this._date);

    String get name => new DateFormat("E").format(_date);
    String get date => new DateFormat.yMd().format(_date);
}

/// If you have observable-Properties in your Controller it must be
/// marked as [@Model]
@mustache
class ObservableController extends MaterialController implements ScopeAware {
    final time = new ObservableProperty<String>("",interval: new Duration(seconds: 1));
    final days = new ObservableList<Day>();

    @override
    void loaded(final RouteEvent event) {
        time.observes(() => _getTime());
        for(int counter = 0; days.length < 7 ;counter++) {
            days.add(new Day(new DateTime.now().add(new Duration(days: counter))));
        }
    }

    @override
    Scope get scope => new Scope(this);

    // - private ------------------------------------------------------------------------------------------------------

    String _getTime() {
        final DateTime now = new DateTime.now();
        return "${now.hour.toString().padLeft(2,"0")}:${now.minute.toString().padLeft(2,"0")}:${now.second.toString().padLeft(2,"0")}";
    }
}

class DemoController extends MaterialController {
    final Model _model = new Model();

    MaterialSlider _slider5;
    MaterialSlider _slider2;

    @override
    void loaded(final RouteEvent event) {
        _slider5 = MaterialSlider.widget(dom.querySelector("#slider5"));
        _slider2 = MaterialSlider.widget(dom.querySelector("#slider2"));

        if(_slider5 == null) {
            // ERROR-PAGE not slider 5
            return;
        }

        _slider5.value = _model.sliderValue;
        _slider2.value = _model.sliderValue;

        _slider5.hub.onChange.listen((_) => _model.sliderValue = _slider5.value);
        _slider2.hub.onChange.listen((_) => _model.sliderValue = _slider2.value);


        _model.onChange.listen((_) => _modelChanged());
    }

    // - private ------------------------------------------------------------------------------------------------------

    void _modelChanged() {
        _slider5.value = _model.sliderValue;
        _slider2.value = _model.sliderValue;
    }

}

void _configRouter(final Router router ) {
    final logger = new Logger('main.configRouter');
    final view = new ViewFactory();

    router
        ..addRoute(name: "Test0", path: new UrlPattern('/#/test0'),
            enter: (final RouteEvent event) {
                logger.info(event);
            })

        ..addRoute(name: 'test', path: new ReactPattern('/test'),
            enter: view("views/test.html", new DummyController()))

        ..addRoute(name: "Test3", path: new ReactPattern(r'/names/(\w+)'),
            enter: (final RouteEnterEvent event) {
                logger.info("Path: ${event.path} Params: ${event.params.join(",")}");
            })

        ..addRoute(name: "Test2", path: new ReactPattern('/names'),
            enter: (final RouteEvent event) {
                logger.info(event);
            })

        ..addRoute(name: 'slider', path: new ReactPattern('/slider'),
            enter: view("views/slider.html", new DemoController()))

    ;

    router.onEnter.listen((final RouteEnterEvent event) {
        logger.info("RoutEvent ${event.route.title} -> ${event.route.urlPattern.pattern}");
    });

    router.onError.listen((final RouteErrorEvent event) {
        logger.info("RouteErrorEvent ${event.exception}");
    });

    router.listen(); // Start listening

//    router.root
//
//        ..addRoute(name: 'test', path: '/test',
//            enter: view("views/test.html", new DummyController()))
//
//        ..addRoute(name: 'test2', path: '/test2',
//            enter: view("views/test2.html", new ObservableController()))
//
//        ..addRoute(name: 'slider', path: '/slider',
//            enter: view("views/slider.html", new DemoController()))
//
//        ..addRoute(name: 'error', path: '/error',
//            enter: view("views/doesnotexist.html", new DemoController()))
//
//        ..addRoute(name: 'home', defaultRoute: true, path: '/',
//            enter: view("views/home.html" ,new DummyController()))
//
//    ;
//
//    router.listen();

}

