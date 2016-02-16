import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:di/di.dart' as di;

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlobservable.dart';

import 'package:mdl_inplace_edit_sample/components.dart';
import 'package:mdl_inplace_edit_sample/model.dart';

@MdlComponentModel @di.Injectable()
class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    final ObservableList<Person> persons = new ObservableList<Person>();

    Application() {
    }

    @override
    void run() {
        persons.add(new Person("Marilyn","Monroe",36, """
            Marilyn Monroe (1926-1962) Model, actress, singer and arguably
            one of the most famous women of the twentieth century.
        """.trim().replaceAll(new RegExp(r"\s+")," ")));

        persons.add(new Person("Abraham","Lincoln",56, """
            Abraham Lincoln was born Feb 12, 1809, in Hardin Country, Kentucky.
            His family upbringing was modest; his parents from Virginia were neither wealthy or well known.
            At an early age, the young lincolnAbraham lost his mother and his father moved away to Indiana.
        """.trim().replaceAll(new RegExp(r"\s+")," ")));

        persons.add(new Person("Agnes","Gonxha Bojaxhiu",87, """
            Mother Teresa (1910-1997) was a Roman Catholic nun, who devoted her life to serving
            the poor and destitute around the world. She spent many years in Calcutta,
            India where shed founded the Missionaries of Charity, a religious congregation
            devoted to helping those in great need.
        """.trim().replaceAll(new RegExp(r"\s+")," ")));

    }

    //- private -----------------------------------------------------------------------------------

}

main() async {
    final Logger _logger = new Logger('main.Inplace edit');

    configLogging();

    registerMdl();
    registerInplaceSampleComponents();

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