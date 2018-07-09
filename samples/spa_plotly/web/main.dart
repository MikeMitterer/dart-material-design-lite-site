import "dart:html" as dom;
import "dart:async";
import "dart:math" as math;

import 'package:console_log_handler/console_log_handler.dart';
import 'package:dryice/dryice.dart';
import 'package:reflected_mustache/mustache.dart';

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlobservable.dart';
import 'package:plotly/plotly.dart';

import 'main.reflectable.dart';

final Logger _logger = new Logger('mdl_plotly_sample.main');

@inject @mustache
class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    Application() {
    }

    @override
    void run() {
        _initStats();
    }

    //- private -----------------------------------------------------------------------------------

    static final List<String> _labels = <String>[ "2014", "2015", "2016", "2017" ];

    static final Map<String,dynamic> _trace1 = <String,dynamic>{
        'x' : _labels,
        'y': [16, 5, 11, 10],
        'mode': 'lines',
        'line': {'shape': 'spline'},
        "name": "My Trace",
    };

    static final Map<String,dynamic> _trace2 = <String,dynamic>{
        'x' : _labels,
        'y': [12, 5, 15, 12],
        'mode': 'lines+markers'
    };

    void _initStats() {
        final dom.HtmlElement div = dom.querySelector(".stats");

        final _data = [ _trace1, _trace2];

        var layout = <String, dynamic>{'title': false, 'height': 500, 'width': div.clientWidth,
            "showlegend" : false,
            "margin": {
                "l": 50,
                "r": 50,
                "b": 50,
                "t": 5,
                "pad": 4
            },
            "xaxis" : {
                "showticklabels": true,
                "showgrid" : true,
                "showline" : true,
                "zeroline" : true,
                "fixedrange":false,
                "gridwidth" : 5,
                "ticktext" :  <String>[ "A1", "B1", "C1", "D1" ],
                "tickangle" : -45,
                "tickformat" : ":%s",
                "autorange" : true,
                "autotick" : false
            },
            "yaxis" : {
                "zeroline" : true,
            }
        };

        final Plot plot = new Plot.selector('.stats', _data, layout, displayModeBar: false, scrollZoom: false);

        plot.onClick.listen((event) {
            _logger.fine('click: $event');
        });
        plot.onHover.listen((event) {
            _logger.fine('hover: $event');
        });

        plot.on("plotly_beforeplot")
            .listen((event) => _logger.fine("plotly_beforeplot: $event"));

        plot.on("plotly_afterplot")
            .listen((event) => _logger.fine("plotly_afterplot: $event"));

        plot.on("plotly_beforeexport")
            .listen((event) => _logger.fine("plotly_beforeexport: $event"));

        Timer debounce;
        dom.window.onResize.listen((final dom.Event event) {
            _logger.fine("W: ${div.clientWidth}");

            debounce ?.cancel();
            debounce = new Timer(new Duration(milliseconds: 100),() {
                layout["width"] = div.clientWidth;
                layout["height"] = div.clientWidth  / 2;
                plot.relayout(layout);
            });
        });

        final math.Random rnd = new math.Random();

        new Timer.periodic(new Duration(milliseconds: 500),(_) {
            plot.data[1]["y"][2] = rnd.nextInt(17);
            plot.redraw();
        });
    }
}

main() async {
    final Logger _logger = new Logger('main.Shows Plotly in action');

    configLogging();
    initializeReflectable();

    registerMdl();

    final MaterialApplication application = await componentFactory().
        rootContext(Application).run(enableVisualDebugging: true);

    application.run();
}

