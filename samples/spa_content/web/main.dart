import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:intl/intl.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart' as mdl;
import 'package:mustache/mustache.dart';

import 'package:mdl/mdlapplication.dart';
import 'package:mdl/mdlobservable.dart';
import 'package:route_hierarchical/client.dart';

import 'main.reflectable.dart';

class ModelChangedEvent { }

/// Model is a Singleton
@mdl.Model @mustache
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


main() {
    final Logger _logger = new Logger('main.MaterialContent');
    final Model model = new Model();

    configLogging();
    initializeReflectable();

    mdl.registerMdl();

    mdl.componentFactory().run().then((_) {
        configRouter();

        final mdl.MaterialSlider mainslider = mdl.MaterialSlider.widget(dom.querySelector("#mainslider2"));
        final mdl.MaterialContent list = mdl.MaterialContent.widget(dom.querySelector("#list"));
        final mdl.MaterialMustache mustache = mdl.MaterialMustache.widget(dom.querySelector("#mustache"));

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

    });
}

@mdl.Model
class _Day {
    final DateTime _date;

    _Day(this._date);

    String get name => new DateFormat("E").format(_date);
    String get date => new DateFormat.yMd().format(_date);
}

/// If you have observable-Properties in your Controller it must be
/// marked as [@mdl.Model]
@mdl.Model
class ObservableController extends mdl.MaterialController implements ScopeAware {
    final time = new ObservableProperty<String>("",interval: new Duration(seconds: 1));
    final days = new ObservableList<_Day>();

    @override
    void loaded(final Route route) {
        time.observes(() => _getTime());
        for(int counter = 0; days.length < 7 ;counter++) {
            days.add(new _Day(new DateTime.now().add(new Duration(days: counter))));
        }
    }

    @override
    mdl.Scope get scope => new mdl.Scope(this);

    // - private ------------------------------------------------------------------------------------------------------

    String _getTime() {
        final DateTime now = new DateTime.now();
        return "${now.hour.toString().padLeft(2,"0")}:${now.minute.toString().padLeft(2,"0")}:${now.second.toString().padLeft(2,"0")}";
    }
}

class DemoController extends mdl.MaterialController {
    final Model _model = new Model();

    mdl.MaterialSlider _slider5;
    mdl.MaterialSlider _slider2;

    @override
    void loaded(final Route route) {
        _slider5 = mdl.MaterialSlider.widget(dom.querySelector("#slider5"));
        _slider2 = mdl.MaterialSlider.widget(dom.querySelector("#slider2"));

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

void configRouter() {
    final router = new Router(useFragment: true);
    final view = new ViewFactory();

    router.root

        ..addRoute(name: 'test', path: '/test',
            enter: view("views/test.html", new mdl.DummyController()))

        ..addRoute(name: 'test2', path: '/test2',
            enter: view("views/test2.html", new ObservableController()))

        ..addRoute(name: 'slider', path: '/slider',
            enter: view("views/slider.html", new DemoController()))

        ..addRoute(name: 'error', path: '/error',
            enter: view("views/doesnotexist.html", new DemoController()))

        ..addRoute(name: 'home', defaultRoute: true, path: '/',
            enter: view("views/home.html" ,new mdl.DummyController()))

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