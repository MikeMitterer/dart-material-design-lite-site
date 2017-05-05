import "dart:html" as dom;
import "dart:async";
import "dart:math" as math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:dice/dice.dart' as di;

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlobservable.dart';
import 'package:chartjs/chartjs.dart';

final Logger _logger = new Logger('mdl_plotly_sample.main');

@MdlComponentModel
class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    Application() {
    }

    @override
    void run() {
        _initStats();
    }

    //- private -----------------------------------------------------------------------------------

    void _initStats() {
        var rnd = new math.Random();
        var months = <String>["January", "February", "March", "April", "May", "June"];

        final LinearChartData data = new LinearChartData(labels: months, datasets: <ChartDataSets>[
            new ChartDataSets(
                label: "My First dataset",
                backgroundColor: "rgba(220,220,220,0.2)",
                data: months.map((_) => rnd.nextInt(100)).toList()),
            new ChartDataSets(
                label: "My Second dataset",
                backgroundColor: "rgba(151,187,205,0.2)",
                data: months.map((_) => rnd.nextInt(100)).toList())
        ]);

        final ChartConfiguration config = new ChartConfiguration(
            type: 'line', data: data, options: new ChartOptions(responsive: true));

        final Chart chart = new Chart(dom.querySelector('#canvas') as dom.CanvasElement, config);

        new Timer.periodic(new Duration(milliseconds: 500),(_) {
            data.datasets.first.data[1] = rnd.nextInt(100);
            data.datasets.first.data[2] = rnd.nextInt(100);
            chart.update();
        });
    }
}

main() async {
    final Logger _logger = new Logger('main.Shows Plotly in action');

    configLogging();

    registerMdl();

    final MaterialApplication application = await componentFactory().
        rootContext(Application).run(enableVisualDebugging: true);

    application.run();
}


void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}